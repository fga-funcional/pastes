{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

import GHC.Generics
import Data.Text.Lazy.IO as I
import Data.Aeson.Text (encodeToLazyText)



import Web.Scotty

import Control.Concurrent.MVar
import qualified Data.Map.Strict as M
import Network.HTTP.Types
import Control.Monad.IO.Class
import Network.Wai.Middleware.Cors
import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)





type Name = String

type Code = String

data CCode = CCode
  { codename :: String,
    lines :: [String],
    syntax :: String
  } deriving (Show, Generic)
instance ToJSON CCode 
instance FromJSON CCode

allcodes = 
  [ CCode "factorial" [ "def fat(n):" , "if n == 1:" , "return 1" , "return n * fat(n - 1)" ] "Python"
    ,CCode "hello world" [ "print(hello world)" ] "Python"
  ] 
allCodes :: M.Map Name [Code]
allCodes = M.fromList
    [ ("factorial",
        [ "def fat(n):"
        , "if n == 1:"
        , "return 1"
        , "return n * fat(n - 1)"
        ]
      )
    ]

-- TODO: Implement!
validateName :: Name -> Bool
validateName = const True

validateCodes :: [Code] -> Bool
validateCodes codes = length codes == 6

main :: IO ()
main = do
    codes' <- newMVar allCodes
    I.writeFile "myfile.json" (encodeToLazyText allcodes)

    scotty 3000 $ do
        middleware simpleCors

        -- Retorna todas as tarefas.
        get "/codes" $ do
            -- codes <- liftIO $ readMVar codes'
            json allcodes

        -- Recupera as tarefas de um dia.
        -- Ex: GET /codes/2018-01-01
        get "/codes/:name" $ do
            codes <- liftIO $ readMVar codes'
            name <- param "name"
            json $ M.lookup name codes

        -- Cadastra novas tarefas no dia especificado.
        post "/codes" $ do
            newCodes <- jsonData :: ActionM CCode 
            json newCodes
        -- Atualiza a lista de tarefas do dia especificado.
        put "/codes/:name" $ do
            name <- param "name"
            newCodes <- jsonData
            if not (validateName name && validateCodes newCodes)
               then status status400
               else do
                   updated <- liftIO $ modifyMVar codes' $ \codes ->
                       if M.member name codes
                          then return (M.update (\_ -> Just newCodes) name codes, True) 
                          else return (codes, False) 
                   if updated
                      then status status200
                      else status status404

        -- Exclui todas as tarefas do dia especificado.
        delete "/codes/:name" $ do
            name <- param "name"
            liftIO $ modifyMVar_ codes' $ \codes ->
                return $ M.delete name codes


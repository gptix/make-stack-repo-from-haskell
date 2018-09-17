{-# LANGUAGE OverloadedStrings #-}

-- DONE: enable passing arguments from command line (github user id, name of project/repo to build)
-- DONE: build string (:: IsString Text) for remote URL
-- DONE: Study how to combine let and do
-- DONE: make a function like proc that takes one 2-tuple (command, [arg]) and evaluates to
--      proc command [arg] empty
-- DONE: then map that fn over a list of 2-tuples to consolidate many lines of proc...
-- DONE: learn how to convert a String to a Text --- import qualified Data.Text as T //  (T.pack string)

module Main where

import Turtle
import Data.Text 
import Options.Applicative
import Data.Semigroup ( (<>) )

data NewProjectParams = NewProjectParams
  { repoName       :: String
  , githubUserName :: String
  , localGitDir    :: String }

paramsParser :: Parser NewProjectParams
paramsParser = NewProjectParams
      <$> strOption
          ( long "project-repo-name"
         <> short 'r'
         <> metavar "REPONAME"
         <> help "Name to attach to new project and repo." )
      <*> strOption
          ( long "github-name"
         <> short 'g'
         <> metavar "GITHUB-NAME"
         <> value "gptix"
         <> help "User name at github.com." )
      <*> strOption
          ( long "local-github-directory"
         <> short 'l'
         <> metavar "LOCAL-DIR"
         <> help "Path to local directory for project."
         <> value "/home/gt/gitstuff" )

type ProcCmd = Text
type ProcArg = Text
  
procEmpty :: MonadIO io => (ProcCmd, [ProcArg]) -> io ExitCode
procEmpty (comd, args) = proc comd args Turtle.empty

 
main :: IO ()
main = createStackProject =<< execParser opts
  where
    opts = info (paramsParser <**> helper)
      ( fullDesc
     <> progDesc "Create stack project; initialize git; create repo on github.com; add/commit/push."
     <> Options.Applicative.header "A stack project and git repo maker/sync'er." )


createStackProject :: MonadIO io => NewProjectParams -> io ()
createStackProject (NewProjectParams repoName githubUserName localGitDir) =
  let rText = pack repoName
      gText = pack githubUserName in

    do
  
      cd $ fromString localGitDir
      procEmpty  ("stack", ["new", rText, "simple"])
      cd $ fromString ("./" ++ repoName ++ "/")
      mapM_ procEmpty [ ("stack", ["setup"])
                      , ("git", ["init"]) 
                      , ("git", ["add", "."])
                      , ("git", ["commit", "-m", "\"Initial commit.\""])
                      , ("git", ["remote", "add", "origin", Data.Text.concat ["git@github.com:", gText, "/", rText] ])
                      , ("hub", ["create", "-d", rText])
                      , ("git", ["push", "origin", "master"]) ]
  


--githubUserName :: Text
--githubUserName = "gptix"

--repoName :: Text
--repoName = "foo"

--localGitDir :: String
--localGitDir = "/home/gt/gitstuff"

--gitHubSSHString :: Text
--gitHubSSHString = Data.Text.concat ["git@github.com:", githubUserName, pack "/",repoName]

-- tempty = Turtle.empty


{-  
-- this one works
main =
  -- I want these three variables to be populated by values passed by a command line parser.
  let localGitDir    = (  "/home/gt/gitstuff" :: String)
      repoName       = (  "test-optparse"               :: Text) 
      githubUserName = (  "gptix"             :: Text) in 
    do
      cd $ fromString localGitDir
      procEmpty  ("stack", ["new", repoName, "simple"])
      cd $ fromString ("./" ++ (unpack repoName) ++ "/")
      mapM_ procEmpty [ ("stack", ["setup"])
                      , ("git", ["init"]) 
                      , ("git", ["add", "."])
                      , ("git", ["commit", "-m", "\"Initial commit.\""])
                      , ("git", ["remote", "add", "origin", Data.Text.concat ["git@github.com:", githubUserName, "/", repoName] ])
                      , ("hub", ["create", "-d", repoName])
                      , ("git", ["push", "origin", "master"]) ]
-}


{-
-- this one works  
main = do
    cd $ fromString localGitDir
    procEmpty  ("stack", ["new", repoName, "simple"])
    cd $ fromString ("./" ++ (unpack repoName) ++ "/")
    procEmpty ("stack", ["setup"])
    procEmpty ("git", ["init"]) 
    procEmpty ("git", ["add", "."])
    procEmpty ("git", ["commit", "-m", "\"Initial commit.\""])
    procEmpty ("git", ["remote", "add", "origin", Data.Text.concat ["git@github.com:", githubUserName, "/", repoName] ])
    procEmpty ("hub", ["create", "-d", repoName])
    procEmpty ("git", ["push", "origin", "master"])
-}
  
{-
-- this one works  
main = do
    cd $ fromString localGitDir
    proc "stack" ["new", repoName, "simple"] tempty
    cd $ fromString ("./" ++ (unpack repoName) ++ "/")
    proc "stack" ["setup"] tempty
    proc "git" ["init"] tempty
    proc "git" ["add", "."] tempty
    proc "git" ["commit", "-m", "\"Initial commit.\""] tempty
    proc "git" ["remote", "add", "origin", Data.Text.concat ["git@github.com:", githubUserName, "/", repoName] ] tempty
    proc "hub" ["create", "-d", repoName] tempty
    proc "git" ["push", "origin", "master"] tempty 
   
-- should be something like
      
main = do
    cd locaGitDir
    procEmpty ("stack", ["new", repoName, "simple"])
    cd repoName
    mapM_ procEmpty [ ("stack", ["setup"])
                  , ("git",   ["init"])
                  , ("git",   ["add",    "."])
                  , ("git",   ["commit", "-m",     "\"Initial commit.\""])
                  , ("git",   ["remote", "add",    "origin",                gitHubSSHString])
                  , ("hub",   ["create", "-d",     "foo"])
                  , ("git",   ["push",   "origin", "master"])] -}

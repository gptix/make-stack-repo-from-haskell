{-# LANGUAGE OverloadedStrings #-}

-- TODO:
-- enable passing arguments from command line (github user id, name of project/repo to build)
-- build string (:: IsString Text) for remote URL
-- Study how to combine let and do
-- make a function like proc that takes one 2-tuple (command, [arg]) and evaluates to
--      proc command [arg] empty
-- then map that fn over a list of 2-tuples to consolidate many lines of proc...
-- DONE: learn how to convert a String to a Text --- import qualified Data.Text as T //  (T.pack string)



module Main where

import Turtle


--githubUserName :: String
--githubUserName = "gptix"

--repoName :: String
--repoName = "foo"

--locaGitDir :: String
--localGitDir = "/home/gt/gitstuff"
-- or
--localGitdire = T.pack "/home/gt/gitstuff"

--gitHubSSHString :: Text
--gitHubSSHString = T.pack $ concat ["git@github.com:", githubUserName, "/", repoName)

--type ProcCmd = Text
--type ProcArg = Text
 
--procEmpty MonadIO io => (ProcCmd, [ProcArg]) -> io ExitCode
--procEmpty (comd, args) = proc comd args (empty :: Shell Line)

--map procEmpty (   cmdArgsPairs :: [  ( ProcComd, [ProcArg] )  ]   )
--map procEmpty [ ("stack", ["setup"])
--              , ("git", ["init"]),
--              , ("git", ["add","."])
--              , ("git", ["commit","-m","\"Initial commit.\""])]


main = do
    cd "/home/gt/gitstuff/"
    proc "stack" ["new", "foo", "simple"] empty 
    cd "./foo/"
    proc "stack" ["setup"] empty
    proc "git" ["init"] empty
    proc "git" ["add", "."] empty
    proc "git" ["commit", "-m", "\"Initial commit.\""] empty
    proc "git" ["remote", "add", "origin", "git@github.com:gptix/foo"] empty
    proc "hub" ["create", "-d", "foo"] empty
    proc "git" ["push", "origin", "master"] empty 


-- should be something like
      
{-main = do
    cd locaGitDir
    procEmpty ("stack", ["new", repoName, "simple"])
    cd repoName
    map procEmpty [ ("stack", ["setup"])
                  , ("git",   ["init"])
                  , ("git",   ["add",    "."])
                  , ("git",   ["commit", "-m",     "\"Initial commit.\""])
                  , ("git",   ["remote", "add",    "origin",                gitHubSSHString])
                  , ("hub",   ["create", "-d",     "foo"])
                  , ("git",   ["push",   "origin", "master"])]
-}

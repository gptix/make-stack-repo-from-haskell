{-# LANGUAGE OverloadedStrings #-}

-- TODO:
-- enable passing arguments from command line (github user id, name of project/repo to build)
--[x] build string (:: IsString Text) for remote URL
-- Study how to combine let and do
-- make a function like proc that takes one 2-tuple (command, [arg]) and evaluates to
--      proc command [arg] empty
-- then map that fn over a list of 2-tuples to consolidate many lines of proc...
-- DONE: learn how to convert a String to a Text --- import qualified Data.Text as T //  (T.pack string)

module Main where

import Turtle
import Data.Text 

githubUserName :: Text
githubUserName = "gptix"

repoName :: Text
repoName = "foo"

localGitDir :: String
localGitDir = "/home/gt/gitstuff"

gitHubSSHString :: Text
gitHubSSHString = Data.Text.concat ["git@github.com:", githubUserName, pack "/", repoName]

type ProcCmd = Text
type ProcArg = Text

tempty = Turtle.empty
  
procEmpty :: MonadIO io => (ProcCmd, [ProcArg]) -> io ExitCode
procEmpty (comd, args) = proc comd args Turtle.empty

-- I'd like to replace many lines in the main block with something like the following:
--map procEmpty [ ("stack", ["setup"])
--              , ("git", ["init"]),
--              , ("git", ["add","."])
--              , ("git", ["commit","-m","\"Initial commit.\""])]
-- Question: map will collect a structure of results of applying its function to each set of data in a node of map's target.
-- I need to create something that can be returned.


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

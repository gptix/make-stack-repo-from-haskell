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

localGitDir :: Text
localGitDir = "/home/gt/gitstuff"

gitHubSSHString :: Text
gitHubSSHString = Data.Text.concat ["git@github.com:", githubUserName, pack "/", repoName]

type ProcCmd = Text
type ProcArg = Text

  
procEmpty :: MonadIO io => (ProcCmd, [ProcArg]) -> io ExitCode
procEmpty (comd, args) = proc comd args Turtle.empty

-- I'd like to replace many lines in the main block with something like the following:
--map procEmpty [ ("stack", ["setup"])
--              , ("git", ["init"]),
--              , ("git", ["add","."])
--              , ("git", ["commit","-m","\"Initial commit.\""])]
-- Question: map will collect a structure of results of applying its function to each set of data in a node of map's target.
-- I need to create something that can be returned.


  
main = do
    cd "/home/gt/gitstuff/"
    proc "stack" ["new", repoName, "simple"] Turtle.empty
    cd "./foo/"
    proc "stack" ["setup"] Turtle.empty
    proc "git" ["init"] Turtle.empty
    proc "git" ["add", "."] Turtle.empty
    proc "git" ["commit", "-m", "\"Initial commit.\""] Turtle.empty
    proc "git" ["remote", "add", "origin", "git@github.com:gptix/foo"] Turtle.empty
    proc "hub" ["create", "-d", "foo"] Turtle.empty
    proc "git" ["push", "origin", "master"] Turtle.empty 




      
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

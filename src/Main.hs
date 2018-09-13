{-# LANGUAGE OverloadedStrings #-}

-- TODO:
-- enable passing arguments from command line (github user id, name of project/repo to build)
-- build string (:: IsString Text) for remote URL
-- Study how to combine let and do
-- make a function like proc that takes one 2-tuple (command, [arg]) and evaluates to
--      proc command [arg] empty
-- then map that fn over a list of 2-tuples to consolidate many lines of proc...
-- learn how to convert a String to a Text

module Main where

import Turtle


-- need to know how to do this.  I want the result of the concatenation be able to be used as an element in the list of 'strings' that are used as args by proc
--gitHubSSHString :: IsString Text
--gitHubSSHString = "git@github.com:" ++ "gptix" ++ "/" ++ "foo"
-- repoName :: Text
-- repoName = "foo"

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


{-
procEmpty cd args = proc cd args empty
procEmpty (aCommand,args) = proc aCommand args empty

map procEmpty [("git", ["init"]),
             , ("git", ["add","."])
             , ("git", ["commit","-m","\"Initial commit.\""])]
-}
  

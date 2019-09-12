{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Prelude.Compat

import Data.Monoid       ((<>))
import Data.Text         (Text, pack)
import qualified Data.Text.IO as T

import qualified GitHub.Endpoints.Repos as GH
import GitHub.Data.Name (Name ( N ))

main :: IO ()
main = do
  _ <- T.putStrLn "Enter github user to scan:"
  user <- T.getLine
  possibleRepos <- GH.userRepos (N user) GH.RepoPublicityOwner
  T.putStrLn $ either formatError formatRepos possibleRepos

formatError :: GH.Error -> Text
formatError = ("Error" <>) . pack . show

formatRepos :: Foldable a => a GH.Repo -> Text
formatRepos = foldMap ((<> "\n") . formatRepo)

formatRepo :: GH.Repo -> Text
formatRepo = GH.getUrl . GH.repoHtmlUrl

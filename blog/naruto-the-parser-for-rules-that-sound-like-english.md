---
title: "Naruto: the parser for rules that sound like English"
date: 2026-09-22
excerpt: NaRuTo is the Natural Rule Tool, an enhanced fork of the NRL parser. You can argue with the name, not with the grammar.
---
# Naruto: the parser for rules that sound like English

NaRuTo stands for Natural Rule Tool. It is an enhanced fork of the Natural Rule Language parser, and yes, the name is a pun on both NRL and the show. It is not about ninja. It is about parsing sentences that describe constraints on a system and turning them into something a program can check.

The original NRL parser took rules like "if a packet is TCP, the source must be this address" and turned them into structured constraints. NaRuTo keeps that idea and widens it in three ways.

First, the grammar grew. More expression forms, more constructs, so rules can capture relationships that the original could not express without contortions.

Second, the mapping engines grew. NRL originally ran its mappings through Java programs. NaRuTo lets you write the mapping in the language you already have: Python, JavaScript, anything that can execute against your data structures. That was the change that made the tool usable outside the Java world.

Third, it talks to CLiX and XML directly. Rules can read and transform XML documents, which is useful when the thing you are describing is a config tree or a database dump rather than a packet.

It is a Maven project, the README still assumes Eclipse, and there is a joke in the repo name that I stand behind. It also happens to be the parser under the good half of the pipe in other projects of mine that turn plain language into network filter rules. Zero stars, no complaints. The grammar is what matters, and it is a lot of grammar.

It exists, it parses, and the tests pass. That is the honest summary of another really fun project.

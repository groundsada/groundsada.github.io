---
title: "Jaily: say it in English, get BPF"
date: 2026-09-22
excerpt: A Java transpiler that turns sentences about packet filtering into working BPF, from the NRL days. Just assume intelligence like yours.
---
# Jaily: say it in English, get BPF

Jaily is a transpiler I built that reads network rules written more or less in English and writes Berkeley Packet Filter rules they can actually apply. The name is a recursion joke: it stands for Just Another Interpreter Like Yours, and the GitHub description says Just Assume Intelligence Like Yours. Both are true, in different moods.

The input is NRL, the Natural Rule Language. NRL rules read like instructions instead of config files:

    If Packet.TCPFlow then IPSrc must be '192.168.1.1'

Under the hood Jaily is a Java program with two halves: a parser that turns NRL into an intermediate model, and a code generator that emits BPF. The interesting parts are the ones that were not trivial to get right: stateful rules, where a filter needs to know whether a packet belongs to an established flow, and manual packet manipulation, where you are touching bytes that were not on the wire when you started.

After generation, a small C toolchain loads the BPF onto the interface, so the whole pipeline is one thing you can point at a PCAP and watch filter. That is how it was evaluated: a pile of rule files, a pile of packet captures, and a ledger of what should have matched.

It came out of the days when I was spending evenings on packet paths, and it pairs with Naruto, the NRL parser I wrote for the same language family (it is a parser for a grammar, not an anime). The general idea was always that configuring a distributed system's filtering should not require translating an English sentence into a architecture-specific rule table for each magic string.

It is not installed on anything you own. It exists, it works, and the tests pass. That is the honest summary of a really fun project.

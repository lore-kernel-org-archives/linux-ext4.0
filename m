From: Paul Richter <iamcomcy@gmail.com>
Subject: Ext4 Filesystem recovery ...
Date: Sat, 21 Jan 2012 09:23:10 +0300
Message-ID: <CAHw_BJ3w84hoeW5-XsNWaRZPp5vB4Jp_ecdQ86iauEw4qHPyFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2AUGXK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jan 2012 01:23:10 -0500
Received: by iacb35 with SMTP id b35so659025iac.19
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2012 22:23:10 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey guys,

I am trying to recover 8Tb after a raid failure. RAID issues seem to
be resolved, but cannot mount the fs,

dmesg says:
 EXT4-fs (md127): bad geometry: block count 1953512448 exceeds size of
device (1953509376 blocks)

OS sees ext4

have complete dd back of fs, so I can kick it around

debugfs cannot see fs structure.

fsck tried to fix every inode, but at 500M inodes (and would take a
month to complete), that far exceeds used inodes

Am I beating a dead horse here, or is there some hope for recovery?

Thanks in advance,

Paul

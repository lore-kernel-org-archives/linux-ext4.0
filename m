From: Paul Richter <iamcomcy@gmail.com>
Subject: Re: Ext4 Filesystem recovery ...
Date: Sun, 22 Jan 2012 23:14:41 +0300
Message-ID: <CAHw_BJ3QR7CkYSN_23=BPXVvaLEZFvZfvkuMt5Mb67TX4UTdmg@mail.gmail.com>
References: <CAHw_BJ3w84hoeW5-XsNWaRZPp5vB4Jp_ecdQ86iauEw4qHPyFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52193 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2AVUOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Jan 2012 15:14:42 -0500
Received: by iacb35 with SMTP id b35so2638172iac.19
        for <linux-ext4@vger.kernel.org>; Sun, 22 Jan 2012 12:14:42 -0800 (PST)
In-Reply-To: <CAHw_BJ3w84hoeW5-XsNWaRZPp5vB4Jp_ecdQ86iauEw4qHPyFQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey guys,
I am trying to recover 8Tb after a raid failure. RAID issues seem to
be resolved, but cannot mount the fs,
 dmesg says:
 =C2=A0EXT4-fs (md127): bad geometry: block count 1953512448 exceeds si=
ze of
 device (1953509376 blocks)

 OS sees ext4

 have complete dd back of fs, so I can kick it around

 debugfs cannot see fs structure.

 fsck tried to fix every inode, but at 500M inodes (and would take a
 month to complete), that far exceeds used inodes

 Am I beating a dead horse here, or is there some hope for recovery?

 Thanks in advance,

 Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: Kernel 3.7.0: bad header/extent
Date: Sun, 16 Dec 2012 01:00:25 -0200
Message-ID: <50cd394d.0153650a.3b8d.ffffb917@mx.google.com>
References: <kainf9$btc$1@ger.gmane.org>
	<20121216022753.GD9016@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55327 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2LPDAa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Dec 2012 22:00:30 -0500
Received: by mail-gg0-f174.google.com with SMTP id k2so936952ggd.19
        for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2012 19:00:30 -0800 (PST)
In-Reply-To: <20121216022753.GD9016@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 15 Dec 2012 21:27:53 -0500
Theodore Ts'o <tytso@mit.edu> wrote:

> > 	So I tried to run e2fsck and it "fixed" inode 9311628. Running 
> > e2fsck again doesn't detect any errors, but the problem remains.
> 
> What do you mean "the problem remains"?  Are you getting the same
> EXT4-fs error message when you try to access the file?
> 
> Can you send the output of the command:
> 
> 	debugfs -R "stat <9311628>"/dev/sda2

	Hi Ted! Yes, I get the same EXT4-fs message when I try to
access teh file. Here's the requested output:

debugfs 1.41.12 (17-May-2010)
Inode: 9311628   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 834245655    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 7117
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4f76ba2c:537fd694 -- Sat Mar 31 05:02:52 2012
 atime: 0x50ccaf85:c6d93344 -- Sat Dec 15 15:12:37 2012
 mtime: 0x4f76ba2c:537fd694 -- Sat Mar 31 05:02:52 2012
crtime: 0x4f76ba2c:537fd694 -- Sat Mar 31 05:02:52 2012
Size of extra inode fields: 28
EXTENTS:

	***

	If you need more testing, just ask. Thanks!

-- 
Linux 3.7.0: Terrified Chipmunk
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br

From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: (unknown)
Date: Thu, 22 Jan 2009 09:56:09 +0100
Message-ID: <20090122085609.GA29546@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: pavel@suse.cz, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43446 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752438AbZAVI4N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 03:56:13 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As suggested by pavel i tested how e2fsck handles corrupted images,
I used the fuzzer bunny (http://code.google.com/p/bunny-the-fuzzer/)
At http://www.cccmz.de/~snakebyte/e2fsck_err.tar.bz2 you
can find a bunch of images crashing e2fsck or keeping it in an endless
loop. I tested with e2fsck 1.41.0 which was the one i had at hand.

The crashes are either in ext2fs_inode_alloc_stats2() or
ext2fs_read_inode_full(), looks like those are always the same
faults.

000	endless loop
000	endless loop
053	ext2fs_inode_alloc_stats2
054	ext2fs_inode_alloc_stats2
073	different endless loop?
086	ext2fs_inode_alloc_stats2
112	ext2fs_read_inode_full
139	ext2fs_inode_alloc_stats2
143	ext2fs_inode_alloc_stats2
161	ext2fs_inode_alloc_stats2
192	ext2fs_inode_alloc_stats2
209	ext2fs_inode_alloc_stats2
214	endless loop
216	ext2fs_read_inode_full
241	endless loop
266	endless loop
303	ext2fs_inode_alloc_stats2
389	ext2fs_inode_alloc_stats2
438	ext2fs_inode_alloc_stats2
440	endless loop
446	ext2fs_inode_alloc_stats2
449	ext2fs_read_inode_full
451	ext2fs_read_inode_full
455	ext2fs_read_inode_full
518	ext2fs_inode_alloc_stats2
530	ext2fs_inode_alloc_stats2
534	ext2fs_inode_alloc_stats2

Greetings, Eric

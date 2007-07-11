From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Subject: Ext4 online resizing
Date: Wed, 11 Jul 2007 12:33:50 +0200
Message-ID: <200707111233.50374.philipp.marek@bmlv.gv.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.bmlv.gv.at ([193.171.152.37]:59436 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236AbXGKK5T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 06:57:19 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.bmlv.gv.at (mail.bmlv.gv.at) with ESMTP id 2CA5C540BBB
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 12:33:51 +0200 (CEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello everybody,

sorry for this question if it has been asked before; I couldn't find 
information about this.

Please keep me CC'ed - I'm not subscribed. Thank you.


Ext2/3 have ext2resize/resize2fs, ext2prepare and ext3online for resizing.
But they don't work for ext4.

Here's a sample output for a 64MB loopback-mounted file:
	# ext2online -C -f -d tst
	ext2online v1.1.19 - 2001/03/18 for EXT2FS 0.5b
	ext2_open
	ext2_bcache_init
	ext2_determine_itoffset
	setting itoffset to +259
	ext2_get_reserved
	Found 255 blocks in s_reserved_gdt_blocks

	8 old groups, 1 blocks
	32 new groups, 1 blocks
	ext2_ioctl: EXTEND group to 65537 blocks

	using itoffset of 259
	new block bitmap is at 0x10001
	new inode bitmap is at 0x10002
	new inode table is at 0x10104-0x10203
	new group has 7934 free blocks
	new group has 2048 free inodes (256 blocks)
	ext2_ioctl: ADD group 8
	ext2online: ext2_ioctl: Inappropriate ioctl for device

	ext2online: unable to resize /tmp/tst

That this doesn't work could be caused by my old ext2online version;
	# ext2online -V
	ext2online v1.1.19 - 2001/03/18 for EXT2FS 0.5b
but what makes me wonder is that the sf project 
http://ext2resize.sourceforge.net/download.html still lists 1.19 as current.
Should that work for ext4 too?

	# cat /proc/version
	Linux version 2.6.22-rc5-686 (Debian 2.6.22~rc5-1~experimental.1)
 		(waldi@debian.org) (gcc version 4.1.3 20070601 (prerelease) (Debian
		4.1.2-12)) #1 SMP Wed Jun 27 22:21:14 UTC 2007

There's a resize.c in the ext4 directory 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=fs/ext4;h=e509c1bf9448c343b7a4666dae4dfed0afe228ad;hb=HEAD
so I'd thought that it should include that functionality.

What am I doing wrong?


Thank you for all answers.


Regards,

Phil

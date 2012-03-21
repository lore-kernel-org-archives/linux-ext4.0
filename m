From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH v1 0/8] do not use s_dirt in ext2
Date: Wed, 21 Mar 2012 18:14:27 +0200
Message-ID: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch-set makes ext2 independent of the VFS superblock management
services. Namely, ext2 does not require to register the 'write_super()' VFS
call-back.

The reason of this exercises is to get rid of the 'sync_supers()' kernel thread
which wakes up every 5 seconds (by default) even if all superblocks are clean.
This is wasteful from power management POW (unnecessary wake-ups).

Note, I tried to optimize 'sync_supers()' instead in 2010, but Al wanted me
to get rid of it instead. See https://lkml.org/lkml/2010/6/6/87
And I think this is right because many file-systems do not need this, for
example btrfs does not use VFS superblock management services at all, so on a
btrfs-based system we currently end-up useless periodic wake-ups source.

I have sent a similar patch-set for ext4 recently to Ted, see:
http://lkml.org/lkml/2012/3/20/220

Changes for other file-systems are coming later.

The patch-set structure.
1. patch 1 exports 'dirty_writeback_interval' and I also sent it as part of the
   ext4 patch-set
2. patch 2 is also and independent VFS clean-up and I also sent it as part of
   the ext4 patch-set
3. patch 3 is an independent ext2 clean-up patch
4. patches 4-8 actually make ext2 independent on the 'sync_supers()' thread.

Thanks,
Artem.

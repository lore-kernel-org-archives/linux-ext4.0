From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/2] On disk format changes - V3
Date: Thu, 15 Sep 2011 18:50:50 -0400
Message-ID: <1316127052-1890-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57954 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935257Ab1IOWuz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 18:50:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the hopefully the final set of on-disk format changes.  The main
change from the last one is I split up the inode checksum field so that
half of the checksum is in the first 128 bytes of the inode (with 16
bits left over as a spare for emergencies) and the high 16 bits of the
crc32 is using what was previously the i_pad field in a 256 byte (and
larger) inode.

Please scream if you see any problems, because otherwise this is what's
going in!

The second patch adds support so that debugfs can easily handle setting
data objects which are split between a foo_hi and foo_lo fields on disk.

Along the way I also fixed some bugs where we weren't byte-swapping the
newer fields in the 256-byte inode (i.e., ctime_extra, mtime_extra,
etc.).

						- Ted

Theodore Ts'o (2):
  libext2fs: add metadata checksum and snapshot feature flags
  debugfs: add 64-bit support to the set_field commands

 debugfs/debugfs.h           |    2 +
 debugfs/set_fields.c        |  452 ++++++++++++++++++++++++++++---------------
 debugfs/util.c              |   16 ++
 e2fsck/pass1.c              |    4 +-
 lib/e2p/feature.c           |    4 +
 lib/e2p/ls.c                |    4 +
 lib/ext2fs/ext2_fs.h        |   31 ++-
 lib/ext2fs/swapfs.c         |   16 ++-
 lib/ext2fs/tst_inode_size.c |    3 +-
 lib/ext2fs/tst_super_size.c |    1 +
 10 files changed, 359 insertions(+), 174 deletions(-)

-- 
1.7.4.1.22.gec8e1.dirty


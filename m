From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] ext2, ext3, udf updates for 3.9-rc1
Date: Fri, 22 Feb 2013 16:25:07 +0100
Message-ID: <20130222152507.GD15083@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab3BVPZM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2013 10:25:12 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

  to get several UDF fixes, a support for UDF extent cache, and couple of
ext2 and ext3 cleanups and minor fixes.

Top of the tree is 712ddc5. The full shortlog is:

Guo Chao (1):
      ext3, ext4, ocfs2: remove unused macro NAMEI_RA_INDEX

Jan Kara (5):
      ext3: Fix memory leak when quota options are specified multiple times
      udf: Write LVID to disk after opening / closing
      udf: Fix bitmap overflow on large filesystems with small block size
      udf: Make s_block_bitmap standard array
      udf: Remove unused s_extLength from udf_bitmap

Namjae Jeon (1):
      udf: add extent cache support in case of file reading

Wang Shilong (9):
      Ext2: free memory allocated and forget buffer head when io error happens
      Ext3: add necessary check in case IO error happens
      Ext2: use unlikely to improve the efficiency of the kernel
      Ext3: use unlikely to improve the efficiency of the kernel
      Ext2: return ENOMEM rather than EIO if sb_getblk fails
      Ext3: return ENOMEM rather than EIO if sb_getblk fails
      Ext2: remove the overhead check about sb in the function ext2_new_blocks
      Ext2: mark inode dirty after the function dquot_free_block_nodirty is called
      Ext2: remove the static function release_blocks to optimize the kernel

The diffstat is

 fs/ext2/balloc.c |   28 ++++++-----------
 fs/ext2/inode.c  |   12 +++++++
 fs/ext2/super.c  |    2 +-
 fs/ext2/xattr.c  |    4 +-
 fs/ext3/inode.c  |   16 ++++++----
 fs/ext3/namei.c  |    1 -
 fs/ext3/resize.c |   12 ++++----
 fs/ext3/super.c  |   51 +++++++++++++++++++-------------
 fs/ext3/xattr.c  |    4 +-
 fs/ext4/namei.c  |    1 -
 fs/ocfs2/dir.c   |    1 -
 fs/udf/inode.c   |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/udf/super.c   |   11 ++++---
 fs/udf/udf_i.h   |   16 ++++++++++
 fs/udf/udf_sb.h  |    5 +--
 fs/udf/udfdecl.h |    5 ---
 16 files changed, 177 insertions(+), 78 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

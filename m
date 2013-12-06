From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 00/30] e2fsprogs: inline data refinement patch set
Date: Fri,  6 Dec 2013 17:57:47 +0800
Message-ID: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39811 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3LFJzW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:22 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so798337pbb.0
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the third version of inline data patch set for e2fsprogs.  In
this version, I made most changes according to Darrick's comments.  As
always any comment or suggestion are welcome.

Ted, patch 01 ~ 08 are taken from Darrick's patchbomb.  I don't touch
them.  Please let me know if I can do something for your review.

Darrick, I don't pick up your patch that tries to handle _DIR_NO_SPACE
error in ext2fs_link() because after applied that path some tests won't
pass.  So I prefer to put this problem into TODO list.

changelog:
v3:
 * Check inline_data feature in extended attribute API [patch 09]
 * Define a new interface (ext2fs_dirent_swab_in2/out2) [patch 10] for
	inline data and use them in ext2fs_inline_data_dir_iterate()
	[patch 11, 14]
 * Define a new flag (BLOCK_INLINE_DATA_CHANGED) to reflect that inline
	data has been changed [patch 17]
 * Use ext2fs_bmap2() in ext2fs_inline_data_expand() [patch 17]
 * Return EXT2_ET_INLINE_DATA_NO_BLOCK in ext2fs_bmap2() [patch 17]
 * Refactor out the code of ext2fs_inline_data_expand() [patch 19]
 * Remove useless variable 'start' [patch 19]
 * Typo fixes [patch 21,22]
 * Turn off inline_data feature in tune2fs [patch 22]
 * Change type from 'int' to 'unsigned int' for cache_size [patch 29]

v2: 
 * Rebase against e2fsprogs/next branch
 * Based against darrick's extended attribute API
 * Remove 'libext2fs: add INLINE_DATA into EXT2_LIB_SOFTSUPP_INCOMPAT'
	patch that has been applied
 * Refine the interface of inline data.  Now no any interface is
	exported to outside caller.  All interfaces are only exported
	for developers
 * Refactor ext2fs_inline_data_dir_iterate() so that it can call
	ext2fs_process_dir_block directly
 * Fix big-endian problem in handle parent inode in i_block
 * Remove ext2fs_inode_has_inline_data() interface
 * Export inode cache creation interface for unit test
 * Coding style fixes
 * Bug fixes

v1:
 * Revise the interfaces of liext2fs.

 * Implement ext2fs_punch_inline_data in lib/ext2fs/punch.c.  Now if you
   want to truncate an inode with inline data, you need to call
   ext2fs_punch(), and it will handle inline data.

 * Remove ext2fs_inline_data_dirsearch() function.  Now we don't support
   dirsearch command for an inode with inline data in debugfs.

 * Ext2fs_mkdir() refinement.  Now if we want to create a directory with
   inline data, we just need to call ext2fs_mkdir().  This function will
   try to create a new directory with inline data if inline_data feature
   is enabled.

 * Fix big-endian bug in some functions.  When ext2fs_read_inode() tries
   to read an inode into memory, it will handle big-endian by itself.
   Thus, we don't need to handle it manually.

 * Fix a bug in e2fsck/pass3.  When we try to expand a 'lost+found' dir,
   we don't need to handle inline data because this dir shouldn't have
   this flag.

Regards,
						- Zheng

Darrick J. Wong (8):
  libext2fs: support modifying arbitrary extended attributes
  libext2fs: various tweaks to the xattr editor APIs
  libext2fs: extend xattr api to query number of attrs
  libext2fs: fix memory leaks in extended attribute code
  libext2fs: fix block leak when releasing xattr block
  libext2fs: remove redundant code
  libext2fs: free key/value pairs before reading
  debugfs: dump all extended attributes

Zheng Liu (22):
  libext2fs: check inline_data in ext2fs_xattrs_read/write
  libext2fs: define new dirent_swab interfaces for inline data
  libext2fs: handle inline data in dir iterator function
  libext2fs: handle inline_data in block iterator function
  debugfs: make stat command support inline data
  debugfs: make expand command support inline data
  debugfs: make mkdir command support inline data
  debugfs: make lsdel command support inline data
  debugfs: handle inline_data feature in bmap command
  debugfs: handle inline data feature in punch command
  libext2fs: handle inline data in read/write function
  libext2fs: add inline_data feature into EXT2_LIB_FEATURE_INCOMPAT_SUPP
  mke2fs: add inline_data support in mke2fs
  tune2fs: add inline_data feature in tune2fs
  e2fsck: add problem descriptions and check inline data feature
  e2fsck: check inline_data in pass1
  e2fsck: check inline_data in pass2
  e2fsck: check inline_data in pass3
  tests: change result in f_bad_disconnected_inode
  mke2fs: enable inline_data feature on ext4dev filesystem
  libext2fs: export inode cahce creation function
  libext2fs: add a unit test for inline data

 debugfs/debugfs.c                       |  104 ++--
 debugfs/filefrag.c                      |   12 +-
 debugfs/lsdel.c                         |   20 +-
 e2fsck/pass1.c                          |   84 ++-
 e2fsck/pass2.c                          |  128 ++++-
 e2fsck/pass3.c                          |   12 +
 e2fsck/problem.c                        |   14 +
 e2fsck/problem.h                        |   10 +
 e2fsck/rehash.c                         |    2 +
 lib/ext2fs/Makefile.in                  |   16 +-
 lib/ext2fs/Makefile.pq                  |    1 +
 lib/ext2fs/bmap.c                       |    7 +
 lib/ext2fs/dblist_dir.c                 |   16 +-
 lib/ext2fs/dir_iterate.c                |   62 ++-
 lib/ext2fs/expanddir.c                  |    2 +
 lib/ext2fs/ext2_err.et.in               |   27 +
 lib/ext2fs/ext2_fs.h                    |   10 +
 lib/ext2fs/ext2fs.h                     |   48 +-
 lib/ext2fs/ext2fsP.h                    |   24 +-
 lib/ext2fs/ext_attr.c                   |  856 +++++++++++++++++++++++++++++++
 lib/ext2fs/fileio.c                     |  106 ++++
 lib/ext2fs/inline_data.c                |  811 +++++++++++++++++++++++++++++
 lib/ext2fs/inode.c                      |    8 +-
 lib/ext2fs/mkdir.c                      |   77 ++-
 lib/ext2fs/newdir.c                     |   25 +
 lib/ext2fs/punch.c                      |   28 +-
 lib/ext2fs/swapfs.c                     |   27 +-
 lib/ext2fs/valid_blk.c                  |    7 +
 misc/mke2fs.8.in                        |    3 +
 misc/mke2fs.c                           |   18 +-
 misc/mke2fs.conf.in                     |    2 +-
 misc/tune2fs.8.in                       |    3 +
 misc/tune2fs.c                          |   99 +++-
 tests/f_bad_disconnected_inode/expect.1 |    9 +
 tests/r_inline_xattr/expect             |    6 +-
 35 files changed, 2535 insertions(+), 149 deletions(-)
 create mode 100644 lib/ext2fs/inline_data.c

-- 
1.7.9.7


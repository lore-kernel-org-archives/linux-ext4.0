From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 00/28] e2fsprogs: inline data refinement patch set
Date: Tue,  3 Dec 2013 20:11:27 +0800
Message-ID: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61374 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3LCMJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:08 -0500
Received: by mail-pa0-f42.google.com with SMTP id lj1so2885729pab.29
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:08 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is my second round of inline data patch set refinement for
e2fsprogs.  In this version, the major change is to be based against
darrick's extended attribute API.  Now the patches have been rebased
against e2fsprogs/next branch.  Feel free to test it.  As always, any
comment or feedback are welcome.

Ted and Darrick give me a lot of comments.  Thank you!

Now all interfaces for inline data are defined as below:

/* initialize extented attribute to set 'system.data' */
errcode_t ext2fs_inline_data_init(ext2_filsys fs, ext2_ino_t ino);

/* get the size of inline data */
errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino,
 				 size_t *size);

/* remove inline data in extented attribute */
errcode_t ext2fs_inline_data_ea_remove(ext2_filsys fs, ext2_ino_t ino);

/* expand a directory/file */
errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino);

/* iterate on a directory with inline data */
errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
 			      ext2_ino_t ino,
 			      int (*func)(ext2_filsys fs,
 					  blk64_t     *blocknr,
 					  e2_blkcnt_t blockcnt,
 					  blk64_t     ref_blk,
 					  int	      ref_offset,
 					  void	      *priv_data),
 			      void *priv_data);

/* get inline data */
errcode_t ext2fs_inline_data_get(ext2_filsys fs, ext2_ino_t ino,
 				struct ext2_inode *inode,
 				void *buf, size_t *size);

/* set inline data */
errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
					struct ext2_inode *inode,
					void *buf, size_t size);

changelog:
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

Zheng Liu (20):
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

 debugfs/debugfs.c                       |   93 ++--
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
 lib/ext2fs/ext2_err.et.in               |   24 +
 lib/ext2fs/ext2_fs.h                    |   10 +
 lib/ext2fs/ext2fs.h                     |   34 +-
 lib/ext2fs/ext2fsP.h                    |   22 +
 lib/ext2fs/ext_attr.c                   |  844 +++++++++++++++++++++++++++++++
 lib/ext2fs/fileio.c                     |  108 ++++
 lib/ext2fs/inline_data.c                |  729 ++++++++++++++++++++++++++
 lib/ext2fs/inode.c                      |    8 +-
 lib/ext2fs/mkdir.c                      |   77 ++-
 lib/ext2fs/newdir.c                     |   25 +
 lib/ext2fs/punch.c                      |   28 +-
 lib/ext2fs/swapfs.c                     |   12 +-
 lib/ext2fs/valid_blk.c                  |    7 +
 misc/mke2fs.8.in                        |    3 +
 misc/mke2fs.c                           |   18 +-
 misc/mke2fs.conf.in                     |    2 +-
 misc/tune2fs.8.in                       |    5 +
 misc/tune2fs.c                          |   19 +-
 tests/f_bad_disconnected_inode/expect.1 |    9 +
 tests/r_inline_xattr/expect             |    6 +-
 35 files changed, 2333 insertions(+), 136 deletions(-)
 create mode 100644 lib/ext2fs/inline_data.c

-- 
1.7.9.7


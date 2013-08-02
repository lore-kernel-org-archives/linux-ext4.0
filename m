From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 00/22] e2fsprogs: inline data refinement patch set
Date: Fri,  2 Aug 2013 17:49:27 +0800
Message-ID: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52246 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab3HBJuA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:00 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so489908pab.7
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

== Intro ==
Here's my first to refine the inline data patch set for e2fsprogs.  This
patch set has slept on my own tree for a very long time.  Sorry for my
late.

As Ted suggested, I revise the interface of libext2fs.  Now the following
interfaces are exported in libext2fs.  In ext_attr.c file three new
functions are added:
 * ext2fs_ext_attr_ibody_find()
   This function tries to find an EA entry in an inode.  It just gets the
   start entry and end entry, and calls ext2fs_ext_attr_find_entry() to
   find that entry that we want to search.

 * ext2fs_ext_attr_find_entry()
   This function traverses the entries to find an entry.

 * ext2fs_ext_attr_set_entry()
   This function tries to set an entry in an inode.

In inline_data.c file there are some functions that need to be exported:
 * ext2fs_inode_has_inline_data()
   This function determine whether EXT4_INLINE_DATA_FL flag is set or not.

 * ext2fs_inline_data_get_size()
   It returns the size of inline data.

 * ext2fs_inline_data_iterate()
   It is used to traverse the directory entries of a directory with
   inline data.

 * ext2fs_inline_data_check()
   This function is used by e2fsck to make sure that the inline data is
   valid.

 * ext2fs_inline_data_create()
   It tries to create inline data in an inode.

 * ext2fs_read_inline_data()
   Read inline data from an inode and copy them to buffer.

 * ext2fs_write_inline_data()
   Write the data to an inode.

 * ext2fs_try_to_write_inline_data()
   Try to write the data to an inode if the size of data is smaller
   than the size of inline data.  Otherwise, it returns
   EXT2_ET_INLINE_DATA_NO_SPACE.

== Changelog ==
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

== TODO ==
 * Rebase against the latest e2fsprogs/master branch.

Here is the original Ted's git repo which tracks all original patches
[1].  I fork this repo in github.com and here is the url [2].  These
patches are against *e2fsprogs/pu* branch.

1. https://github.com/tytso/e2fsprogs-inline-patch-queue
2. https://github.com/gnehzuil/e2fsprogs-inline-patch-queue

Comments and feedbacks are all welcome.

Thanks,
						- Zheng

Zheng Liu (22):
  libext2fs: add INLINE_DATA into EXT2_LIB_SOFTSUPP_INCOMPAT
  libext2fs: add function to check inline_data flag for an inode
  libext2fs: add functions to operate on extended attribute
  libext2fs: handle inline data in dir iterator function
  libext2fs: handle inline_data in block iterator function
  debugfs: make stat command support inline data
  debugfs: make mkdir and expanddir command support inline data
  debugfs: make lsdel command support inline data
  libext2fs: handle inline data in read/write function
  debugfs: handle inline_data feature in dirsearch command
  debugfs: handle inline_data feature in bmap command
  debugfs: handle inline_data in punch command
  libext2fs: add inline_data feature into EXT2_LIB_FEATURE_INCOMPAT_SUPP
  mke2fs: add inline_data support in mke2fs
  tune2fs: add inline_data feature in tune2fs
  e2fsck: add problem descriptions and check inline data feature
  e2fsck: check inline_data in pass1
  e2fsck: check inline_data in pass2
  e2fsck: check inline_data in pass3
  tests: change result in f_bad_disconnected_inode
  mke2fs: enable inline_data feature on ext4dev filesystem
  libext2fs: add a unit test for inline data

 debugfs/debugfs.c                       |   11 +
 debugfs/htree.c                         |    4 +
 debugfs/lsdel.c                         |    3 +-
 e2fsck/pass1.c                          |  103 +++-
 e2fsck/pass2.c                          |  123 +++-
 e2fsck/pass3.c                          |   12 +
 e2fsck/problem.c                        |   15 +
 e2fsck/problem.h                        |    9 +
 e2fsck/rehash.c                         |    3 +-
 lib/ext2fs/Makefile.in                  |   16 +-
 lib/ext2fs/Makefile.pq                  |    1 +
 lib/ext2fs/block.c                      |    7 +
 lib/ext2fs/bmap.c                       |   15 +
 lib/ext2fs/dblist_dir.c                 |   10 +-
 lib/ext2fs/dir_iterate.c                |  102 +++-
 lib/ext2fs/expanddir.c                  |   18 +-
 lib/ext2fs/ext2_err.et.in               |   12 +
 lib/ext2fs/ext2_ext_attr.h              |   31 +
 lib/ext2fs/ext2_fs.h                    |    8 +
 lib/ext2fs/ext2fs.h                     |   42 +-
 lib/ext2fs/ext2fsP.h                    |   27 +
 lib/ext2fs/ext_attr.c                   |  186 ++++++
 lib/ext2fs/fileio.c                     |   19 +-
 lib/ext2fs/inline_data.c                |  966 +++++++++++++++++++++++++++++++
 lib/ext2fs/mkdir.c                      |  102 +++-
 lib/ext2fs/newdir.c                     |   33 ++
 lib/ext2fs/punch.c                      |   59 +-
 misc/mke2fs.8.in                        |    3 +
 misc/mke2fs.c                           |   14 +-
 misc/mke2fs.conf.in                     |    2 +-
 misc/tune2fs.8.in                       |    5 +
 misc/tune2fs.c                          |   17 +-
 tests/f_bad_disconnected_inode/expect.1 |    9 +
 33 files changed, 1908 insertions(+), 79 deletions(-)
 create mode 100644 lib/ext2fs/inline_data.c

-- 
1.7.9.7


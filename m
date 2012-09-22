From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 00/21 v5] e2fsprogs: make e2fsprogs support inline data
Date: Sat, 22 Sep 2012 12:00:48 +0800
Message-ID: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:55938 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2IVDu6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:50:58 -0400
Received: by dady13 with SMTP id y13so3245dad.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:50:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

Here is fifth try to make e2fsprogs support inline data.  In this version, all
patches are reworked according to Ted's comment, and now it is based on master
branch of e2fsprogs because part of this patch set has been applied.  Moreover,
it can handle new layout of inline data, which only stores parent inode number
in inode, and removes '.' and '..' directory entries.

v4->v5:
* rework all patches.
* handle new layout of inline data

v3->v4:
* [tune2fs] add inline data support
* [libext2fs] set EXT4_INLINE_DATA_FL to 0x1000000

v2->v3:
* [mke2fs] EXT4_FEATURE_INCOMPAT_INLINE_DATA is set back to 0x8000
* [mke2fs] enable inline_data on ext4dev filesystem
* [tests] modify a regression test in tests
* rebase to the latest pu branch of e2fsprogs
* fix some bugs

v1->v2:
* [mke2fs] automatically set EXT_ATTR feature when INLINE_DATA is set
* [debugfs] supports read-write mode

Regards,
Zheng
---
Zheng Liu (21):
      libext2fs: add INLINE_DATA into EXT2_LIB_SOFTSUPP_INCOMPAT
      libext2fs: add function to check inline_data flag for an inode
      libext2fs: add functions to operate extend attribute
      libext2fs: handle inline data in dir iterator function
      libext2fs: handle inline_data in block iterator function
      debugfs: make stat command support inline data
      libext2fs: handle inline data when expanding directory
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

 debugfs/debugfs.c                       |  13 +-
 debugfs/htree.c                         |   7 +
 debugfs/lsdel.c                         |   3 +-
 e2fsck/pass1.c                          | 104 +++++++++++-
 e2fsck/pass2.c                          | 123 +++++++++++----
 e2fsck/pass3.c                          |   8 +
 e2fsck/problem.c                        |  15 ++
 e2fsck/problem.h                        |   9 ++
 e2fsck/rehash.c                         |   3 +-
 lib/ext2fs/Makefile.in                  |   8 +
 lib/ext2fs/Makefile.pq                  |   1 +
 lib/ext2fs/block.c                      |   7 +
 lib/ext2fs/bmap.c                       |  15 ++
 lib/ext2fs/dblist_dir.c                 |  10 +-
 lib/ext2fs/dir_iterate.c                | 101 +++++++++++-
 lib/ext2fs/expanddir.c                  |  18 ++-
 lib/ext2fs/ext2_err.et.in               |   9 ++
 lib/ext2fs/ext2_ext_attr.h              |  30 ++++
 lib/ext2fs/ext2_fs.h                    |   7 +
 lib/ext2fs/ext2fs.h                     |  49 +++++-
 lib/ext2fs/ext2fsP.h                    |  18 +++
 lib/ext2fs/ext_attr.c                   | 169 ++++++++++++++++++++
 lib/ext2fs/fileio.c                     |  19 ++-
 lib/ext2fs/inline_data.c                | 896 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/mkdir.c                      |  18 ++-
 lib/ext2fs/punch.c                      |  10 +-
 misc/mke2fs.8.in                        |   3 +
 misc/mke2fs.c                           |  14 +-
 misc/mke2fs.conf.in                     |   2 +-
 misc/tune2fs.8.in                       |   5 +
 misc/tune2fs.c                          |  17 +-
 tests/f_bad_disconnected_inode/expect.1 |   9 ++
 32 files changed, 1665 insertions(+), 55 deletions(-)

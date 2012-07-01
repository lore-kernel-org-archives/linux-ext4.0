From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 00/35 v3] e2fsprogs: make e2fsprogs support inline data
Date: Sun,  1 Jul 2012 21:48:23 +0800
Message-ID: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab2GANku (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:40:50 -0400
Received: by pbbrp8 with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:40:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

Here is v3 for making e2fsprogs support inline data.

v2->v3:
* [mke2fs] EXT4_FEATURE_INCOMPAT_INLINE_DATA is set back to 0x8000
* [mke2fs] enable inline_data on ext4dev filesystem
* [tests] modify a regression test in tests
* rebase to the latest pu branch of e2fsprogs
* fix some bugs

v1->v2:
* [mke2fs] automatically set EXT_ATTR feature when INLINE_DATA is set
* [debugfs] supports read-write mode

Hi Ted,  I review the regression that you reported.  IMHO, it is not a
regression because in tests/f_bad_disconnected_inode test the flag quite
contains inline data.  So I think that this test needs to be changed.

Any comments are welcomed.  Thanks

Regards,
Zheng

Zheng Liu (35):
      libext2fs: add EXT4_FEATURE_INCOMPAT_INLINE_DATA flag
      mke2fs: make it support inline data feature
      mke2fs: add inline_data feature in mke2fs's manpage
      libext2fs: add ext2fs_find_entry_ext_attr function
      libext2fs: add EXT4_INLINE_DATA_FL flag for inode
      libext2fs: add data structures for inline data feature
      libext2fs: add inline_data file
      debugfs: make ncheck cmd support inline data
      debugfs: make icheck cmd support inline data
      debugfs: make chroot and cd cmd support inline data
      debugfs: make ls cmd support inline data
      debugfs: make stat cmd support inline data
      debugfs: make blocks cmd support inline data
      debugfs: make filefrag cmd support inline data
      debugfs: make link cmd support inline data
      debugfs: make unlink cmd support inline data
      debugfs: make mkdir cmd support inline data
      debugfs: make rmdir cmd support inline data
      debugfs: make rm and kill_file cmd support inline data
      debugfs: make pwd cmd support inline data
      debugfs: make expand_dir cmd support inline data
      debugfs: make lsdel cmd support inline data
      debugfs: make undelete cmd support inline data
      debugfs: make dump and cat cmd support inline data
      debugfs: make rdump cmd support inline data
      debugfs: make dirsearch cmd support inline data
      debugfs: make bmap cmd support inline data
      debugfs: make punch/truncate cmd support inline data
      e2fsck: add three problem descriptions in pass1
      e2fsck: check incorrect inline data flag
      e2fsck: make pass1 support inline data
      libext2fs: add read/write inline data functions
      e2fsck: check inline data in pass2
      mke2fs: add inline_data feature into ext4dev
      tests: change test f_bad_disconnected_inode to support inline_data feature

 debugfs/debugfs.c                       |   25 +-
 debugfs/dump.c                          |   38 ++-
 debugfs/filefrag.c                      |   30 +-
 debugfs/htree.c                         |    6 +
 debugfs/icheck.c                        |    9 +-
 debugfs/ls.c                            |    8 +-
 debugfs/lsdel.c                         |   19 +-
 debugfs/ncheck.c                        |    8 +-
 e2fsck/pass1.c                          |  109 +++++-
 e2fsck/pass1b.c                         |    5 +-
 e2fsck/pass2.c                          |   64 +++-
 e2fsck/problem.c                        |   15 +
 e2fsck/problem.h                        |    9 +
 lib/e2p/feature.c                       |    2 +-
 lib/ext2fs/Makefile.in                  |    5 +
 lib/ext2fs/Makefile.pq                  |    1 +
 lib/ext2fs/bmap.c                       |   16 +
 lib/ext2fs/dblist_dir.c                 |    8 +-
 lib/ext2fs/dirblock.c                   |   62 +++
 lib/ext2fs/expanddir.c                  |    8 +-
 lib/ext2fs/ext2_ext_attr.h              |    4 +
 lib/ext2fs/ext2_fs.h                    |   10 +-
 lib/ext2fs/ext2fs.h                     |   74 +++-
 lib/ext2fs/ext_attr.c                   |   26 ++
 lib/ext2fs/get_pathname.c               |    7 +-
 lib/ext2fs/inline_data.c                |  724 +++++++++++++++++++++++++++++++
 lib/ext2fs/link.c                       |    9 +-
 lib/ext2fs/lookup.c                     |    6 +-
 lib/ext2fs/mkdir.c                      |   33 ++-
 lib/ext2fs/punch.c                      |   33 ++-
 lib/ext2fs/unlink.c                     |    9 +-
 misc/mke2fs.8.in                        |    3 +
 misc/mke2fs.c                           |   10 +-
 misc/mke2fs.conf.in                     |    2 +-
 tests/f_bad_disconnected_inode/expect.1 |   27 +-
 35 files changed, 1329 insertions(+), 95 deletions(-)

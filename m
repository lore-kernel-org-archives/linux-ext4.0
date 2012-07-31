From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 00/36 v4] e2fsprogs: make e2fsprogs support inline data
Date: Tue, 31 Jul 2012 19:47:53 +0800
Message-ID: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLjr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:39:47 -0400
Received: by pbbrp8 with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:39:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

Here is v4 for making e2fsprogs support inline data.  In this patch set, the
major difference is that we can set inline_data feature when ext_attr enabled
in tune2fs.  We cannot clear inline_data feature because, when clearing this
feature, we need to allocate some blocks for inode which contains inline data,
and it may exhaust all of disk space.  Another modification is that
EXT4_INLINE_DATA_FL is set to 0x10000000 because the old value conflicts with
FS_NOCOW_FL in btrfs.

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

Zheng Liu (36):
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
      tune2fs: set inline_data feature

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
 misc/tune2fs.8.in                       |    5 +
 misc/tune2fs.c                          |   15 +-
 tests/f_bad_disconnected_inode/expect.1 |   27 +-
 37 files changed, 1348 insertions(+), 96 deletions(-)

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 0/4] Largedir support for e2fsprogs
Date: Mon, 13 Feb 2017 12:20:13 +0300
Message-ID: <1486977617-17216-1-git-send-email-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33886 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbdBMRa7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2017 12:30:59 -0500
Received: by mail-it0-f67.google.com with SMTP id r141so3354715ita.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 09:30:58 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The INCOMPAT_LARGEDIR feature allows larger directories to
be created, both with directory sizes over 2GB and and a
maximum htree depth of 3 instead of the current limit of 2.
These features are needed in order to exceed the currently
limit of approximately 10M entries in a single directory.

This is second version of the patch set. Changes since v1:
* 4-patch series with cover letter created
* Not allowed for i_size_high to be used for directories
  without the LARGEDIR feature
* i_size_high checks are removed only in patch that adds largedir
  support.
* PR_2_DIR_ACL_ZERO renamed to PR_2_DIR_SIZE_HIGH_ZERO
* helper functions are added
* redundant check in update_parents() is deleted
* cleanup code is moved to first patch 
* test expect wrong ref count after ln
* test manually expands a directory
* code style cleanup

Artem Blagodarenko (4):
  e2fsprogs: supersede i_dir_acl with i_size_high for all cases
  e2fsprogs: add support for 3-level htree
  e2fsck: 3 level hash tree directory optimization
  tests: 3 level hash tree test

 debugfs/debugfs.c                        |   16 ++--
 debugfs/htree.c                          |    3 +-
 debugfs/set_fields.c                     |    1 -
 e2fsck/e2fsck.h                          |    1 +
 e2fsck/message.c                         |    4 +-
 e2fsck/pass1.c                           |    5 +-
 e2fsck/pass2.c                           |   77 +++++++++++++-----
 e2fsck/problem.c                         |    6 +-
 e2fsck/problem.h                         |    4 +-
 e2fsck/rehash.c                          |  123 ++++++++++++++++++++++++------
 ext2ed/doc/ext2ed-design.sgml            |    2 +-
 ext2ed/doc/ext2fs-overview.sgml          |    2 +-
 ext2ed/ext2.descriptors                  |    2 +-
 lib/ext2fs/ext2_fs.h                     |    9 +-
 lib/ext2fs/ext2fs.h                      |   26 ++++++-
 lib/ext2fs/swapfs.c                      |    2 +-
 misc/mke2fs.c                            |    3 +-
 misc/tune2fs.c                           |    3 +-
 po/at-expand.pl                          |    2 +-
 tests/d_fallocate_blkmap/expect          |    4 +-
 tests/d_inline_dump/expect               |   12 ++--
 tests/d_special_files/expect             |   10 +-
 tests/f_badcluster/expect                |   14 ++--
 tests/f_convert_bmap/expect.1            |    2 +-
 tests/f_convert_bmap_and_extent/expect.1 |    2 +-
 tests/f_create_symlinks/expect           |    8 +-
 tests/f_large_dir/debugfs_script         |   15 ++++
 tests/f_large_dir/expect                 |   12 +++
 tests/f_large_dir/name                   |    1 +
 tests/f_large_dir/script                 |   28 +++++++
 tests/f_recnect_bad/expect.1             |    2 +-
 31 files changed, 294 insertions(+), 107 deletions(-)
 create mode 100755 tests/f_large_dir/debugfs_script
 create mode 100644 tests/f_large_dir/expect
 create mode 100644 tests/f_large_dir/name
 create mode 100644 tests/f_large_dir/script

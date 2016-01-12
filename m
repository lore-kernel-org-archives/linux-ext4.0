From: Li Xi <pkuelelixi@gmail.com>
Subject: [v3 0/5] Add project quota support for e2fsprogs
Date: Tue, 12 Jan 2016 17:56:43 +0900
Message-ID: <1452589008-18750-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35840 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934275AbcALI44 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 03:56:56 -0500
Received: by mail-pa0-f52.google.com with SMTP id yy13so243844998pab.3
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 00:56:56 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches adds project quota support for e2fsprogs. The
first patch cleans up current codes to prepare for adding project
quota support. And other patches adds project ID as well as project
feature support for e2fsprogs.

Li Xi (5):
  Clean up codes for adding new quota type
  Add project feature flag EXT4_FEATURE_RO_COMPAT_PROJECT
  Add project quota support
  Add inherit flags for project quota
  Add project ID support for chattr/lsattr

 debugfs/quota.c                 |    2 +-
 debugfs/set_fields.c            |    2 +
 e2fsck/pass1.c                  |   46 +++++++++---
 e2fsck/pass4.c                  |    3 +-
 e2fsck/quota.c                  |   28 +++----
 e2fsck/unix.c                   |   26 +++---
 lib/e2p/Makefile.in             |   11 ++-
 lib/e2p/e2p.h                   |    2 +
 lib/e2p/feature.c               |    2 +
 lib/e2p/ls.c                    |   28 +++++--
 lib/e2p/pf.c                    |    1 +
 lib/ext2fs/ext2_fs.h            |   12 ++-
 lib/ext2fs/ext2fs.h             |    3 +-
 lib/ext2fs/swapfs.c             |    2 +
 lib/ext2fs/tst_inode_size.c     |    1 +
 lib/ext2fs/tst_super_size.c     |    3 +-
 lib/support/mkquota.c           |  167 ++++++++++++++++++++++++++------------
 lib/support/quotaio.c           |   85 ++++++++++++++------
 lib/support/quotaio.h           |   76 +++++++++++++-----
 lib/support/quotaio_tree.c      |    2 +-
 misc/chattr.1.in                |    7 ++
 misc/chattr.c                   |   34 ++++++++-
 misc/ext4.5.in                  |    5 +
 misc/lsattr.1.in                |    5 +-
 misc/lsattr.c                   |   18 ++++-
 misc/mke2fs.c                   |   54 ++++++++++---
 misc/tune2fs.8.in               |    3 +
 misc/tune2fs.c                  |  159 ++++++++++++++++++++-----------------
 tests/d_fallocate_blkmap/expect |    4 +-
 tests/f_create_symlinks/expect  |    8 +-
 tests/m_bigjournal/expect.1     |    4 +-
 tests/m_large_file/expect.1     |    4 +-
 tests/m_quota/expect.1          |   17 ++--
 tests/m_quota/script            |    2 +-
 34 files changed, 559 insertions(+), 267 deletions(-)


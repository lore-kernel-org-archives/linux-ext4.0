From: Li Xi <pkuelelixi@gmail.com>
Subject: [v4 0/6] Add project quota support for e2fsprogs
Date: Sun,  6 Mar 2016 13:14:50 +0900
Message-ID: <1457237696-13770-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35139 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcCFEPF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 23:15:05 -0500
Received: by mail-pa0-f41.google.com with SMTP id bj10so58634213pad.2
        for <linux-ext4@vger.kernel.org>; Sat, 05 Mar 2016 20:15:04 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches adds project quota support for e2fsprogs. The
first two patches cleans up current codes to prepare for adding project
quota support. And other patches adds project ID as well as project
feature support for e2fsprogs.

Li Xi (6):
  Always read full inode structure
  Clean up codes for adding new quota type
  Add project feature flag EXT4_FEATURE_RO_COMPAT_PROJECT
  Add project quota support
  Add inherit flags for project quota
  Add project ID support for chattr/lsattr

 debugfs/icheck.c                |   26 ++++--
 debugfs/lsdel.c                 |   30 ++++---
 debugfs/ncheck.c                |   20 +++--
 debugfs/quota.c                 |    2 +-
 debugfs/set_fields.c            |    3 +
 e2fsck/iscan.c                  |   12 ++-
 e2fsck/pass1.c                  |   56 ++++++++++--
 e2fsck/pass1b.c                 |   27 ++++--
 e2fsck/pass4.c                  |    3 +-
 e2fsck/quota.c                  |   28 +++----
 e2fsck/scantest.c               |   26 ++++--
 e2fsck/unix.c                   |   26 +++---
 lib/e2p/Makefile.in             |   11 ++-
 lib/e2p/e2p.h                   |    2 +
 lib/e2p/feature.c               |    2 +
 lib/e2p/fgetproject.c           |   57 ++++++++++++
 lib/e2p/fsetproject.c           |   66 ++++++++++++++
 lib/e2p/ls.c                    |   28 +++++--
 lib/e2p/pf.c                    |    1 +
 lib/ext2fs/bmove.c              |   37 +++++---
 lib/ext2fs/ext2_fs.h            |   16 +++-
 lib/ext2fs/ext2fs.h             |    3 +-
 lib/ext2fs/swapfs.c             |   17 ++--
 lib/ext2fs/tst_inode_size.c     |    1 +
 lib/ext2fs/tst_iscan.c          |   17 +++-
 lib/ext2fs/tst_super_size.c     |    3 +-
 lib/support/mkquota.c           |  181 ++++++++++++++++++++++++++------------
 lib/support/quotaio.c           |   85 ++++++++++++------
 lib/support/quotaio.h           |   80 ++++++++++++-----
 lib/support/quotaio_tree.c      |    2 +-
 misc/chattr.1.in                |    7 ++
 misc/chattr.c                   |   34 +++++++-
 misc/e2image.c                  |   41 ++++++---
 misc/ext4.5.in                  |    5 +
 misc/lsattr.1.in                |    5 +-
 misc/lsattr.c                   |   18 ++++-
 misc/mke2fs.c                   |   54 +++++++++---
 misc/tune2fs.8.in               |    3 +
 misc/tune2fs.c                  |  187 ++++++++++++++++++++++-----------------
 resize/resize2fs.c              |    3 +-
 tests/d_fallocate_blkmap/expect |    4 +-
 tests/f_create_symlinks/expect  |    8 +-
 tests/m_bigjournal/expect.1     |    4 +-
 tests/m_large_file/expect.1     |    4 +-
 tests/m_quota/expect.1          |  115 ++++++++++++------------
 tests/m_quota/script            |    2 +-
 46 files changed, 953 insertions(+), 409 deletions(-)
 create mode 100644 lib/e2p/fgetproject.c
 create mode 100644 lib/e2p/fsetproject.c


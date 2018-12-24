Return-Path: <SRS0=rRm4=PB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr730095.outbound.protection.outlook.com ([40.107.73.95]:21136
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726648AbeLXExp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Dec 2018 23:53:45 -0500
Date: Sun, 23 Dec 2018 23:53:34 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: [GIT PULL] ext4 updates for 4.21-rc1
Message-ID: <20181224045334.GA20828@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 2e6e902d185027f8e3cb8b7305238f7e35d6a436:

  Linux 4.20-rc4 (2018-11-25 14:19:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 18f2c4fcebf2582f96cbd5f2238f4f354a0e4847:

  ext4: check for shutdown and r/o file system in ext4_write_inode() (2018-12-19 14:36:58 -0500)

----------------------------------------------------------------
All cleanups and bug fixes; most notably, fix some problems discovered
in ext4's NFS support, and fix an ioctl (EXT4_IOC_GROUP_ADD) used by
old versions of e2fsprogs which we accidentally broke a while back.
Also fixed some error paths in ext4's quota and inline data support.
Finally, improve tail latency in jbd2's commit code.

----------------------------------------------------------------
Alexander Lochmann (1):
      jbd2: update locking documentation for transaction_t

Chengguang Xu (2):
      ext4: remove redundant condition check
      ext4: compare old and new mode before setting update_mode flag

Colin Ian King (2):
      ext4: clean up indentation issues, remove extraneous tabs
      jbd2: clean up indentation issue, replace spaces with tab

Eric Sandeen (1):
      ext4: hard fail dax mount on unsupported devices

Jan Kara (1):
      jbd2: avoid long hold times of j_state_lock while committing a transaction

Maurizio Lombardi (1):
      ext4: missing unlock/put_page() in ext4_try_to_write_inline_data()

Pan Bian (1):
      ext4: fix possible use after free in ext4_quota_enable

Theodore Ts'o (5):
      ext4: add ext4_sb_bread() to disambiguate ENOMEM cases
      ext4: include terminating u32 in size of xattr entries when expanding inodes
      ext4: avoid declaring fs inconsistent due to invalid file handles
      ext4: force inode writes when nfsd calls commit_metadata()
      ext4: check for shutdown and r/o file system in ext4_write_inode()

ruippan (潘睿) (1):
      ext4: fix EXT4_IOC_GROUP_ADD ioctl

 fs/ext4/acl.c               |  3 +-
 fs/ext4/ext4.h              | 17 ++++++++-
 fs/ext4/ialloc.c            |  2 +-
 fs/ext4/inline.c            |  5 ++-
 fs/ext4/inode.c             | 63 +++++++++++++++++++++----------
 fs/ext4/ioctl.c             |  2 +-
 fs/ext4/migrate.c           | 48 ++++++++++++------------
 fs/ext4/namei.c             |  4 +-
 fs/ext4/resize.c            | 79 +++++++++++++++++++--------------------
 fs/ext4/super.c             | 92 ++++++++++++++++++++++++++++------------------
 fs/ext4/xattr.c             | 83 ++++++++++++++++++++---------------------
 fs/jbd2/commit.c            |  3 ++
 fs/jbd2/transaction.c       | 45 ++++++++++++++++++++---
 include/linux/jbd2.h        |  7 ++--
 include/trace/events/ext4.h | 20 ++++++++++
 15 files changed, 296 insertions(+), 177 deletions(-)

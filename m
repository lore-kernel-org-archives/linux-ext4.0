From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 0/7] ext2: Preparation to remove BKL (v2)
Date: Wed, 14 Apr 2010 14:38:32 +0200
Message-ID: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47340 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0DNMin (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 08:38:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a series of patches in preparation to the removal of the big kernel
lock from ext2. It consists mostly of cleanup patches to later introduce a
spinlock to protect some of the superblock's fields against concurrent access.
With the spinlock in place we don't need to use the big kernel lock anymore.

This series has been part of the BKL removal patches that I have posted in
November 2009 already. I've addressed the feedback kindly provided by Ogawa-san
by moving the ext2_write_super() out of ext2_setup_super().

Changes since v1:
- fix typo when setting MS_RDONLY
- take s_lock when setting EXT2_FEATURE_COMPAT_EXT_ATTR
- fold ext2_commit_super() into ext2_sync_super()
- include BKL removal patch

Thanks,
Jan

Jan Blunck (7):
  ext2: Use ext2_clear_super_error() in ext2_sync_fs()
  ext2: Set the write time in ext2_sync_fs()
  ext2: Remove duplicate code from ext2_sync_fs()
  ext2: Fold ext2_commit_super() into ext2_sync_super()
  ext2: Move ext2_write_super() out of ext2_setup_super()
  ext2: Add ext2_sb_info s_lock spinlock
  BKL: Remove BKL from ext2 filesystem

 fs/ext2/inode.c            |    5 +-
 fs/ext2/super.c            |   99 ++++++++++++++++++--------------------------
 fs/ext2/xattr.c            |    2 +
 include/linux/ext2_fs_sb.h |    9 ++++
 4 files changed, 54 insertions(+), 61 deletions(-)


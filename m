From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 0/5] ext2: Preparation to remove BKL
Date: Mon, 12 Apr 2010 22:41:40 +0200
Message-ID: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab0DLUmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 16:42:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In this series I've collected the patches that prepare ext2 for BKL removal.
It consist mostly of cleanups and additionally introduces a spinlock to protect
some of the superblock's fields against concurrent access. I've addressed the
feedback kindly provided by Ogawa-san by moving the ext2_write_super() out of
ext2_setup_super().

These patches have been part of the BKL removal series that I have posted in
November 2009 already. Since this is more than just removing the usage of the
big lock I repost it separately for inclusion. This series, at least the last
patch that includes the s_lock, needs to be merged before Frederics bkl-removal
branch, if he merges the rest of my patches there.

Thanks,
Jan

Jan Blunck (5):
  ext2: Use ext2_clear_super_error() in ext2_sync_fs()
  ext2: Set the write time in ext2_sync_fs()
  ext2: Remove duplicate code from ext2_sync_fs()
  ext2: Move ext2_write_super() out of ext2_setup_super()
  ext2: Add ext2_sb_info s_lock spinlock

 fs/ext2/inode.c            |    2 +
 fs/ext2/super.c            |   63 +++++++++++++++++++++++++-------------------
 include/linux/ext2_fs_sb.h |    6 ++++
 3 files changed, 44 insertions(+), 27 deletions(-)


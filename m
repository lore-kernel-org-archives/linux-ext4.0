Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728803AbeLTNwz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 08:52:55 -0500
Date: Thu, 20 Dec 2018 14:52:52 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] Ext2, udf, and quota changes for v4.21-rc1
Message-ID: <20181220135252.GB15045@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_4.21-rc1

to get some ext2 cleanups, a fix for UDF crash on corrupted media, and one
quota locking fix.

Top of the tree is 2aad26fa0a3d. The full shortlog is:

Chengguang Xu (3):
      ext2: avoid unnecessary operation in ext2_error()
      ext2: remove redundant condition check
      ext2: change reusable parameter to true when calling mb_cache_entry_create()

Jan Kara (1):
      udf: Fix BUG on corrupted inode

Javier Barrio (1):
      quota: Lock s_umount in exclusive mode for Q_XQUOTA{ON,OFF} quotactls.

The diffstat is

 fs/ext2/super.c  | 12 +++++-------
 fs/ext2/xattr.c  |  3 ++-
 fs/quota/quota.c |  3 ++-
 fs/udf/inode.c   |  6 ++++++
 4 files changed, 15 insertions(+), 9 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] UDF, ext2, quota & reiserfs fixes
Date: Wed, 5 Oct 2016 10:46:33 +0200
Message-ID: <20161005084633.GB7291@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbcJEIqg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Oct 2016 04:46:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get some smaller udf, ext2, quota & reiserfs fixes.

Top of the tree is 225c5161b118. The full shortlog is:

Al Viro (1):
      udf: don't bother with full-page write optimisations in adinicb case

Eric Sandeen (1):
      quota: fill in Q_XGETQSTAT inode information for inactive quotas

Jan Kara (3):
      ext2: Check return value from ext2_get_group_desc()
      udf: Remove useless check in udf_adinicb_write_begin()
      ext2: Unmap metadata when zeroing blocks

Mike Galbraith (1):
      reiserfs: Unlock superblock before calling reiserfs_quota_on_mount()

The diffstat is

 fs/ext2/ialloc.c    |  5 +++++
 fs/ext2/inode.c     | 10 ++++++++++
 fs/quota/quota.c    | 18 ++++++++++++------
 fs/reiserfs/super.c | 12 +++++++++++-
 fs/udf/file.c       | 18 ++++++++++++++++--
 5 files changed, 54 insertions(+), 9 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

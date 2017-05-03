From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] Quota, reiserfs, udf, and ext2 changes for 4.12-rc1
Date: Wed, 3 May 2017 15:55:35 +0200
Message-ID: <20170503135535.GH10084@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git generic

The branch contains changes to quota code so that it does not modify
persistent flags in inode->i_flags (it was the only place in kernel doing
that) and handle it inside filesystem's quotaon/off handlers instead.
The branch also contains two UDF cleanups, couple of reiserfs fixes and
one fix for ext2 quota locking.

Top of the tree is 6c71100db53e. The full shortlog is:

Arnd Bergmann (1):
      reiserfs: avoid a -Wmaybe-uninitialized warning

Fabian Frederick (2):
      udf: use octal for permissions
      udf: use kmap_atomic for memcpy copying

Jan Kara (15):
      ext2: Call dquot_writeback_dquots() with s_umount held
      reiserfs: Make cancel_old_flush() reliable
      reiserfs: Protect dquot_writeback_dquots() by s_umount semaphore
      ext4: Set flags on quota files directly
      reiserfs: Set flags on quota files directly
      ext2: Set flags on quota files directly
      jfs: Set flags on quota files directly
      quota: Stop setting IMMUTABLE and NOATIME flags on quota files
      ext4: Remove ext4_get_inode_flags()
      ext2: Remove ext2_get_inode_flags()
      jfs: Remove jfs_get_inode_flags()
      reiserfs: Remove useless setting of i_flags
      reiserfs: Remove i_attrs_to_sd_attrs()
      quota: Remove dquot_quotactl_ops
      ext4: Improve comments in ext4_quota_{on|off}()

The diffstat is

 fs/ext2/ext2.h           |  4 +--
 fs/ext2/inode.c          | 22 +-----------
 fs/ext2/ioctl.c          |  1 -
 fs/ext2/super.c          | 87 +++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/ext4.h           |  1 -
 fs/ext4/inode.c          | 26 --------------
 fs/ext4/ioctl.c          |  2 --
 fs/ext4/super.c          | 74 +++++++++++++++++++++++++++++++++-----
 fs/jfs/ioctl.c           |  2 --
 fs/jfs/jfs_imap.c        |  1 -
 fs/jfs/jfs_inode.c       | 18 ----------
 fs/jfs/jfs_inode.h       |  1 -
 fs/jfs/super.c           | 79 +++++++++++++++++++++++++++++++++++++++--
 fs/quota/dquot.c         | 31 +++-------------
 fs/reiserfs/inode.c      | 31 +---------------
 fs/reiserfs/ioctl.c      |  1 -
 fs/reiserfs/journal.c    |  2 +-
 fs/reiserfs/lbalance.c   |  2 +-
 fs/reiserfs/reiserfs.h   |  3 +-
 fs/reiserfs/super.c      | 92 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/udf/file.c            | 10 +++---
 fs/udf/inode.c           | 22 ++++++------
 fs/udf/namei.c           |  2 +-
 include/linux/quotaops.h |  1 -
 24 files changed, 335 insertions(+), 180 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

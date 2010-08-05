From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] ext3 & quota fixes and cleanups for 2.6.36
Date: Fri, 6 Aug 2010 00:42:37 +0200
Message-ID: <20100805224236.GB17416@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get quota cleanups and some ext3 cleanups and fixes. There's also
MAINTAINERS update adding myself to ext2 & ext3 entries.
  Shortlog below:

Andi Kleen (1):
      ext3: Fix set but unused variables

Andreas Dilger (1):
      MAINTAINERS: Update address of Andreas Dilger

Christoph Hellwig (3):
      quota: Clean up the namespace in dqblk_xfs.h
      quota: clean up quota active checks
      ext3: remove vestiges of nobh support

Dave Chinner (1):
      ext3: default to ordered mode

Dmitry Monakhov (1):
      quota: check quota reservation on remove_dquot_ref

Jan Kara (4):
      ext3: Avoid filesystem corruption after a crash under heavy delete load
      MAINTAINERS: Update entries of ext2 and ext3
      quota: Use mark_inode_dirty_sync instead of mark_inode_dirty
      ext3: Fix dirtying of journalled buffers in data=journal mode

Jiaying Zhang (1):
      quota: Change quota error message to print out disk and function name

The diffstat is

 MAINTAINERS                     |    6 ++-
 fs/ext3/Kconfig                 |    1 +
 fs/ext3/inode.c                 |   80 ++++++++++++++++++++-----------------
 fs/ext3/namei.c                 |    3 +-
 fs/ext3/resize.c                |    2 -
 fs/ext3/super.c                 |   17 ++------
 fs/gfs2/quota.c                 |   10 ++--
 fs/jbd/journal.c                |    7 ---
 fs/jbd/recovery.c               |   11 +----
 fs/quota/dquot.c                |   79 ++++++++++++++++++++++++++----------
 fs/quota/quota_tree.c           |   85 +++++++++++++++++++--------------------
 fs/quota/quota_tree.h           |    6 ---
 fs/quota/quota_v1.c             |    3 +-
 fs/quota/quota_v2.c             |   11 ++---
 fs/xfs/linux-2.6/xfs_quotaops.c |   10 ++--
 fs/xfs/quota/xfs_qm_syscalls.c  |   32 +++++++-------
 include/linux/dqblk_xfs.h       |   24 +++++-----
 include/linux/ext3_fs.h         |    1 -
 include/linux/quotaops.h        |   26 +++++-------
 19 files changed, 208 insertions(+), 206 deletions(-)

							Thanks
								Honza

From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Quota cleanups & fixes and ext3 fixes for 2.6.34-rc1
Date: Fri, 5 Mar 2010 01:33:04 +0100
Message-ID: <20100305003304.GE4887@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	dushistov@mail.ru, joel.becker@oracle.com,
	shaggy@linux.vnet.ibm.com, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  You'll get lots of quota cleanups from Christoph which touch filesystems
all over the place but it's just function renaming and moving quota calls
from VFS into filesystems themselves.

  The shortlog and diffstat are below:

Christoph Egger (1):
      jbd[2]: remove references to BUFFER_DEBUG

Christoph Hellwig (19):
      quota: split do_quotactl
      quota: clean up checks for supported quota methods
      quota: special case Q_SYNC without device name
      quota: simplify permission checking
      quota: clean up Q_XQUOTASYNC
      quota: move code from sync_quota_sb into vfs_quota_sync
      quota: remove invalid optimization from quota_sync_all
      quota: split out netlink notification support from quota.c
      quota: split out compat_sys_quotactl support from quota.c
      quota: drop permission checks from xfs_fs_set_xstate/xfs_fs_set_xquota
      dquot: cleanup space allocation / freeing routines
      dquot: cleanup inode allocation / freeing routines
      dquot: move dquot transfer responsibility into the filesystem
      dquot: cleanup dquot transfer routine
      dquot: move dquot drop responsibility into the filesystem
      dquot: cleanup dquot drop routine
      dquot: move dquot initialization responsibility into the filesystem
      dquot: cleanup dquot initialize routine
      quota: stop using QUOTA_OK / NO_QUOTA

Dmitry Monakhov (7):
      ext3: mount flags manipulation cleanup
      ext3: trivial quota cleanup
      quota: manage reserved space when quota is not active [v2]
      ext3: quota_write cross block boundary behaviour
      quota: sb_quota state flags cleanup
      quota: generalize quota transfer interface
      ext3: add writepage sanity checks

Jan Kara (6):
      quota: Cleanup S_NOQUOTA handling
      ext3: Use bitops to read/modify EXT3_I(inode)->i_state
      quota: Fix warning when a delayed write happens before quota is enabled
      jbd: Delay discarding buffers in journal_unmap_buffer
      quota: Properly invalidate caches even for filesystems with blocksize < pagesize
      ext3: Truncate allocated blocks if direct IO write fails to update i_size

The diffstat is

 Documentation/filesystems/Locking |   18 -
 drivers/staging/pohmelfs/inode.c  |    2 +-
 fs/attr.c                         |   11 +-
 fs/ext2/balloc.c                  |   12 +-
 fs/ext2/file.c                    |    5 +-
 fs/ext2/ialloc.c                  |   14 +-
 fs/ext2/inode.c                   |    7 +-
 fs/ext2/namei.c                   |   51 ++-
 fs/ext2/super.c                   |    2 +
 fs/ext2/xattr.c                   |   10 +-
 fs/ext3/balloc.c                  |   11 +-
 fs/ext3/file.c                    |    7 +-
 fs/ext3/ialloc.c                  |   16 +-
 fs/ext3/inode.c                   |   41 ++-
 fs/ext3/namei.c                   |   24 +-
 fs/ext3/super.c                   |  246 ++++++------
 fs/ext3/xattr.c                   |   22 +-
 fs/ext4/file.c                    |    3 +-
 fs/ext4/ialloc.c                  |   16 +-
 fs/ext4/inode.c                   |   27 +-
 fs/ext4/mballoc.c                 |    6 +-
 fs/ext4/namei.c                   |   23 +-
 fs/ext4/super.c                   |   15 +-
 fs/ext4/xattr.c                   |    8 +-
 fs/gfs2/quota.c                   |    9 +-
 fs/gfs2/quota.h                   |    2 +-
 fs/gfs2/super.c                   |    2 +-
 fs/gfs2/sys.c                     |    2 +-
 fs/inode.c                        |    4 -
 fs/jbd/commit.c                   |   10 +-
 fs/jbd/transaction.c              |   43 ++-
 fs/jfs/acl.c                      |   26 +--
 fs/jfs/file.c                     |   31 ++-
 fs/jfs/inode.c                    |    9 +-
 fs/jfs/jfs_acl.h                  |    7 +-
 fs/jfs/jfs_dtree.c                |   28 +-
 fs/jfs/jfs_extent.c               |   16 +-
 fs/jfs/jfs_inode.c                |    8 +-
 fs/jfs/jfs_inode.h                |    1 +
 fs/jfs/jfs_xtree.c                |   21 +-
 fs/jfs/namei.c                    |   23 +-
 fs/jfs/super.c                    |    6 +
 fs/jfs/xattr.c                    |   17 +-
 fs/namei.c                        |   16 -
 fs/nfsd/vfs.c                     |    4 -
 fs/ocfs2/alloc.c                  |   13 +-
 fs/ocfs2/aops.c                   |   11 +-
 fs/ocfs2/dir.c                    |   37 +-
 fs/ocfs2/file.c                   |   20 +-
 fs/ocfs2/inode.c                  |    6 +-
 fs/ocfs2/namei.c                  |   52 ++--
 fs/ocfs2/quota_global.c           |    7 -
 fs/ocfs2/refcounttree.c           |    2 +-
 fs/open.c                         |    5 +-
 fs/quota/Kconfig                  |    5 +
 fs/quota/Makefile                 |    2 +
 fs/quota/compat.c                 |  118 ++++++
 fs/quota/dquot.c                  |  412 +++++++++++----------
 fs/quota/netlink.c                |   95 +++++
 fs/quota/quota.c                  |  735 ++++++++++++-------------------------
 fs/reiserfs/bitmap.c              |   10 +-
 fs/reiserfs/file.c                |    2 +-
 fs/reiserfs/inode.c               |   20 +-
 fs/reiserfs/namei.c               |   23 +-
 fs/reiserfs/stree.c               |   20 +-
 fs/reiserfs/super.c               |   15 +-
 fs/reiserfs/xattr.c               |    4 -
 fs/sync.c                         |   14 +-
 fs/udf/balloc.c                   |   35 +-
 fs/udf/file.c                     |   28 ++-
 fs/udf/ialloc.c                   |   14 +-
 fs/udf/inode.c                    |    6 +
 fs/udf/namei.c                    |   17 +
 fs/ufs/balloc.c                   |   24 +-
 fs/ufs/file.c                     |    3 +-
 fs/ufs/ialloc.c                   |   11 +-
 fs/ufs/inode.c                    |    4 +
 fs/ufs/namei.c                    |   18 +
 fs/ufs/super.c                    |    6 +
 fs/ufs/truncate.c                 |   10 +
 fs/xfs/linux-2.6/xfs_quotaops.c   |   19 -
 include/linux/ext3_fs.h           |   33 ++-
 include/linux/ext3_fs_i.h         |    2 +-
 include/linux/jbd.h               |   11 -
 include/linux/jbd2.h              |   11 -
 include/linux/quota.h             |   33 +--
 include/linux/quotaops.h          |  304 +++++-----------
 87 files changed, 1554 insertions(+), 1545 deletions(-)
 create mode 100644 fs/quota/compat.c
 create mode 100644 fs/quota/netlink.c

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

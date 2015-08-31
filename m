From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Mon, 31 Aug 2015 08:19:20 +0200
Message-ID: <20150831061920.GA2751@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

The biggest change in the pull is the removal of ext3 filesystem driver
(~28k lines removed).  Ext4 driver is a full featured replacement these
days and both RH and SUSE use it for several years without issues. Also
there are some workarounds in VM & block layer mainly for ext3 which we
could eventually get rid of. Other larger change is addition of proper
error handling for dquot_initialize().  The rest is small fixes and
cleanups.

Timing sucks for me for this merge window since I'm on vacation for these
two weeks without internet access. Hopefully things work out fine.

Top of the tree is 9181f8bf5abf. The full shortlog is:

Dan Carpenter (2):
      ext4: memory leak on error in ext4_symlink()
      quota: remove an unneeded condition

Dave Kleikamp (1):
      jfs: Handle error from dquot_initialize()

Jan Kara (10):
      quota: Propagate error from ->acquire_dquot()
      ext2: Handle error from dquot_initalize()
      ext4: Handle error from dquot_initialize()
      ocfs2: Handle error from dquot_initialize()
      reiserfs: Handle error from dquot_initialize()
      doc: Update doc about journalling layer
      fs: Remove ext3 filesystem driver
      block: Remove forced page bouncing under IO
      ext4: Improve ext4 Kconfig test
      udf: Don't modify filesystem for read-only mounts

Valentin Rothberg (1):
      mm/Kconfig: NEED_BOUNCE_POOL: clean-up condition

The diffstat is

 Documentation/DocBook/filesystems.tmpl |  178 +-
 Documentation/filesystems/ext2.txt     |    4 +-
 Documentation/filesystems/ext3.txt     |  209 +-
 Documentation/filesystems/vfs.txt      |    2 +-
 MAINTAINERS                            |   18 +-
 block/bounce.c                         |   31 +-
 fs/Kconfig                             |    5 +-
 fs/Makefile                            |    2 -
 fs/ext2/ialloc.c                       |    5 +-
 fs/ext2/inode.c                        |    7 +-
 fs/ext2/namei.c                        |   46 +-
 fs/ext3/Kconfig                        |   89 -
 fs/ext3/Makefile                       |   12 -
 fs/ext3/acl.c                          |  281 ---
 fs/ext3/acl.h                          |   72 -
 fs/ext3/balloc.c                       | 2158 -------------------
 fs/ext3/bitmap.c                       |   20 -
 fs/ext3/dir.c                          |  537 -----
 fs/ext3/ext3.h                         | 1332 ------------
 fs/ext3/ext3_jbd.c                     |   59 -
 fs/ext3/file.c                         |   79 -
 fs/ext3/fsync.c                        |  109 -
 fs/ext3/hash.c                         |  206 --
 fs/ext3/ialloc.c                       |  706 -------
 fs/ext3/inode.c                        | 3574 --------------------------------
 fs/ext3/ioctl.c                        |  327 ---
 fs/ext3/namei.c                        | 2586 -----------------------
 fs/ext3/namei.h                        |   27 -
 fs/ext3/resize.c                       | 1117 ----------
 fs/ext3/super.c                        | 3165 ----------------------------
 fs/ext3/symlink.c                      |   46 -
 fs/ext3/xattr.c                        | 1330 ------------
 fs/ext3/xattr.h                        |  136 --
 fs/ext3/xattr_security.c               |   78 -
 fs/ext3/xattr_trusted.c                |   54 -
 fs/ext3/xattr_user.c                   |   58 -
 fs/ext4/Kconfig                        |   54 +-
 fs/ext4/ialloc.c                       |    6 +-
 fs/ext4/inode.c                        |    7 +-
 fs/ext4/namei.c                        |   63 +-
 fs/ext4/super.c                        |   14 +-
 fs/jbd/Kconfig                         |   30 -
 fs/jbd/Makefile                        |    7 -
 fs/jbd/checkpoint.c                    |  782 -------
 fs/jbd/commit.c                        | 1021 ---------
 fs/jbd/journal.c                       | 2145 -------------------
 fs/jbd/recovery.c                      |  594 ------
 fs/jbd/revoke.c                        |  733 -------
 fs/jbd/transaction.c                   | 2237 --------------------
 fs/jfs/file.c                          |    7 +-
 fs/jfs/jfs_inode.c                     |    4 +-
 fs/jfs/namei.c                         |   54 +-
 fs/ocfs2/file.c                        |   22 +-
 fs/ocfs2/namei.c                       |   59 +-
 fs/ocfs2/quota_local.c                 |    4 +-
 fs/ocfs2/refcounttree.c                |    5 +-
 fs/quota/dquot.c                       |   88 +-
 fs/quota/quota.c                       |    4 +-
 fs/reiserfs/inode.c                    |    7 +-
 fs/reiserfs/namei.c                    |   63 +-
 fs/udf/super.c                         |    7 +-
 include/linux/blk_types.h              |    5 +-
 include/linux/jbd.h                    | 1047 ----------
 include/linux/jbd2.h                   |   41 +-
 include/linux/jbd_common.h             |   46 -
 include/linux/quotaops.h               |    5 +-
 include/trace/events/ext3.h            |  866 --------
 include/trace/events/jbd.h             |  194 --
 mm/Kconfig                             |    8 +-
 69 files changed, 505 insertions(+), 28389 deletions(-)
 delete mode 100644 fs/ext3/Kconfig
 delete mode 100644 fs/ext3/Makefile
 delete mode 100644 fs/ext3/acl.c
 delete mode 100644 fs/ext3/acl.h
 delete mode 100644 fs/ext3/balloc.c
 delete mode 100644 fs/ext3/bitmap.c
 delete mode 100644 fs/ext3/dir.c
 delete mode 100644 fs/ext3/ext3.h
 delete mode 100644 fs/ext3/ext3_jbd.c
 delete mode 100644 fs/ext3/file.c
 delete mode 100644 fs/ext3/fsync.c
 delete mode 100644 fs/ext3/hash.c
 delete mode 100644 fs/ext3/ialloc.c
 delete mode 100644 fs/ext3/inode.c
 delete mode 100644 fs/ext3/ioctl.c
 delete mode 100644 fs/ext3/namei.c
 delete mode 100644 fs/ext3/namei.h
 delete mode 100644 fs/ext3/resize.c
 delete mode 100644 fs/ext3/super.c
 delete mode 100644 fs/ext3/symlink.c
 delete mode 100644 fs/ext3/xattr.c
 delete mode 100644 fs/ext3/xattr.h
 delete mode 100644 fs/ext3/xattr_security.c
 delete mode 100644 fs/ext3/xattr_trusted.c
 delete mode 100644 fs/ext3/xattr_user.c
 delete mode 100644 fs/jbd/Kconfig
 delete mode 100644 fs/jbd/Makefile
 delete mode 100644 fs/jbd/checkpoint.c
 delete mode 100644 fs/jbd/commit.c
 delete mode 100644 fs/jbd/journal.c
 delete mode 100644 fs/jbd/recovery.c
 delete mode 100644 fs/jbd/revoke.c
 delete mode 100644 fs/jbd/transaction.c
 delete mode 100644 include/linux/jbd.h
 delete mode 100644 include/linux/jbd_common.h
 delete mode 100644 include/trace/events/ext3.h
 delete mode 100644 include/trace/events/jbd.h

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

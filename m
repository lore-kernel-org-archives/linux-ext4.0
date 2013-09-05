From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] Ext3, reiserfs, udf & isofs fixes
Date: Thu, 5 Sep 2013 21:58:02 +0200
Message-ID: <20130905195802.GA9260@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

The pull contains a bunch of ext3 cleanups and minor improvements, major
reiserfs locking changes which should hopefully fix deadlocks introduced by BKL
removal, and udf/isofs changes to refuse mounting fs rw instead of mounting it
ro automatically which makes eject button work as expected for all media (see
the changelog for why userspace should be ok with this change).

Top of the tree is 97a2847. The full shortlog is:

Eric Sandeen (1):
      ext3: allow specifying external journal by pathname mount option

Jan Kara (4):
      isofs: Refuse RW mount of the filesystem instead of making it RO
      udf: Standardize return values in mount sequence
      udf: Refuse RW mount of the filesystem instead of making it RO
      Merge branch 'for-3.12' of git://git.kernel.org/.../jeffm/linux-reiserfs into for_next_testing

Jeff Mahoney (3):
      reiserfs: locking, push write lock out of xattr code
      reiserfs: locking, handle nested locks properly
      reiserfs: locking, release lock around quota operations

Nathaniel Yazdani (1):
      jbd: remove unneeded semicolon

Paul Gortmaker (2):
      jbd: relocate assert after state lock in journal_commit_transaction()
      jbd: use a single printk for jbd_debug()

The diffstat is

 Documentation/filesystems/ext3.txt |   7 +-
 fs/ext3/super.c                    |  43 +++++
 fs/isofs/inode.c                   |  16 +-
 fs/jbd/commit.c                    |   2 +-
 fs/jbd/journal.c                   |  18 ++
 fs/reiserfs/bitmap.c               |  22 ++-
 fs/reiserfs/dir.c                  |   7 +-
 fs/reiserfs/fix_node.c             |  26 +--
 fs/reiserfs/inode.c                | 114 ++++++-------
 fs/reiserfs/ioctl.c                |   7 +-
 fs/reiserfs/journal.c              | 104 +++++------
 fs/reiserfs/lock.c                 |  43 ++---
 fs/reiserfs/namei.c                |  24 +--
 fs/reiserfs/prints.c               |   5 +-
 fs/reiserfs/reiserfs.h             |  36 ++--
 fs/reiserfs/resize.c               |  10 +-
 fs/reiserfs/stree.c                |  74 ++++----
 fs/reiserfs/super.c                |  75 ++++----
 fs/reiserfs/xattr.c                |  46 ++---
 fs/reiserfs/xattr_acl.c            |  16 +-
 fs/udf/super.c                     | 342 ++++++++++++++++++++++---------------
 include/linux/jbd.h                |  17 +-
 22 files changed, 609 insertions(+), 445 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

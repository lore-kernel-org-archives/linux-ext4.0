From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Ext2, ext3 and quota fixes
Date: Fri, 25 May 2012 01:12:09 +0200
Message-ID: <20120524231209.GA28842@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab2EXXML (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2012 19:12:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

Interesting bits are:
* removal of a special i_mutex locking subclass
  (I_MUTEX_QUOTA) since quota code does not need i_mutex anymore in any
  unusual way. 
* backport (from ext4) of a fix of a checkpointing bug (missing cache
  flush) that could lead to fs corruption on power failure

The rest are just random small fixes & cleanups.

Top of the tree is 0324876. The full shortlog is:

Akira Fujita (1):
      ext3: remove max_debt in find_group_orlov()

Artem Bityutskiy (2):
      ext2: write superblock only once on unmount
      ext2: do not register write_super within VFS

Eric Sandeen (1):
      ext3: return 32/64-bit dir name hash according to usage type

Jan Kara (12):
      jbd: Refine commit writeout logic
      ext2: Remove s_dirt handling
      jbd: Split updating of journal superblock and marking journal empty
      jbd: protect all log tail updates with j_checkpoint_mutex
      jbd: Write journal superblock with WRITE_FUA after checkpointing
      quota: Fix double lock in add_dquot_ref() with CONFIG_QUOTA_DEBUG
      ext3: Remove i_mutex use from ext3_quota_write()
      ext4: Remove i_mutex use from ext4_quota_write()
      reiserfs: Remove i_mutex use from reiserfs_quota_write()
      ext2: Remove i_mutex use from ext2_quota_write()
      quota: Use precomputed value of sb_dqopt in dquot_quota_sync
      quota: Get rid of nested I_MUTEX_QUOTA locking subclass

Stefan Hajnoczi (1):
      ext3: update documentation with barrier=1 default

Wang Sheng-Hui (2):
      ext2: remove the redundant comment for ext2_export_ops
      ext2: trivial fix to comment for ext2_free_blocks

The diffstat is

 Documentation/filesystems/ext3.txt |    6 +-
 fs/ext2/balloc.c                   |    4 +-
 fs/ext2/ialloc.c                   |    2 -
 fs/ext2/super.c                    |   18 +---
 fs/ext2/xattr.c                    |    1 -
 fs/ext3/dir.c                      |  167 +++++++++++++++++++++--------
 fs/ext3/ext3.h                     |    6 +-
 fs/ext3/hash.c                     |    4 +-
 fs/ext3/ialloc.c                   |   20 +---
 fs/ext3/super.c                    |    6 +-
 fs/ext4/super.c                    |    6 +-
 fs/jbd/checkpoint.c                |   23 ++---
 fs/jbd/commit.c                    |   21 +++-
 fs/jbd/journal.c                   |  206 +++++++++++++++++++++++------------
 fs/jbd/transaction.c               |    2 -
 fs/quota/dquot.c                   |   32 +++---
 fs/reiserfs/super.c                |    6 +-
 include/linux/jbd.h                |   18 ++--
 include/trace/events/jbd.h         |   39 +++----
 19 files changed, 342 insertions(+), 245 deletions(-)

							Thanks
								Honza

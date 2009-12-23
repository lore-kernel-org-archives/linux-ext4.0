From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Ext3, ext4 and quota fixes for 2.6.33-rc2
Date: Wed, 23 Dec 2009 13:51:10 +0100
Message-ID: <20091223125110.GA3159@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZLWMvT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 07:51:19 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Dmitry Monakhov (7):
      ext3: quota macros cleanup [V2]
      Add unlocked version of inode_add_bytes() function
      quota: decouple fs reserved space from quota reservation
      ext4: Convert to generic reserved quota's space management.
      quota: Move duplicated code to separate functions
      ext4: Fix potential quota deadlock
      ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)

Eric Sandeen (4):
      ext3: Remove outdated comment about lock_super()
      ext3: ext3_mark_recovery_complete() doesn't need to use lock_super
      ext3: Replace lock/unlock_super() with an explicit lock for the orphan list
      ext3: Replace lock/unlock_super() with an explicit lock for resizing

Jan Kara (2):
      quota: Fix 64-bit limits setting on 32-bit archs
      quota: Improve checking of quota file header

Yin Kangkai (1):
      jbd: jbd-debug and jbd2-debug should be writable

I push ext4 fixes instead of Ted because of quota dependencies. Ext3
locking changes fix deadlock during filesystem resizing so I hope they're
fine even for -rc2.

The diffstat is

 fs/ext3/inode.c            |    8 +-
 fs/ext3/namei.c            |   28 +++--
 fs/ext3/resize.c           |   35 +++---
 fs/ext3/super.c            |   19 +---
 fs/ext4/ext4.h             |    6 +-
 fs/ext4/inode.c            |   36 +++---
 fs/ext4/mballoc.c          |    6 -
 fs/ext4/super.c            |    5 +
 fs/jbd/journal.c           |    2 +-
 fs/jbd2/journal.c          |    3 +-
 fs/quota/dquot.c           |  288 ++++++++++++++++++++++++--------------------
 fs/quota/quota_v2.c        |    9 +-
 fs/stat.c                  |   10 ++-
 include/linux/ext3_fs_sb.h |    2 +
 include/linux/ext3_jbd.h   |    7 +-
 include/linux/fs.h         |    1 +
 include/linux/quota.h      |    5 +-
 17 files changed, 253 insertions(+), 217 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

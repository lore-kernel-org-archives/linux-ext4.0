From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] ext3/jbd fixes for 2.6.32-rc1
Date: Wed, 16 Sep 2009 17:49:07 +0200
Message-ID: <20090916154907.GO26030@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZIPPtJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Sep 2009 11:49:09 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Andreas Dilger (1):
      JBD: round commit timer up to avoid uncommitted transaction

Chris Mason (1):
      ext3: Add locking to ext3_do_update_inode

Jan Kara (5):
      ext3: Update MAINTAINERS for ext3 and JBD
      jbd: Journal block numbers can ever be only 32-bit use unsigned int for them
      jbd: Annotate transaction start also for journal_restart()
      ext3: Fix possible deadlock between ext3_truncate() and ext3_get_blocks()
      ext3: Flush disk caches on fsync when needed

The diffstat is

 MAINTAINERS          |    3 +--
 fs/ext3/fsync.c      |   12 +++++++++++-
 fs/ext3/inode.c      |   28 ++++++++++++++++++++++++----
 fs/jbd/checkpoint.c  |    6 +++---
 fs/jbd/commit.c      |    2 +-
 fs/jbd/journal.c     |   30 +++++++++++++++---------------
 fs/jbd/recovery.c    |   18 +++++++++---------
 fs/jbd/revoke.c      |   16 ++++++++--------
 fs/jbd/transaction.c |    9 +++++----
 include/linux/jbd.h  |   26 +++++++++++++-------------
 10 files changed, 90 insertions(+), 60 deletions(-)

                                                        Thanks
                                                                Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

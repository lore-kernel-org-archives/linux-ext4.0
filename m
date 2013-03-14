From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] ext2, ext3, reiserfs, quota fixes for 3.9-rc3
Date: Thu, 14 Mar 2013 14:29:32 +0100
Message-ID: <20130314132932.GA25313@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778Ab3CNN3g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 09:29:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get a fix for regression in ext2, and a fix of one possibly exploitable
format string issue in ext3. The rest isn't too serious.

Top of the tree is c288d29. The full shortlog is:

Ionut-Gabriel Radu (1):
      reiserfs: Use kstrdup instead of kmalloc/strcpy

Jan Kara (1):
      ext2: Fix BUG_ON in evict() on inode deletion

Jeff Mahoney (1):
      quota: add missing use of dq_data_lock in __dquot_initialize

Lars-Peter Clausen (1):
      ext3: Fix format string issues

The diffstat is

 fs/ext2/ialloc.c    |    1 -
 fs/ext2/inode.c     |    2 ++
 fs/ext3/super.c     |    4 ++--
 fs/quota/dquot.c    |    5 ++++-
 fs/reiserfs/super.c |    4 +---
 5 files changed, 9 insertions(+), 7 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] ext3 and jbd fixes for 2.6.31-rc4
Date: Thu, 23 Jul 2009 15:53:02 +0200
Message-ID: <20090723135302.GA23618@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZGWNxE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 09:53:04 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Jan Kara (4):
      jbd: Fail to load a journal if it is too short
      ext3: Fix truncation of symlinks after failed write
      jbd: Fix a race between checkpointing code and journal_get_write_access()
      ext3: Get rid of extenddisksize parameter of ext3_get_blocks_handle()

dingdinghua (1):
      jbd: fix race between write_metadata_buffer and get_write_access

The diffstat is

 fs/ext3/dir.c           |    3 +-
 fs/ext3/inode.c         |   32 +++++++++-------------
 fs/jbd/journal.c        |   26 +++++++++++------
 fs/jbd/transaction.c    |   68 ++++++++++++++++++++++++----------------------
 include/linux/ext3_fs.h |    2 +-
 5 files changed, 67 insertions(+), 64 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Jan Kara <jack@suse.cz>
Subject: [PULL] Ext3 and JBD fixes
Date: Wed, 11 Nov 2009 15:28:24 +0100
Message-ID: <20091111142824.GD21511@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35330 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZKKO2U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2009 09:28:20 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Eric Sandeen (1):
      ext3: retry failed direct IO allocations

Jan Kara (1):
      ext3: Wait for proper transaction commit on fsync

Tao Ma (1):
      JBD/JBD2: free j_wbuf if journal init fails.

The diffstat is

 fs/ext3/fsync.c           |   36 ++++++++++++++++--------------------
 fs/ext3/inode.c           |   36 +++++++++++++++++++++++++++++++++++-
 fs/ext3/super.c           |    2 ++
 fs/jbd/journal.c          |    2 ++
 fs/jbd2/journal.c         |    2 ++
 include/linux/ext3_fs_i.h |    8 ++++++++
 6 files changed, 65 insertions(+), 21 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

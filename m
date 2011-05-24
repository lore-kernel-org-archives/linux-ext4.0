From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Ext2 & ext3 fixes for 2.6.40-rc1
Date: Tue, 24 May 2011 17:23:04 +0200
Message-ID: <20110524152304.GB5390@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab1EXPXI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 11:23:08 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/fs.git for_linus

Nothing too interesting, just couple of bugs fixed.

The full shortlog is:

Eryu Guan (1):
      jbd: Fix comment to match the code in journal_start()

Jan Kara (3):
      ext3: Fix lock inversion in ext3_symlink()
      ext3: Fix fs corruption when make_indexed_dir() fails
      jbd: Fix forever sleeping process in do_get_write_access()

Robin Dong (1):
      ext2: fix error msg when mounting fs with too-large blocksize

Tao Ma (1):
      jbd/jbd2: remove obsolete summarise_journal_usage.

Ted Ts'o (1):
      jbd: fix fsync() tid wraparound bug

The diffstat is

 fs/ext2/super.c      |    3 +-
 fs/ext3/namei.c      |   80 +++++++++++++++++++++++++++++++++++++++++--------
 fs/jbd/commit.c      |   15 ++++-----
 fs/jbd/journal.c     |   16 ++++++++--
 fs/jbd/transaction.c |    3 +-
 fs/jbd2/commit.c     |    6 ----
 6 files changed, 91 insertions(+), 32 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

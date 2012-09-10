From: Jan Kara <jack@suse.cz>
Subject: [PULL] UDF and ext3 fix for 3.6-rc6
Date: Mon, 10 Sep 2012 22:19:17 +0200
Message-ID: <20120910201917.GB31404@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab2IJUTU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 16:19:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get one UDF data corruption fix and one ext3 fix where we didn't write
everything to disk on fsync in one corner case.

Top of the tree is 9c2fc0d. The full shortlog is:

Jan Kara (2):
      ext3: Fix fdatasync() for files with only i_size changes
      udf: Fix data corruption for files in ICB

The diffstat is

 fs/ext3/inode.c |   17 ++++++++++++++---
 fs/udf/file.c   |   35 +++++++++++++++++++++++++++++------
 2 files changed, 43 insertions(+), 9 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] ext3, udf, quota fixes
Date: Mon, 17 Dec 2012 15:33:26 +0100
Message-ID: <20121217143326.GA2669@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab2LQOdh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2012 09:33:37 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get some ext3 & quota cleanups and couple of udf fixes.

Top of the tree is 56df127. The full shortlog is:

Julia Lawall (1):
      ext3: drop if around WARN_ON

Lee Jones (1):
      quota: Use the pre-processor to compile out quotactl_cmd_write when !CONFIG_BLOCK

Namjae Jeon (3):
      udf: fix memory leak while allocating blocks during write
      udf: don't increment lenExtents while writing to a hole
      udf: remove un-needed variable from inode_getblk

Zhao Hongjiang (1):
      ext3: get rid of the duplicate code on ext3_fill_super

The diffstat is

 fs/ext3/inode.c  |    3 +--
 fs/ext3/super.c  |    3 ---
 fs/quota/quota.c |    4 ++++
 fs/udf/inode.c   |   14 +++++++++-----
 4 files changed, 14 insertions(+), 10 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

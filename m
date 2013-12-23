From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] ext2 fix
Date: Mon, 23 Dec 2013 21:51:21 +0100
Message-ID: <20131223205121.GA5182@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab3LWUvY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 15:51:24 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get one simple fix of oops in ext2 which was recently hit by Christoph.

Top of the tree is df4e7ac0bb70. The full shortlog is:

Jan Kara (1):
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()

The diffstat is

 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

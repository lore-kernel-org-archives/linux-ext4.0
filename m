From: Jan Kara <jack@suse.cz>
Subject: [PULL] ext3 regression fix (deadlock)
Date: Mon, 26 Nov 2012 12:35:03 +0100
Message-ID: <20121126113503.GB4837@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2KZLfF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 06:35:05 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get a fix of an ext3 regression introduced during 3.7 merge window. It
leads to deadlock if you stress the filesystem in the right way (luckily
only if blocksize < pagesize).

Top of the tree is 25389bb. The full shortlog is:

Jan Kara (1):
      jbd: Fix lock ordering bug in journal_unmap_buffer()

The diffstat is

 fs/jbd/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

							Thanks
								Honza


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Fix for ext2 fs corruption under rename load
Date: Wed, 2 Mar 2011 11:13:17 +0100
Message-ID: <20110302101317.GB7496@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1CBKNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Mar 2011 05:13:18 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git
for_linus

to get a fix for a long-standing ext2 bug causing fs corruption. The
corruption isn't severe (only i_nlink gets corrupted) but still it isn't
nice thus I push the fix this late in the cycle.

The full shortlog is:

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

The diffstat is

 fs/ext2/namei.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

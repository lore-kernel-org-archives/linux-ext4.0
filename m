From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Ext3 and quota fix for 2.6.39-rc3
Date: Fri, 8 Apr 2011 07:40:35 +0200
Message-ID: <20110408054035.GA13864@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1DHFkm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Apr 2011 01:40:42 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git
for_linus

to get two fixes causing possible assertion failures due to bad credit
estimates.

The full shortlog is:

Jan Kara (1):
      quota: Don't write quota info in dquot_commit()

Yongqiang Yang (1):
      ext3: Fix writepage credits computation for ordered mode

The diffstat is

 fs/ext3/inode.c  |    2 +-
 fs/quota/dquot.c |   13 ++++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] ext[34]: Fix deadlock between truncate and get_block()
Date: Fri, 14 Aug 2009 14:26:08 +0200
Message-ID: <1250252772-13302-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbZHNM0N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Aug 2009 08:26:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  below come patches that fix lockdep annotations in JBD / JBD2 so that we are
properly warned about possibly deadlocks caused by a transaction being
restarted. Further follow patches that fix a possible deadlock between truncate
and get_blocks() in ext3/ext4 which Ted spotted. I'm quite confident in the ext3
fix but the ext4 fix definitely needs a serious review because there are
cosiderably more places working with the extent tree. I *think* ext4 patch is
fine as I argue in the changelog and I went through all places acquiring
i_data_sem but I might have missed some interaction / callsite...

									Honza

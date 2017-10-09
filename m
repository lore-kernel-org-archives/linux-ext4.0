From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] ext2: Avoid parsing options under a spinlock
Date: Mon,  9 Oct 2017 17:00:40 +0200
Message-ID: <20171009150042.31293-1-jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jia-Ju Bai <baijiaju1990@163.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47460 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754745AbdJIPAw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 9 Oct 2017 11:00:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

as Jia-Ju Bai pointed out, match_int() can sleep due to GFP_KERNEL allocation.
Change ext2 mount option parsing so that it does not happen under sbi->s_lock
spinlock. That is a reasonable change anyway and as a sideeffect we don't
have to restore old options if new options cannot be used for some reason.
If nobody objects, I'll push these patches through my tree.

								Honza

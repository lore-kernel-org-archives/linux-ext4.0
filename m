From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] ext4: Reduce contention on s_orphan_lock
Date: Wed, 30 Apr 2014 01:32:31 +0200
Message-ID: <1398814353-11904-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaD2Xcl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 19:32:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello,

  so I finally got to looking into your patches for reducing contention
on s_orphan_lock. AFAICT these two patches (the first one is just a
small cleanup) should have the same speed gain as the patches you wrote
and they are simpler. Can you give them a try please? Thanks!

								Honza

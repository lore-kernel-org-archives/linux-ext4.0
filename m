From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix buffer dirtying in data=journal mode
Date: Mon, 21 Jun 2010 12:42:51 +0200
Message-ID: <1277116973-4183-1-git-send-email-jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0FUKnU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jun 2010 06:43:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 82ACA8672B
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jun 2010 12:43:19 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  two patches below fix warnings and possible BUGs in ext3/ext4 when running
in data=journal mode (see https://bugzilla.kernel.org/show_bug.cgi?id=14156).
Admittedly, the workaround I've chosen is kind of ugly but reimplementing
block_prepare_write() just for the data=journal mode seems even uglier to me.
If anybody has better solution, I'd gladly hear it.

								Honza

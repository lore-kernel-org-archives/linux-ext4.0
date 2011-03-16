From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix BUG_ON and hang in ext4_da_writepages() in presence of IO errors
Date: Wed, 16 Mar 2011 21:52:52 +0100
Message-ID: <1300308774-14140-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab1CPUxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2011 16:53:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi Ted,

  I've noticed ext4 crashes when ext4_da_writepages() is confronted with IO
errors. The two patches in this series fix the issues for me so now the
system survives when the device is removed from under it. Could you please
apply them? Thanks.

								Honza

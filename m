From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Small cleanup of ext[34] get_blocks function
Date: Wed, 20 May 2009 19:25:32 +0200
Message-ID: <1242840334-5117-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56443 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbZETRZf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 13:25:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  two patches below cleanup get_blocks() functions of ext3 and ext4 - they
remove parameter extend_disksize which was in fact unused. Ted, would you
merge the ext4 patch and Andrew, would you merge the ext3 patch? Thanks.

								Honza

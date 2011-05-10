From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Wed, 11 May 2011 00:29:31 +0200
Message-ID: <1305066574-1573-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1EJW3r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 18:29:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  following three patches reimplement ext4_page_mkwrite() so that it returns
locked pages (which is necessary for stable pages work and also for fixing of
freezing code). As a bonus we also avoid taking i_alloc_sem as it's not
necessary and use generic block_page_mkwrite() helper. The common delalloc
path should be more straightforward now.

The last patch in the series blocks mmaped writes on frozen filesystem which
is simple to do now.

I've tested these patches by xfstests and also running fsx-linux for all
modes - delalloc, nodelalloc (data=writeback), nodelalloc (data=ordered),
nodelalloc (data=journal).

								Honza

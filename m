From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] Clean up of delalloc code and map-on-close/rename fixes
Date: Tue, 24 Feb 2009 00:05:46 -0500
Message-ID: <1235451952-2726-1-git-send-email-tytso@mit.edu>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40276 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbZBXFGE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 00:06:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Ok, here are the patches I was talking about at our call today.  They
clean up the delalloc code, and then add an ioctl for forcing delayed
allocation blocks to be allocated.  The last two patches force delayed
allocation blocks to be allocated on close if the file had been
previously truncated, and on rename if the old file is displacing
another file.

I would appreicate some review.

Thanks!!

							- Ted

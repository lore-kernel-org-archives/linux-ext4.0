From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix data corruption when blocksize < pagesize
Date: Tue, 23 Sep 2014 17:03:21 +0200
Message-ID: <1411484603-17756-1-git-send-email-jack@suse.cz>
Cc: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbaIWPDf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 11:03:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello,

  these two patches fix the data corruption triggered by xfstests
generic/030 test for ext4. I believe XFS can use the same function to
deal with the problem... Dave can you verify? If the function is indeed
usable for XFS as well, through which tree are we going to merge it?
ext4 or xfs?

								Honza

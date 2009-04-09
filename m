From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Thu, 09 Apr 2009 16:48:06 -0400
Message-ID: <E1Ls1AM-0005OR-NI@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56105 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760807AbZDIUsP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Apr 2009 16:48:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please grab the latest ext4 fixes from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Thanks!!

						- Ted

From: Thiemo Nagel (1):
      ext4: check block device size on mount

Thiemo Nagel (2):
      ext4: Fix big-endian problem in __ext4_check_blockref()
      ext4: Fix off-by-one-error in ext4_valid_extent_idx()

 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |    8 ++++----
 fs/ext4/super.c   |    9 +++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)



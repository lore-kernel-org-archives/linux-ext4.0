From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Fri, 15 May 2009 09:52:10 -0400
Message-ID: <E1M4xpa-0003yz-Iy@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33341 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZEONwO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 09:52:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following fixes for ext4.

                                                - Ted

Aneesh Kumar K.V (3):
      ext4: Fix sub-block zeroing for writes into preallocated extents
      ext4: Use a fake block number for delayed new buffer_head
      ext4: Clear the unwritten buffer_head flag after the extent is initialized

Theodore Ts'o (1):
      ext4: Fix race in ext4_inode_info.i_cached_extent

 fs/ext4/extents.c |   19 ++++++++++++++-----
 fs/ext4/inode.c   |   26 +++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 6 deletions(-)

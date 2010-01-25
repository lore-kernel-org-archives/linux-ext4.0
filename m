From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Mon, 25 Jan 2010 16:31:13 -0500
Message-ID: <E1NZWWf-00047q-QF@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59567 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0AYVb0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jan 2010 16:31:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following regression fixes for ext4 and jbd2.

Thanks,

                                                - Ted

Aneesh Kumar K.V (3):
      ext4: Handle -EDQUOT error on write
      ext4: Fix quota accounting error with fallocate
      ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag

 fs/ext4/ext4.h    |    9 ++---
 fs/ext4/extents.c |   21 +++++++++++++
 fs/ext4/inode.c   |   82 +++++++++++++++++++++++++++++++++-------------------
 3 files changed, 77 insertions(+), 35 deletions(-)

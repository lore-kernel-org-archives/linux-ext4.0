From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 2.6.30-rc3
Date: Mon, 27 Apr 2009 09:31:35 -0400
Message-ID: <E1LyQvn-0008N6-6y@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56450 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZD0Nbl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 09:31:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following fixes for ext4.

                                                - Ted

Theodore Ts'o (3):
      ext4: Fix softlockup caused by illegal i_file_acl value in on-disk inode
      ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
      ext4: Do not try to validate extents on special files

 fs/ext4/inode.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

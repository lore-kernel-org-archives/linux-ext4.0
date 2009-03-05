From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Thu, 05 Mar 2009 14:02:46 -0500
Message-ID: <E1LfIqE-0002Q0-3J@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53034 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZCETCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Mar 2009 14:02:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab a regression fix for ext4.  Thanks!!

                                                - Ted


Eric Sandeen (1):
      ext4: fix ext4_free_inode() vs. ext4_claim_inode() race

 fs/ext4/ialloc.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

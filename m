From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Tue, 17 Mar 2009 16:39:41 -0400
Message-ID: <E1Ljg4b-0000us-NG@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41591 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZCQUjs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 16:39:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab final 2.6.29 fixes for ext4.  Thanks!!

						- Ted
	
Eric Sandeen (3):
      ext4: fix header check in ext4_ext_search_right() for deep extent trees.
      ext4: fix bogus BUG_ONs in in mballoc code
      ext4: fix bb_prealloc_list corruption due to wrong group locking

Theodore Ts'o (1):
      ext4: Print the find_group_flex() warning only once

 fs/ext4/extents.c |    6 ++++--
 fs/ext4/ialloc.c  |    4 +++-
 fs/ext4/mballoc.c |   13 +++++++++----
 3 files changed, 16 insertions(+), 7 deletions(-)

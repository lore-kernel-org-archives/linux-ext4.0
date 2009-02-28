From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Sat, 28 Feb 2009 09:44:01 -0500
Message-ID: <E1LdQQ5-0004kd-OD@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZB1OoI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Feb 2009 09:44:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab two two more bug fixes for ext4.  Thanks!!

                                                - Ted

Theodore Ts'o (2):
      ext4: Remove duplicate call to ext4_commit_super() in ext4_freeze()
      ext4: Reorder fs/Makefile so that ext2 root fs's are mounted using ext2

 fs/Makefile     |    6 ++++--
 fs/ext4/super.c |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)


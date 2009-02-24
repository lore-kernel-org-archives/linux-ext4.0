From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Tue, 24 Feb 2009 12:19:49 -0500
Message-ID: <E1Lc0wf-0002En-Ry@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34839 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbZBXRT6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 12:19:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab two critical bug fixes for ext4.  Thanks!!

						- Ted

Jan Kara (1):
      ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()

Theodore Ts'o (1):
      ext4: Add fallback for find_group_flex

 fs/ext4/ialloc.c |    7 +++++++
 fs/ext4/inode.c  |    9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)



From: "Theodore Ts'o" <tytso@mit.edu>
Subject: What's in e2fsprogs.git (stable)
Date: Sun, 04 Nov 2007 17:43:53 -0500
Message-ID: <E1IooC9-0006TJ-Q6@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50314 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbXKDWoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Nov 2007 17:44:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* The 'maint' branch has these fixes since the last announcement.

Theodore Ts'o (1):
  Fix typo in the summary section of the blkid man page


* The 'master' branch has these since the last announcement
  in addition to the above.

Valerie Clement (3):
  libext2fs: use ext2fs_group_first_block() instead of open-coded
      equivalent
  libext2fs: cleanup usage of unsigned int or __u32 and replace it
      with blk_t
  libext2fs: Add EXT2_DESC_SIZE and EXT2_DESC_PER_BLOCK macros

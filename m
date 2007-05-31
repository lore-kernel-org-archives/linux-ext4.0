From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT] Please pull ext4 bug fixes
Date: Thu, 31 May 2007 17:24:06 -0400
Message-ID: <E1Hts7q-0001zK-Ce@candygram.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56066 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbXEaVYJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2007 17:24:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi Linus,

Please pull from the "for_linus" branch at:

	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

It contains the following fixes, which (except for the superblock field
reservations) have all been in the -mm tree for quite a while.

Thanks, regards,

						- Ted


 fs/ext4/balloc.c                |    6 -
 fs/ext4/extents.c               |  148 +++++++++++++++++++++++++++-------------
 fs/ext4/inode.c                 |    4 -
 fs/ext4/namei.c                 |    4 -
 fs/ext4/super.c                 |    2 
 include/linux/ext4_fs.h         |   33 +++++---
 include/linux/ext4_fs_extents.h |    5 -
 include/linux/ext4_fs_i.h       |    6 -
 8 files changed, 134 insertions(+), 74 deletions(-)

Alex Tomas (1):
      When ext4_ext_insert_extent() fails to insert new blocks

Amit Arora (1):
      ext4: Extent overlap bugfix

Dave Kleikamp (1):
      EXT4: Fix whitespace

Mingming Cao (1):
      Remove unnecessary exported symbols.

Theodore Ts'o (1):
      Define/reserve new ext4 superblock fields

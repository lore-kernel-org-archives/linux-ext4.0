From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext[234] bugfixes/cleanup
Date: Tue, 24 Jul 2007 00:03:07 -0400
Message-ID: <E1IDBc3-0004KF-PD@candygram.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35550 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbXGXEDO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 00:03:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Many thanks!!

						- Ted

Eric Sandeen (2):
      Fix fencepost error in ext[234]_check_descriptors
      Remove unused bh in calls to ext[234]_get_group_desc

Mingming Cao (1):
      Some cleanups in ext4/JBD2 to follow the naming rules

 b/fs/ext2/ialloc.c          |   24 ++++++++----------------
 b/fs/ext2/inode.c           |    2 +-
 b/fs/ext2/super.c           |    2 +-
 b/fs/ext3/ialloc.c          |   17 +++++++----------
 b/fs/ext3/super.c           |    2 +-
 b/fs/ext4/extents.c         |    2 +-
 b/fs/ext4/ialloc.c          |   17 +++++++----------
 b/fs/ext4/super.c           |    2 +-
 b/fs/jbd2/commit.c          |    2 +-
 b/fs/jbd2/journal.c         |   26 +++++++++++++-------------
 b/fs/jbd2/recovery.c        |    2 +-
 b/fs/jbd2/revoke.c          |    4 ++--
 b/include/linux/ext4_jbd2.h |    6 +++---
 b/include/linux/jbd2.h      |   30 +++++++++++++++---------------
 b/include/linux/poison.h    |    3 ++-
 fs/ext4/super.c             |    2 +-
 16 files changed, 65 insertions(+), 78 deletions(-)

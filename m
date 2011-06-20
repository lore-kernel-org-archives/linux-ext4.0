From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 3.0
Date: Mon, 20 Jun 2011 12:54:07 -0400
Message-ID: <E1QYhjj-0006Ne-Lp@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51738 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1FTQyL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 12:54:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab bug fixes needed for 3.0.

Thanks!!

					- Ted

Jan Kara (1):
      jbd2: Fix oops in jbd2_journal_remove_journal_head()

Lukas Czerner (3):
      ext4: Fix max file size and logical block counting of extent format file
      ext4: use FIEMAP_EXTENT_LAST flag for last extent in fiemap
      ext4: fixed tracepoints cleanup

Tao Ma (1):
      jbd2: Remove obsolete parameters in the comments for some jbd2 functions

Yongqiang Yang (1):
      ext4: correct comments for ext4_free_blocks()

 fs/ext4/ext4_extents.h      |    9 ++-
 fs/ext4/extents.c           |   42 +++++-----
 fs/ext4/inode.c             |    2 +-
 fs/ext4/mballoc.c           |    8 +-
 fs/ext4/move_extent.c       |   10 +-
 fs/ext4/super.c             |   15 +++-
 fs/jbd2/checkpoint.c        |   28 ++++---
 fs/jbd2/commit.c            |   33 +++++----
 fs/jbd2/journal.c           |   91 +++++++---------------
 fs/jbd2/transaction.c       |   69 +++++++++--------
 include/linux/jbd2.h        |    2 -
 include/trace/events/ext4.h |  179 ++++++++++++++++++-------------------------
 12 files changed, 223 insertions(+), 265 deletions(-)

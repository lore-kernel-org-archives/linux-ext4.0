From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 3.1-rc3
Date: Sun, 21 Aug 2011 00:45:54 -0400
Message-ID: <E1Quzv0-0002pd-P2@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59126 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1HUEp6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Aug 2011 00:45:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

These fix a number of bugs (some of them data corruptors) when a various
obscure or less commonly-used ext4 mount options/modes are enabled
(i.e., dioread_nolock, data=journal, nojournal mode).

Please pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

						- Ted

Curt Wohlgemuth (1):
      ext4: Fix ext4_should_writeback_data() for no-journal mode

Jiaying Zhang (2):
      ext4: call ext4_ioend_wait and ext4_flush_completed_IO in ext4_evict_inode
      ext4: flush any pending end_io requests before DIO reads w/dioread_nolock

Tao Ma (1):
      ext4: Resolve the hang of direct i/o read in handling EXT4_IO_END_UNWRITTEN.

Theodore Ts'o (1):
      ext4: fix nomblk_io_submit option so it correctly converts uninit blocks

 fs/ext4/ext4_jbd2.h |    4 ++--
 fs/ext4/indirect.c  |    9 +++++++--
 fs/ext4/inode.c     |   26 ++++++++++++++++++++++++--
 fs/ext4/page-io.c   |    6 ++++--
 fs/ext4/super.c     |    1 -
 5 files changed, 37 insertions(+), 9 deletions(-)

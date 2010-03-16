From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.27.y 00/11] *** SUBJECT HERE ***
Date: Mon, 15 Mar 2010 20:25:54 -0400
Message-ID: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38643 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842Ab0CPA0L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Mar 2010 20:26:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These are the patches backported by Jayson R. King.  I've eyeballed
them, and run them through a xfsqa test run, and they look good to me.

Greg, please apply them to the 2.6.27 kernel.

      	     	   					- Ted

Aneesh Kumar K.V (10):
  ext4: invalidate pages if delalloc block allocation fails.
  ext4: Make sure all the block allocation paths reserve blocks
  ext4: Add percpu dirty block accounting.
  ext4: Retry block reservation
  ext4: Retry block allocation if we have free blocks left
  ext4: Use tag dirty lookup during mpage_da_submit_io
  vfs: Remove the range_cont writeback mode.
  vfs: Add no_nrwrite_index_update writeback control flag
  ext4: Fix file fragmentation during large file write.
  ext4: Implement range_cyclic in ext4_da_writepages instead of
    write_cache_pages

Mingming Cao (1):
  percpu counter: clean up percpu_counter_sum_and_set()

 fs/ext4/balloc.c               |   88 +++++++++---
 fs/ext4/ext4.h                 |   13 ++
 fs/ext4/ext4_sb.h              |    1 +
 fs/ext4/inode.c                |  314 ++++++++++++++++++++++++++++------------
 fs/ext4/mballoc.c              |   39 +++--
 fs/ext4/super.c                |    8 +-
 include/linux/percpu_counter.h |   12 +-
 include/linux/writeback.h      |   10 +-
 lib/percpu_counter.c           |    8 +-
 mm/page-writeback.c            |   16 +-
 10 files changed, 360 insertions(+), 149 deletions(-)


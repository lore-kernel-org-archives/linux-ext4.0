From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6] ext4: rewrite I/O submission paths to use bio's directly
Date: Fri, 22 Oct 2010 11:29:20 -0400
Message-ID: <1287761366-20249-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33668 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0JVP3b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 11:29:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the first draft of the patches that rewrite ext4's I/O
submission paths to use the block I/O layer directly instead of using
the buffer layer.  This reduces lock contention on the block queue
submission layers, and it should reduce CPU usage significantly.

There is still some cleanup and testing to be done, but this should be
good enough for benchmarking purposes.  This patch series survives
xfstests with 4k blocks, and minimal testing with 1k blocks.

	      	 	     	     	     - Ted

Theodore Ts'o (6):
  ext4: call mpage_da_submit_io() from mpage_da_map_blocks()
  ext4: simplify ext4_writepage()
  ext4: inline ext4_writepage() into mpage_da_submit_io()
  ext4: inline walk_page_buffers() into mpage_da_submit_io
  ext4: move mpage_put_bnr_to_bhs()'s functionality to
    mpage_da_submit_io()
  ext4: use bio layer instead of buffer layer in mpage_da_submit_io

 fs/ext4/Makefile  |    2 +-
 fs/ext4/ext4.h    |   33 ++++-
 fs/ext4/extents.c |    4 +-
 fs/ext4/inode.c   |  429 +++++++++++++++++++----------------------------------
 fs/ext4/page-io.c |  363 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c   |    8 +-
 6 files changed, 555 insertions(+), 284 deletions(-)
 create mode 100644 fs/ext4/page-io.c


From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 0/8] e2fsprogs: Fix various cases of undefined behavior
Date: Fri, 14 Dec 2012 00:04:02 +0200
Message-ID: <20121213220402.GH9713@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:52324 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab2LMWjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:39:12 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4FjG022291
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:15 +0200
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 31959-1351 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:15 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM43mx022281
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:03 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This set of patches fixes a number of issues causing undefined
behavior.  These were caught by running the test suite after
compiling e2fsprogs with the Clang compiler and -fsanitize=undefined.

Sami Liedes (8):
  lib/blkid/list.h: Fix undefined behavior in list_entry() macro
  lib/ext2fs/rbtree.h: Fix container_of() undefined behavior
  e2fsck/pass1.c: Fix undefined behavior in check_blocks()
  lib/ext2fs/block.c: Fix undefined behavior in block_iterate_tind()
  e2fsck/revoke.c: Fix undefined behavior in hash()
  lib/ext2fs/kernel-list.h: Fix undefined behavior in list_entry()
    macro
  lib/ext2fs/qcow2.h: Fix #defined 1<<63 values to be unsigned.
  e2fsck/jfs_user.h: Fix b_data alignment in struct buffer_head

 e2fsck/jfs_user.h        |    2 +-
 e2fsck/pass1.c           |    2 +-
 e2fsck/revoke.c          |    2 +-
 lib/blkid/list.h         |    5 +++--
 lib/ext2fs/block.c       |    2 +-
 lib/ext2fs/kernel-list.h |    6 ++++--
 lib/ext2fs/qcow2.h       |    4 ++--
 lib/ext2fs/rbtree.h      |    2 ++
 misc/e2image.c           |    2 +-
 9 files changed, 16 insertions(+), 11 deletions(-)

-- 
1.7.10.4

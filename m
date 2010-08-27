From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Relatively simple ext4 todo item
Date: Fri, 27 Aug 2010 17:25:56 -0400
Message-ID: <E1Op6Qu-0005Df-J6@tytso-glaptop>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34783 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0H0VZ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Aug 2010 17:25:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For folks who are interested in getting started with ext4, here's a
relatively simple todo item.

Wu Fenguang has reported a scalability issue with ext4 when running a VM
stress test where there are multiple processes all hammering the file
with random mmap requests.  (Although this would have shown up as well
if we had multiple threads all trying to read from the same file
descriptor at the same time.)  The point of contention is
ext4_inode_info.i_block_reservation_lock(), and the problem is that
we're using this spinlock to protect a simple singleton extent cache,
i_cached_extent.  See the functions ext4_ext_put_gap_in_cache() and
ext4_ext_in_cache().

Your mission should you choose to accept it :-), is to replace
i_cached_extent with an RCU protected data structure.  For bonus points,
try making it support caching more than a single extent.  Also, while
you're at it, fix a race condition with move_inode.c where we should
make should the cached extents have been removed and an RCU grace period
has elapsed before proceeding with the inode defragmentation.

						- Ted

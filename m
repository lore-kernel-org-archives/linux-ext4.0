From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC] ext4-use-generic-discard-reservations-call
Date: Thu, 14 Aug 2008 15:54:45 -0400
Message-ID: <E1KTiuD-0000ej-JZ@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53316 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752566AbYHNTyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 15:54:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Does this patch make sense?  I noticed that in the extents version of
the truncate, we call the mballoc-specific version of
ext4_discard_reservation(), instead of ext4_discard_reservation()
directly.  As a result, if the filesystem is mounted -o nomballoc, we
won't throw away the reservation window when truncating or unlinking an
extents-based file.   We are using ext4_discard_reservation() in
non-extent truncate code, which is what made me notice this.

	   	    	  	   	- Ted

ext4: Use ext4_discard_reservations instead of mballoc-specific call

In ext4_ext_truncate(), we should use the more generic
ext4_discard_reservations() call so we do the right thing when the
filesystem is mounted with the nomballoc option.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3c82ab1..30a59b8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2963,7 +2963,7 @@ void ext4_ext_truncate(struct inode *inode)
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_ext_invalidate_cache(inode);
 
-	ext4_mb_discard_inode_preallocations(inode);
+	ext4_discard_reservation(inode);
 
 	/*
 	 * TODO: optimization is possible here.

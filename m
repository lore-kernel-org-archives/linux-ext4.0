From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/5] ext4: Error out if verifying the block bitmap fails
Date: Fri, 19 Jul 2013 16:55:39 -0700
Message-ID: <20130719235539.24017.94739.stgit@blackbox.djwong.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32186 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3GSXzq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jul 2013 19:55:46 -0400
In-Reply-To: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block bitmap verification code assumes that calling ext4_error() either
panics the system or makes the fs readonly.  However, this is not always true:
when 'errors=continue' is specified, an error is printed but we don't return
any indication of error to the caller, which is (probably) the block allocator,
which pretends that the crud we read in off the disk is a usable bitmap.  Yuck.

A block bitmap that fails the check should at least return no bitmap to the
caller.  The block allocator should be told to go look in a different group,
but that's a separate issue.

The easiest way to reproduce this is to modify bg_block_bitmap (on a ^flex_bg
fs) to point to a block outside the block group; or you can create a
metadata_csum filesystem and zero out the block bitmaps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index ddd715e..b430afe 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -445,7 +445,10 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	return bh;
 verify:
 	ext4_validate_block_bitmap(sb, desc, block_group, bh);
-	return bh;
+	if (buffer_verified(bh))
+		return bh;
+	put_bh(bh);
+	return NULL;
 }
 
 /* Returns 0 on success, 1 on error */
@@ -469,7 +472,8 @@ int ext4_wait_block_bitmap(struct super_block *sb, ext4_group_t block_group,
 	clear_buffer_new(bh);
 	/* Panic or remount fs read-only if block bitmap is invalid */
 	ext4_validate_block_bitmap(sb, desc, block_group, bh);
-	return 0;
+	/* ...but check for error just in case errors=continue. */
+	return !buffer_verified(bh);
 }
 
 struct buffer_head *


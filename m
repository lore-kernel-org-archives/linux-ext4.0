From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: don't swap extent-based journal backup on read
Date: Tue, 10 Nov 2009 14:45:44 -0600
Message-ID: <4AF9D0F8.6020609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057AbZKJUpj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2009 15:45:39 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAAKjk8F004784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2009 15:45:47 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nAAKjitV025340
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2009 15:45:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The f_illitable_flexbg test was failing on ppc, because
e2fsck_move_ext3_journal is doing a direct memcmp of i_block with 
s_jnl_blocks, and failing.

This is because we don't swap extent data on read from disk; rather
we do it when we access the extents.  However, ext2fs_swap_super
was swapping s_jnl_blocks unconditionally, so these didn't match.

Looks like we need to treat s_jnl_blocks the same as i_block, and
swap it on access, not on read.  Except for the last i_size bit...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 42bc01e..38f5f9b 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -73,9 +73,19 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_kbytes_written = ext2fs_swab64(sb->s_kbytes_written);
 	for (i=0; i < 4; i++)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
+
+	/* if journal backup is for a valid extent-based journal... */
+	if (!ext2fs_extent_header_verify(sb->s_jnl_blocks,
+					 sizeof(sb->s_jnl_blocks))) {
+		/* ... swap only the journal i_size */
+		sb->s_jnl_blocks[16] = ext2fs_swab32(sb->s_jnl_blocks[16]);
+		/* and the extent data is not swapped on read */
+		return;
+	}
+
+	/* direct/indirect journal: swap it all */
 	for (i=0; i < 17; i++)
 		sb->s_jnl_blocks[i] = ext2fs_swab32(sb->s_jnl_blocks[i]);

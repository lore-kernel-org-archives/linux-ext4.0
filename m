From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: don't unconditionally zero blocks on dax writes
Date: Wed, 20 Sep 2017 16:44:44 -0500
Message-ID: <51f1e5a8-0276-5963-afba-b10c6e194b52@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdITVop (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Sep 2017 17:44:45 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The conversion to iomap seems to have lost the ability to
conditionally /not/ prezero dax blocks.  This leads to
double writes which cuts throughput in half in some
cases.

This puts back the old conditional zeroing logic.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I might be completely missing something here, i.e. whether
the change may have been intentional, etc.  The patch is
only lightly tested but a which check here seems to DTRT.

Thanks,
-Eric


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c774bdc..9179a59 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3423,6 +3423,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		int dio_credits;
 		handle_t *handle;
 		int retries = 0;
+		int flags;
 
 		/* Trim mapping request to maximum we can map at once for DIO */
 		if (map.m_len > DIO_MAX_BLOCKS)
@@ -3440,8 +3441,16 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
 
-		ret = ext4_map_blocks(handle, inode, &map,
-				      EXT4_GET_BLOCKS_CREATE_ZERO);
+		/*
+		 * We can avoid zeroing for aligned DAX writes beyond EOF. Other
+		 * writes need zeroing either because they can race with page
+		 * faults or because they use partial blocks.
+		 */
+		flags = EXT4_GET_BLOCKS_PRE_IO | EXT4_GET_BLOCKS_CREATE;
+		if (round_down(offset, 1<<inode->i_blkbits) < inode->i_size ||
+					!ext4_aligned_io(inode, offset, length))
+			flags |= EXT4_GET_BLOCKS_ZERO;
+		ret = ext4_map_blocks(handle, inode, &map, flags);
 		if (ret < 0) {
 			ext4_journal_stop(handle);
 			if (ret == -ENOSPC &&

From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: allocate inode table wholly within group
Date: Mon, 08 Jul 2013 16:27:21 -0500
Message-ID: <51DB2EB9.4010903@redhat.com>
References: <51D3269B.5080608@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030301020001030608030407"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3GHV1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jul 2013 17:27:22 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r68LRM4W002003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 8 Jul 2013 17:27:22 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r68LRL0F030105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 8 Jul 2013 17:27:21 -0400
In-Reply-To: <51D3269B.5080608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030301020001030608030407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ok, resetting a little on this one.

The actual problem seems to be that the test does successive "-M" minimal resizes, and eventually we resize into the middle of an inode table, leaving the end of the table beyond the fs.

Point "resize2fs -M" at the attached image once or twice w/ fscks in between and you should see it.

It seems like the obvious fix would be to move the inode table if necessary, as with the following patch.

But then of course we find that we've run out of room to move the table, and the resize fails; so we've let resize2fs choose its own minimum size - which which it cannot handle.  Presumably something's gone wrong in calculate_minimum_resize_size(), though I can't tell what.

Truth be told, I'm not enjoying resize2fs right now!

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 204b10a..27dc5e6 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -891,18 +891,25 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	new_size = ext2fs_blocks_count(fs->super);
 	if (new_size < ext2fs_blocks_count(old_fs->super)) {
 		for (g = 0; g < fs->group_desc_count; g++) {
+			int realloc = 0;
 			/*
 			 * ext2fs_allocate_group_table re-allocates bitmaps
 			 * which are set to block 0.
 			 */
 			if (ext2fs_block_bitmap_loc(fs, g) >= new_size) {
 				ext2fs_block_bitmap_loc_set(fs, g, 0);
-				retval = ext2fs_allocate_group_table(fs, g, 0);
-				if (retval)
-					return retval;
+				realloc = 1;
 			}
 			if (ext2fs_inode_bitmap_loc(fs, g) >= new_size) {
 				ext2fs_inode_bitmap_loc_set(fs, g, 0);
+				realloc = 1;
+			}
+			if (ext2fs_inode_table_loc(fs, g) + fs->inode_blocks_per_group > new_size) {
+				ext2fs_inode_table_loc_set(fs, g, 0);
+				realloc = 1;
+			}
+
+			if (realloc) {
 				retval = ext2fs_allocate_group_table(fs, g, 0);
 				if (retval)
 					return retval;

--------------030301020001030608030407
Content-Type: application/x-bzip;
 name="test.img.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="test.img.bz2"

QlpoOTFBWSZTWaUqFtIAACr/////////////////////////////////////////////4Aef
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
--------------030301020001030608030407--

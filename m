From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ext4: remove another test in ext4_alloc_file_blocks()
Date: Wed, 12 Oct 2016 09:00:02 +0300
Message-ID: <20161012060002.GA12778@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Fabian Frederick <fabf@skynet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19551 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753552AbcJLGCi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Oct 2016 02:02:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Before commit c3fe493ccdb1 ('ext4: remove unneeded test in
ext4_alloc_file_blocks()') then it was possible for "depth" to be -1
but now, it's not possible that it is negative.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c930a01..dca394c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4701,7 +4701,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 		/*
 		 * Recalculate credits when extent tree depth changes.
 		 */
-		if (depth >= 0 && depth != ext_depth(inode)) {
+		if (depth != ext_depth(inode)) {
 			credits = ext4_chunk_trans_blocks(inode, len);
 			depth = ext_depth(inode);
 		}

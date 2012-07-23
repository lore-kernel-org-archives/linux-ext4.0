From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] ext4: remove redundant offset check in move_extents.c/mext_check_arguments
Date: Mon, 23 Jul 2012 16:03:14 +0800
Message-ID: <500D0542.1020000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40564 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2GWID0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jul 2012 04:03:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the check code above, if orig_start != donor_start, we would
return -EINVAL. So here, orig_start should be equal with donor_start.
Remove the redundant check here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/move_extent.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..8383257 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1002,7 +1002,6 @@ mext_check_arguments(struct inode *orig_inode,
 	}
 
 	if ((orig_start >= EXT_MAX_BLOCKS) ||
-	    (donor_start >= EXT_MAX_BLOCKS) ||
 	    (*len > EXT_MAX_BLOCKS) ||
 	    (orig_start + *len >= EXT_MAX_BLOCKS))  {
 		ext4_debug("ext4 move extent: Can't handle over [%u] blocks "
-- 
1.7.1


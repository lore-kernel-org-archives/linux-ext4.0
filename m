From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: error handling fix in ext4_ext_convert_to_initialized()
Date: Tue, 11 Oct 2011 16:49:12 +0300
Message-ID: <20111011134912.GB27127@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:54461 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1JKNtd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Oct 2011 09:49:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When allocated is unsiged it breaks the error handling at the end
of the function when we call:
	allocated = ext4_split_extent(...);
	if (allocated < 0)
		err = allocated;

I've made it a signed int instead of unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
You guys know I'm not an ext4 expert.  I can't swear that the math
all works correctly with a signed int.  I'm pretty sure it does, but
please review this carefully.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..d65b268 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2919,7 +2919,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_extent zero_ex;
 	struct ext4_extent *ex;
 	ext4_lblk_t ee_block, eof_block;
-	unsigned int allocated, ee_len, depth;
+	unsigned int ee_len, depth;
+	int allocated;
 	int err = 0;
 	int split_flag = 0;
 

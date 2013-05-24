From: ashishsangwan2@gmail.com
Subject: [PATCH] ext4: optimize extent selection for block removal in case of hole punch
Date: Fri, 24 May 2013 20:09:17 +0530
Message-ID: <519f7ba2.04fc440a.06c2.ffffd589@mx.google.com>
Cc: linux-ext4@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: tytso@mit.edu, adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53506 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3EXOjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 May 2013 10:39:31 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl12so920034pab.6
        for <linux-ext4@vger.kernel.org>; Fri, 24 May 2013 07:39:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ashish Sangwan <a.sangwan@samsung.com>

Both hole punch and truncate use ext4_ext_rm_leaf for removing
blocks. Currently we choose the last extent as the starting
point for removing blocks: ex = EXT_LAST_EXTENT(eh);
This is OK for truncate but for hole punch we can optimize the
extent selection as the path is already initialized.
We could use this information to select proper starting extent.
The code change in this patch will not affect truncate as for
truncate path[depth].p_ext will always be NULL.

Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/ext4/extents.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3676dae..7c1a5d3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2490,7 +2490,9 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		return -EIO;
 	}
 	/* find where to start removing */
-	ex = EXT_LAST_EXTENT(eh);
+	ex = path[depth].p_ext;
+	if (!ex)
+		ex = EXT_LAST_EXTENT(eh);
 
 	ex_ee_block = le32_to_cpu(ex->ee_block);
 	ex_ee_len = ext4_ext_get_actual_len(ex);
-- 
1.7.2.3


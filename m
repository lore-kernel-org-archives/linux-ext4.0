From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 2/2] ext4: fix null pointer bug in move_extent.c
Date: Sun,  2 Aug 2009 19:43:24 +0800
Message-ID: <1249213404-6277-2-git-send-email-bergwolf@gmail.com>
References: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f200.google.com ([209.85.222.200]:37047 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZHBLnf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Aug 2009 07:43:35 -0400
Received: by mail-pz0-f200.google.com with SMTP id 38so1735571pzk.33
        for <linux-ext4@vger.kernel.org>; Sun, 02 Aug 2009 04:43:35 -0700 (PDT)
In-Reply-To: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In mext_replace_branches(), the oext and dext virable might be NULL if the
orig extent and donor extent are empty. Later calling *oext and *dext will
trigger a kernel null pointer bug like this:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa0636563>] mext_replace_branches+0x10c/0x2f3 [ext4]
PGD 37dba067 PUD cd8ac067 PMD 0
Oops: 0000 [#1] SMP

The patch checks the two virables and returns EOPNOTSUPP if either of them
is NULL.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 fs/ext4/move_extent.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 5821e0b..4923f70 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -641,10 +641,22 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 		goto out;
 	depth = ext_depth(orig_inode);
 	oext = orig_path[depth].p_ext;
+	if (oext == NULL) {
+		ext4_debug("ext4 move extent: "
+					"orig extents should not be empty\n");
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 	tmp_oext = *oext;
 
 	depth = ext_depth(donor_inode);
 	dext = donor_path[depth].p_ext;
+	if (dext == NULL) {
+		ext4_debug("ext4 move extent: "
+					"donor extents should not be empty\n");
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 	tmp_dext = *dext;
 
 	mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
-- 
1.6.2.GIT


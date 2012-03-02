From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] ext4: Give more helpful error message in ext4_ext_rm_leaf()
Date: Fri,  2 Mar 2012 11:26:03 +0100
Message-ID: <1330683963-15791-3-git-send-email-lczerner@redhat.com>
References: <1330683963-15791-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab2CBK0R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 05:26:17 -0500
In-Reply-To: <1330683963-15791-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The error message produced by the ext4_ext_rm_leaf() when we are
removing blocks which accidentally ends up inside the existing extent,
is not very helpful, because we would like to also know which extent did
we collide with.

This commit changes the error message to get us also the information
about the extent we are colliding with.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f773e5f..a7c2c4c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2364,8 +2364,11 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			ex_ee_len = ext4_ext_get_actual_len(ex);
 			continue;
 		} else if (b != ex_ee_block + ex_ee_len - 1) {
-			EXT4_ERROR_INODE(inode,"  bad truncate %u:%u\n",
-					 start, end);
+			EXT4_ERROR_INODE(inode,
+					 " Can not handle truncate %u:%u "
+					 "on extent %u:%u\n",
+					 start, end, ex_ee_block,
+					 ex_ee_block + ex_ee_len - 1);
 			err = -EIO;
 			goto out;
 		} else if (a != ex_ee_block) {
-- 
1.7.4.4


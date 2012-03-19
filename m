From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3 v2] ext4: Give more helpful error message in ext4_ext_rm_leaf()
Date: Mon, 19 Mar 2012 19:19:35 +0100
Message-ID: <1332181175-10503-3-git-send-email-lczerner@redhat.com>
References: <1332181175-10503-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030328Ab2CSSTu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 14:19:50 -0400
In-Reply-To: <1332181175-10503-1-git-send-email-lczerner@redhat.com>
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
v2: Nothing changed

 fs/ext4/extents.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ce593b7..9e10b82 100644
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


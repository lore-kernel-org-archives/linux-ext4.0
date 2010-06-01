From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 03/28] ext4: Remove unnecessary call to ext4_get_group_desc() in mballoc
Date: Tue,  1 Jun 2010 12:12:50 -0400
Message-ID: <1275408795-17487-3-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jing Zhang <zj.barak@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56884 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088Ab0FAQNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:22 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

commit 62e823a2cba18509ee826d775270e8ef9071b5bc upstream (as of v2.6.34-git13)

Signed-off-by: Jing Zhang <zj.barak@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b423a36..0550ea3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2025,7 +2025,6 @@ repeat:
 
 		for (i = 0; i < ngroups; group++, i++) {
 			struct ext4_group_info *grp;
-			struct ext4_group_desc *desc;
 
 			if (group == ngroups)
 				group = 0;
@@ -2048,7 +2047,6 @@ repeat:
 			}
 
 			ac->ac_groups_scanned++;
-			desc = ext4_get_group_desc(sb, group, NULL);
 			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 &&
-- 
1.6.6.1.1.g974db.dirty


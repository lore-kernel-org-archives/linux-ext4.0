From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: Remove unnecessary call to ext4_get_group_desc() in mballoc
Date: Thu,  1 Apr 2010 21:48:41 -0400
Message-ID: <1270172922-10876-1-git-send-email-tytso@mit.edu>
References: <ac8f92701003240514l77f5b597h605b06b5f6140674@mail.gmail.com>
Cc: Jing Zhang <zj.barak@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38767 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758995Ab0DBBs4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Apr 2010 21:48:56 -0400
In-Reply-To: <ac8f92701003240514l77f5b597h605b06b5f6140674@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Signed-off-by: Jing Zhang <zj.barak@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 54df209..fcc919f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2024,7 +2024,6 @@ repeat:
 
 		for (i = 0; i < ngroups; group++, i++) {
 			struct ext4_group_info *grp;
-			struct ext4_group_desc *desc;
 
 			if (group == ngroups)
 				group = 0;
@@ -2047,7 +2046,6 @@ repeat:
 			}
 
 			ac->ac_groups_scanned++;
-			desc = ext4_get_group_desc(sb, group, NULL);
 			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 &&
-- 
1.6.6.1.1.g974db.dirty


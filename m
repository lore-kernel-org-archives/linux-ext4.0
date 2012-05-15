From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] ext4: potential NULL dereference on error
Date: Tue, 15 May 2012 11:46:40 +0300
Message-ID: <20120515084640.GB30265@elgon.mountain>
References: <20120514222535.GW5353@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32999 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab2EOIr1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2012 04:47:27 -0400
Content-Disposition: inline
In-Reply-To: <20120514222535.GW5353@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_get_group_desc() function returns NULL on error, and
ext4_free_inodes_count() function dereferences it without checking.
There is a check on the next line, but it's too late.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: cleaned up the style

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a044a9b..ea32d7e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -508,10 +508,12 @@ fallback_retry:
 	for (i = 0; i < ngroups; i++) {
 		grp = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc(sb, grp, NULL);
-		grp_free = ext4_free_inodes_count(sb, desc);
-		if (desc && grp_free && grp_free >= avefreei) {
-			*group = grp;
-			return 0;
+		if (desc) {
+			grp_free = ext4_free_inodes_count(sb, desc);
+			if (grp_free && grp_free >= avefreei) {
+				*group = grp;
+				return 0;
+			}
 		}
 	}
 

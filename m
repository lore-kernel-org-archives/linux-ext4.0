From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] debugfs: fix check for out-of-bound xattr value
Date: Tue,  9 Aug 2016 14:42:51 -0600
Message-ID: <1470775371-19591-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:29160 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbcHIUnN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Aug 2016 16:43:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since commit v1.42.12-1-g8a546777119c, the check for in-inode
xattrs in internal_dump_inode_extra() has been incorrectly checking
the value size.  The value can go right to the end of the inode.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 debugfs/debugfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 260698c..329451c 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -557,9 +557,11 @@ static void internal_dump_inode_extra(FILE *out,
 			char *value = start + entry->e_value_offs;
 
 			if (name + entry->e_name_len >= end ||
-			    value + entry->e_value_size >= end ||
-			    (char *) next >= end) {
-				fprintf(out, "invalid EA entry in inode\n");
+			    value + entry->e_value_size > end ||
+			    (char *)next >= end) {
+				fprintf(out, "invalid EA entry in inode: "
+					"name_len=%u value_size=%u\n",
+					entry->e_name_len, entry->e_value_size);
 				return;
 			}
 			fprintf(out, "  ");
-- 
2.4.5


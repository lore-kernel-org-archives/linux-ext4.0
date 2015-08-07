From: Jan Kara <jack@suse.com>
Subject: [PATCH 16/19] ext2fs: Add extent dumping function to extent mapping code
Date: Fri,  7 Aug 2015 12:51:26 +0200
Message-ID: <1438944689-24562-17-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbbHGKvt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:49 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For testing extent mapping code, we will need the extent dumping
function. So copy that function over from the resize2fs version of the
code.

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/extent_map.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/lib/ext2fs/extent_map.c b/lib/ext2fs/extent_map.c
index 702172b24e2b..251212d118cb 100644
--- a/lib/ext2fs/extent_map.c
+++ b/lib/ext2fs/extent_map.c
@@ -231,3 +231,20 @@ errcode_t ext2fs_iterate_extent(ext2_map_extent extent, __u64 *old_loc,
 	*size = ent->size;
 	return 0;
 }
+
+/*
+ * For debugging only
+ */
+void ext2fs_extent_dump(ext2_map_extent extent, FILE *out)
+{
+	__u64	i;
+	struct ext2_map_extent_entry *ent;
+
+	fputs("# Extent dump:\n", out);
+	fprintf(out, "#\tNum=%llu, Size=%llu, Cursor=%llu, Sorted=%llu\n",
+	       extent->num, extent->size, extent->cursor, extent->sorted);
+	for (i=0, ent=extent->list; i < extent->num; i++, ent++) {
+		fprintf(out, "#\t\t %llu -> %llu (%llu)\n", ent->old_loc,
+			ent->new_loc, ent->size);
+	}
+}
-- 
2.1.4


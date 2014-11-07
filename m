From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/47] misc: fix compiler warnings and minor build errors
Date: Fri, 07 Nov 2014 13:50:55 -0800
Message-ID: <20141107215055.883.68207.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:00 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix some gcc-4.8 warnings and other problems that broke the build.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/region.c          |    8 ++++----
 lib/ext2fs/Makefile.in   |    2 +-
 lib/ext2fs/inline_data.c |    3 ---
 resize/resize2fs.c       |    2 +-
 4 files changed, 6 insertions(+), 9 deletions(-)


diff --git a/e2fsck/region.c b/e2fsck/region.c
index aaaaa19..e32f89d 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -159,10 +159,10 @@ void region_print(region_t region, FILE *f)
 	struct region_el	*r;
 	int	i = 0;
 
-	fprintf(f, "Printing region (min=%d. max=%d)\n\t", region->min,
+	fprintf(f, "Printing region (min=%llu. max=%llu)\n\t", region->min,
 		region->max);
 	for (r = region->allocated; r; r = r->next) {
-		fprintf(f, "(%d, %d)  ", r->start, r->end);
+		fprintf(f, "(%llu, %llu)  ", r->start, r->end);
 		if (++i >= 8)
 			fprintf(f, "\n\t");
 	}
@@ -183,7 +183,7 @@ int main(int argc, char **argv)
 		case BCODE_CREATE:
 			start = bcode_program[pc++];
 			end = bcode_program[pc++];
-			printf("Creating region with args(%d, %d)\n",
+			printf("Creating region with args(%llu, %llu)\n",
 			       start, end);
 			r = region_create(start, end);
 			if (!r) {
@@ -195,7 +195,7 @@ int main(int argc, char **argv)
 			start = bcode_program[pc++];
 			end = bcode_program[pc++];
 			ret = region_allocate(r, start, end);
-			printf("Region_allocate(%d, %d) returns %d\n",
+			printf("Region_allocate(%llu, %llu) returns %d\n",
 			       start, end, ret);
 			break;
 		case BCODE_PRINT:
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index dc3e144..2706bfa 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -415,7 +415,7 @@ recovery.o: $(top_srcdir)/e2fsck/recovery.c
 
 plausible.o: $(top_srcdir)/misc/plausible.c
 	$(E) "	CC $<"
-	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
 
 do_journal.o: $(top_srcdir)/debugfs/do_journal.c
 	$(E) "	CC $<"
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 8167b76..88e08e7 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -613,7 +613,6 @@ static errcode_t file_test(ext2_filsys fs)
 	errcode_t retval;
 	size_t size;
 	char *buf = 0, *cmpbuf = 0;
-	int i;
 
 	/* create a new file */
 	retval = ext2fs_new_inode(fs, 2, 010755, 0, &newfile);
@@ -793,7 +792,6 @@ int main(int argc, char *argv[])
 	ext2_filsys		fs;
 	struct ext2_super_block param;
 	errcode_t		retval;
-	int			i;
 
 	/* setup */
 	initialize_ext2_error_table();
@@ -823,7 +821,6 @@ int main(int argc, char *argv[])
 
 	/* initialize inode cache */
 	if (!fs->icache) {
-		struct ext2_inode inode;
 		ext2_ino_t first_ino = EXT2_FIRST_INO(fs->super);
 		int i;
 
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 57fe485..8c5db86 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1544,7 +1544,7 @@ static errcode_t progress_callback(ext2_filsys fs,
 static errcode_t migrate_ea_block(ext2_resize_t rfs, ext2_ino_t ino,
 				  struct ext2_inode *inode, int *changed)
 {
-	char *buf;
+	char *buf = NULL;
 	blk64_t new_block;
 	errcode_t err = 0;
 


From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH 1/2] Add support to configure.in to remove all bmap stats from the built tools.
Date: Wed, 27 Jun 2012 20:59:18 +1000
Message-ID: <1340794759-15286-1-git-send-email-tony@bakeyournoodle.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:57580 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab2F0K7s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 06:59:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 configure.in              |   37 +++++++++++++++++++++++++++++++++++++
 lib/config.h.in           |    6 ++++++
 lib/ext2fs/blkmap64_rb.c  |   14 +++++++-------
 lib/ext2fs/bmap64.h       |    6 +++---
 lib/ext2fs/ext2fs.h       |    4 ----
 lib/ext2fs/gen_bitmap64.c |   24 ++++++++++++------------
 6 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/configure.in b/configure.in
index a02234d..eefb0f3 100644
--- a/configure.in
+++ b/configure.in
@@ -763,6 +763,43 @@ AC_MSG_RESULT([Enabling mmp support by default])
 AC_DEFINE(CONFIG_MMP, 1)
 )
 dnl
+dnl handle --disable-bmap-stats
+dnl
+AH_TEMPLATE([ENABLE_BMAP_STATS], [Define to 1 to enable bitmap stats.])
+AC_ARG_ENABLE([bmap-stats],
+[  --disable-bmap-stats   	  disable collection of bitmap stats.],
+if test "$enableval" = "no"
+then
+	AC_MSG_RESULT([Disabling bitmap statistics support])
+else
+	AC_MSG_RESULT([Enabling bitmap statistics support])
+	AC_DEFINE(ENABLE_BMAP_STATS, 1)
+fi
+,
+AC_MSG_RESULT([Enabling bitmap statistics support by default])
+AC_DEFINE(ENABLE_BMAP_STATS, 1)
+)
+dnl
+dnl handle --enable-bmap-stats-ops
+dnl
+AH_TEMPLATE([ENABLE_BMAP_STATS_OPS], [Define to 1 to enable bitmap stats.])
+AC_ARG_ENABLE([bmap-stats-ops],
+[  --enable-bmap-stats-ops   	  enable collection of bitmap stats additional operations.],
+if test "$enableval" = "no"
+then
+	AC_MSG_RESULT([Disabling bitmap statistics operations support])
+else
+	dnl There has to be a better way!
+	AS_IF([test "x${enable_bmap_stats}" = "xno"],
+	 AC_MSG_FAILURE([Error --enable-bmap-stats-ops requires bmap-stats]))
+
+	AC_MSG_RESULT([Enabling bitmap statistics operations support])
+	AC_DEFINE(ENABLE_BMAP_STATS_OPS, 1)
+fi
+,
+AC_MSG_RESULT([Disabling bitmap statistics operations support by default])
+)
+dnl
 dnl
 dnl
 MAKEFILE_LIBRARY=$srcdir/lib/Makefile.library
diff --git a/lib/config.h.in b/lib/config.h.in
index 52c3897..6f88c9c 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -29,6 +29,12 @@
 /* Define to 1 if using `alloca.c'. */
 #undef C_ALLOCA
 
+/* Define to 1 to enable bitmap stats. */
+#undef ENABLE_BMAP_STATS
+
+/* Define to 1 to enable bitmap stats. */
+#undef ENABLE_BMAP_STATS_OPS
+
 /* Define to 1 if ext2 compression enabled */
 #undef ENABLE_COMPRESSION
 
diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index a83f8ac..e6b7e04 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -40,7 +40,7 @@ struct ext2fs_rb_private {
 	struct rb_root root;
 	struct bmap_rb_extent **wcursor;
 	struct bmap_rb_extent **rcursor;
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	__u64 mark_hit;
 	__u64 test_hit;
 #endif
@@ -174,7 +174,7 @@ static errcode_t rb_alloc_private_data (ext2fs_generic_bitmap bitmap)
 	*bp->rcursor = NULL;
 	*bp->wcursor = NULL;
 
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	bp->test_hit = 0;
 	bp->mark_hit = 0;
 #endif
@@ -324,7 +324,7 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 		goto search_tree;
 
 	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count) {
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 		bp->test_hit++;
 #endif
 		return 1;
@@ -368,7 +368,7 @@ static int rb_insert_extent(__u64 start, __u64 count,
 	if (ext) {
 		if (start >= ext->start &&
 		    start <= (ext->start + ext->count)) {
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 			bp->mark_hit++;
 #endif
 			goto got_extent;
@@ -737,7 +737,7 @@ static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
 	*bp->wcursor = NULL;
 }
 
-#ifdef BMAP_STATS
+#ifdef ENABLE_BMAP_STATS
 static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 {
 	struct ext2fs_rb_private *bp;
@@ -748,7 +748,7 @@ static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 	__u64 min_size = ULONG_MAX;
 	__u64 size = 0, avg_size = 0;
 	double eff;
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	__u64 mark_all, test_all;
 	double m_hit = 0.0, t_hit = 0.0;
 #endif
@@ -773,7 +773,7 @@ static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 		min_size = 0;
 	eff = (double)((count * sizeof(struct bmap_rb_extent)) << 3) /
 	      (bitmap->real_end - bitmap->start);
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	mark_all = bitmap->stats.mark_count + bitmap->stats.mark_ext_count;
 	test_all = bitmap->stats.test_count + bitmap->stats.test_ext_count;
 	if (mark_all)
diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
index f44d379..c5384c9 100644
--- a/lib/ext2fs/bmap64.h
+++ b/lib/ext2fs/bmap64.h
@@ -13,7 +13,7 @@ struct ext2_bmap_statistics {
 	int		type;
 	struct timeval	created;
 
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	unsigned long	copy_count;
 	unsigned long	resize_count;
 	unsigned long	mark_count;
@@ -33,7 +33,7 @@ struct ext2_bmap_statistics {
 
 	unsigned long	mark_seq;
 	unsigned long	test_seq;
-#endif /* BMAP_STATS_OPS */
+#endif /* ENABLE_BMAP_STATS_OPS */
 };
 
 
@@ -48,7 +48,7 @@ struct ext2fs_struct_generic_bitmap {
 	char			*description;
 	void			*private;
 	errcode_t		base_error_code;
-#ifdef BMAP_STATS
+#ifdef ENABLE_BMAP_STATS
 	struct ext2_bmap_statistics	stats;
 #endif
 };
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 542b20f..6b9a577 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1161,10 +1161,6 @@ extern errcode_t ext2fs_find_first_zero_generic_bitmap(ext2fs_generic_bitmap bit
 						       __u32 *out);
 
 /* gen_bitmap64.c */
-
-/* Generate and print bitmap usage statistics */
-#define BMAP_STATS
-
 void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap);
 errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 				    int type, __u64 start, __u64 end,
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 07d6d52..44b733d 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -80,7 +80,7 @@ static void warn_bitmap(ext2fs_generic_bitmap bitmap,
 #endif
 }
 
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 #define INC_STAT(map, name) map->stats.name
 #else
 #define INC_STAT(map, name) ;;
@@ -124,7 +124,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	if (retval)
 		return retval;
 
-#ifdef BMAP_STATS
+#ifdef ENABLE_BMAP_STATS
 	if (gettimeofday(&bitmap->stats.created,
 			 (struct timezone *) NULL) == -1) {
 		perror("gettimeofday");
@@ -173,18 +173,18 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	return 0;
 }
 
-#ifdef BMAP_STATS
+#ifdef ENABLE_BMAP_STATS
 void ext2fs_print_bmap_statistics(ext2fs_generic_bitmap bitmap)
 {
 	struct ext2_bmap_statistics *stats = &bitmap->stats;
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	float mark_seq_perc = 0.0, test_seq_perc = 0.0;
 	float mark_back_perc = 0.0, test_back_perc = 0.0;
 #endif
 	double inuse;
 	struct timeval now;
 
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	if (stats->test_count) {
 		test_seq_perc = ((float)stats->test_seq /
 				 stats->test_count) * 100;
@@ -213,7 +213,7 @@ void ext2fs_print_bmap_statistics(ext2fs_generic_bitmap bitmap)
 	fprintf(stderr, "\n[+] %s bitmap (type %d)\n", bitmap->description,
 		stats->type);
 	fprintf(stderr, "=================================================\n");
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	fprintf(stderr, "%16llu bits long\n",
 		bitmap->real_end - bitmap->start);
 	fprintf(stderr, "%16lu copy_bmap\n%16lu resize_bmap\n",
@@ -236,7 +236,7 @@ void ext2fs_print_bmap_statistics(ext2fs_generic_bitmap bitmap)
 	fprintf(stderr, "%16llu bits marked backwards (%.2f%%)\n"
 		"%16.2f seconds in use\n",
 		stats->mark_back, mark_back_perc, inuse);
-#endif /* BMAP_STATS_OPS */
+#endif /* ENABLE_BMAP_STATS_OPS */
 }
 #endif
 
@@ -253,7 +253,7 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
 	if (!EXT2FS_IS_64_BITMAP(bmap))
 		return;
 
-#ifdef BMAP_STATS
+#ifdef ENABLE_BMAP_STATS
 	if (getenv("E2FSPROGS_BITMAP_STATS")) {
 		ext2fs_print_bmap_statistics(bmap);
 		bmap->bitmap_ops->print_stats(bmap);
@@ -293,10 +293,10 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 		return retval;
 
 
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	src->stats.copy_count++;
 #endif
-#ifdef BMAP_STATS
+#ifdef ENABLE_BMAP_STATS
 	if (gettimeofday(&new_bmap->stats.created,
 			 (struct timezone *) NULL) == -1) {
 		perror("gettimeofday");
@@ -442,7 +442,7 @@ int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap bitmap,
 
 	arg >>= bitmap->cluster_bits;
 
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	if (arg == bitmap->stats.last_marked + 1)
 		bitmap->stats.mark_seq++;
 	if (arg < bitmap->stats.last_marked)
@@ -509,7 +509,7 @@ int ext2fs_test_generic_bmap(ext2fs_generic_bitmap bitmap,
 
 	arg >>= bitmap->cluster_bits;
 
-#ifdef BMAP_STATS_OPS
+#ifdef ENABLE_BMAP_STATS_OPS
 	bitmap->stats.test_count++;
 	if (arg == bitmap->stats.last_tested + 1)
 		bitmap->stats.test_seq++;
-- 
1.7.7.6


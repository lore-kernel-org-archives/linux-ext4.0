From: Doug Porter <dsp@fb.com>
Subject: [PATCH] e2fsck: improve performance of region_allocate()
Date: Fri, 18 Aug 2017 18:16:35 -0700
Message-ID: <20170819011635.1815929-1-dsp@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Omar Sandoval <osandov@fb.com>, Doug Porter <dsp@fb.com>
To: Theodore Ts'o <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38265 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753548AbdHUXXS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Aug 2017 19:23:18 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7LNMXrB008739
        for <linux-ext4@vger.kernel.org>; Mon, 21 Aug 2017 16:23:17 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2cg6afghye-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 21 Aug 2017 16:23:17 -0700
Received: from facebook.com (2401:db00:20:c06b:face:0:1f:0)     by
 mx-out.facebook.com (10.103.99.99) with ESMTP  id
 b5976e6c86c711e78f270002c9dfb610-1d98e150 for <linux-ext4@vger.kernel.org>;
        Mon, 21 Aug 2017 16:23:16 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use a red-black tree to track allocations instead of a linked list.
This provides a substantial performance boost when the number of
allocations in a region is large.  This change resulted in a reduction
in runtime from 4821s to 6s on one filesystem.

Signed-off-by: Doug Porter <dsp@fb.com>
---
 e2fsck/Makefile.in |   4 +-
 e2fsck/region.c    | 109 ++++++++++++++++++++++++++++-------------------------
 lib/support/dict.c |   6 ---
 3 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index e43d340..cf60082 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -148,7 +148,7 @@ tst_region: region.c $(DEPLIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_region $(srcdir)/region.c \
 		$(ALL_CFLAGS) $(ALL_LDFLAGS) -DTEST_PROGRAM \
-		$(LIBCOM_ERR) $(SYSLIBS)
+		$(LIBCOM_ERR) $(LIBSUPPORT) $(SYSLIBS)
 
 fullcheck check:: tst_refcount tst_region tst_problem
 	$(TESTENV) ./tst_refcount
@@ -499,7 +499,7 @@ region.o: $(srcdir)/region.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/support/profile.h $(top_builddir)/lib/support/prof_err.h \
  $(top_srcdir)/lib/support/quotaio.h $(top_srcdir)/lib/support/dqblk_v2.h \
- $(top_srcdir)/lib/support/quotaio_tree.h
+ $(top_srcdir)/lib/support/quotaio_tree.h $(top_srcdir)/lib/support/dict.h
 sigcatcher.o: $(srcdir)/sigcatcher.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
diff --git a/e2fsck/region.c b/e2fsck/region.c
index e32f89d..41bdc9f 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -19,19 +19,37 @@
 #undef ENABLE_NLS
 #endif
 #include "e2fsck.h"
+#include "support/dict.h"
 
 struct region_el {
 	region_addr_t	start;
 	region_addr_t	end;
-	struct region_el *next;
 };
 
 struct region_struct {
 	region_addr_t	min;
 	region_addr_t	max;
-	struct region_el *allocated;
+	dict_t dict;
 };
 
+static int region_dict_cmp(const void *a, const void *b)
+{
+	if (*(region_addr_t *)a > *(region_addr_t *)b)
+		return 1;
+	if (*(region_addr_t *)a < *(region_addr_t *)b)
+		return -1;
+	return 0;
+}
+
+static void region_dnode_free(dnode_t *node, void *context)
+{
+	void *data;
+
+	data = dnode_get(node);
+	free(data);
+	free(node);
+}
+
 region_t region_create(region_addr_t min, region_addr_t max)
 {
 	region_t	region;
@@ -42,24 +60,23 @@ region_t region_create(region_addr_t min, region_addr_t max)
 	memset(region, 0, sizeof(struct region_struct));
 	region->min = min;
 	region->max = max;
+
+	dict_init(&region->dict, DICTCOUNT_T_MAX, region_dict_cmp);
+	dict_set_allocator(&region->dict, NULL, region_dnode_free, NULL);
+
 	return region;
 }
 
 void region_free(region_t region)
 {
-	struct region_el	*r, *next;
-
-	for (r = region->allocated; r; r = next) {
-		next = r->next;
-		free(r);
-	}
-	memset(region, 0, sizeof(struct region_struct));
+	dict_free_nodes(&region->dict);
 	free(region);
 }
 
 int region_allocate(region_t region, region_addr_t start, int n)
 {
-	struct region_el	*r, *new_region, *prev, *next;
+	struct dnode_t *lower_node = NULL, *upper_node = NULL;
+	struct region_el *new_region, *lower = NULL, *upper = NULL;
 	region_addr_t end;
 
 	end = start+n;
@@ -68,52 +85,38 @@ int region_allocate(region_t region, region_addr_t start, int n)
 	if (n == 0)
 		return 1;
 
-	/*
-	 * Search through the linked list.  If we find that it
-	 * conflicts witih something that's already allocated, return
-	 * 1; if we can find an existing region which we can grow, do
-	 * so.  Otherwise, stop when we find the appropriate place
-	 * insert a new region element into the linked list.
-	 */
-	for (r = region->allocated, prev=NULL; r; prev = r, r = r->next) {
-		if (((start >= r->start) && (start < r->end)) ||
-		    ((end > r->start) && (end <= r->end)) ||
-		    ((start <= r->start) && (end >= r->end)))
+	/* Return 1 if we conflict with something that's already allocated. */
+	lower_node = dict_upper_bound(&region->dict, &start);
+	if (lower_node) {
+		lower = dnode_get(lower_node);
+		if (start < lower->end)
 			return 1;
-		if (end == r->start) {
-			r->start = start;
-			return 0;
-		}
-		if (start == r->end) {
-			if ((next = r->next)) {
-				if (end > next->start)
-					return 1;
-				if (end == next->start) {
-					r->end = next->end;
-					r->next = next->next;
-					free(next);
-					return 0;
-				}
-			}
-			r->end = end;
-			return 0;
-		}
-		if (start < r->start)
-			break;
 	}
-	/*
-	 * Insert a new region element structure into the linked list
-	 */
+	upper_node = dict_lower_bound(&region->dict, &start);
+	if (upper_node) {
+		upper = dnode_get(upper_node);
+		if (end > upper->start)
+			return 1;
+	}
+
+	/* Consolidate continguous allocations. */
+	if (lower && start == lower->end) {
+		start = lower->start;
+		dict_delete_free(&region->dict, lower_node);
+	}
+	if (upper && end == upper->start) {
+		end = upper->end;
+		dict_delete_free(&region->dict, upper_node);
+	}
+
+	/* Add new allocation. */
 	new_region = malloc(sizeof(struct region_el));
 	if (!new_region)
 		return -1;
 	new_region->start = start;
-	new_region->end = start + n;
-	new_region->next = r;
-	if (prev)
-		prev->next = new_region;
-	else
-		region->allocated = new_region;
+	new_region->end = end;
+	if (!dict_alloc_insert(&region->dict, &new_region->start, new_region))
+		return -1;
 	return 0;
 }
 
@@ -156,15 +159,19 @@ int bcode_program[] = {
 
 void region_print(region_t region, FILE *f)
 {
+	dnode_t *node = NULL;
 	struct region_el	*r;
 	int	i = 0;
 
 	fprintf(f, "Printing region (min=%llu. max=%llu)\n\t", region->min,
 		region->max);
-	for (r = region->allocated; r; r = r->next) {
+	node = dict_first(&region->dict);
+	while (node) {
+		r = dnode_get(node);
 		fprintf(f, "(%llu, %llu)  ", r->start, r->end);
 		if (++i >= 8)
 			fprintf(f, "\n\t");
+		node = dict_next(&region->dict, node);
 	}
 	fprintf(f, "\n");
 }
diff --git a/lib/support/dict.c b/lib/support/dict.c
index 6a5c15c..e3b2972 100644
--- a/lib/support/dict.c
+++ b/lib/support/dict.c
@@ -490,7 +490,6 @@ dnode_t *dict_lookup(dict_t *dict, const void *key)
     return NULL;
 }
 
-#ifdef E2FSCK_NOTUSED
 /*
  * Look for the node corresponding to the lowest key that is equal to or
  * greater than the given key.  If there is no such node, return null.
@@ -554,7 +553,6 @@ dnode_t *dict_upper_bound(dict_t *dict, const void *key)
 
     return tentative;
 }
-#endif
 
 /*
  * Insert a node into the dictionary. The node should have been
@@ -655,7 +653,6 @@ void dict_insert(dict_t *dict, dnode_t *node, const void *key)
     dict_assert (dict_verify(dict));
 }
 
-#ifdef E2FSCK_NOTUSED
 /*
  * Delete the given node from the dictionary. If the given node does not belong
  * to the given dictionary, undefined behavior results.  A pointer to the
@@ -830,7 +827,6 @@ dnode_t *dict_delete(dict_t *dict, dnode_t *delete)
 
     return delete;
 }
-#endif /* E2FSCK_NOTUSED */
 
 /*
  * Allocate a node using the dictionary's allocator routine, give it
@@ -849,13 +845,11 @@ int dict_alloc_insert(dict_t *dict, const void *key, void *data)
     return 0;
 }
 
-#ifdef E2FSCK_NOTUSED
 void dict_delete_free(dict_t *dict, dnode_t *node)
 {
     dict_delete(dict, node);
     dict->freenode(node, dict->context);
 }
-#endif
 
 /*
  * Return the node with the lowest (leftmost) key. If the dictionary is empty
-- 
2.9.5

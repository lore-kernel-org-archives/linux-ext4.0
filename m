Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDD83ACEF6
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784029501; cv=none; b=OU33c9/5D3uENnQ+nh/GyV1rGZaUHr0vI7KICHujgATEx4y8tC31FD1CHK4q9Q6xBl8RWdB1q7sKFU03m7dCSIq3hbPqsbOmPTdpImJQRgHYiqX1W5BXp80mxYQmi5jmqds1cOckNKZiUce25L2J30inS6OymoI4JBiUB1umiw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784029501; c=relaxed/simple;
	bh=Yc78T3e2BwPzhLKb/41gUwXGY5wSetIrw1YYaVD/V8o=;
	h=Content-Type:Date:In-Reply-To:Mime-Version:To:Subject:References:
	 Message-Id:Cc:From; b=jLreUvbzZFXTuF67gpJQQl7x0DiPmmd62LsUqjfgv+8aixXF95Log9sIOKSz16xfbrSh1hP4tM2VvJ4rHLKijG59SngB833ZPCw1npOTfpU72P3Hc15dw7rqoKYVnGLKbmcs7LP8qJqUszHMZjxC0M2Cq7IIyh+mt0ZoUZl0PZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JcFjPbay; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JcFjPbay"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784029491; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=tXz2HYl/3QgEVWwn4SMcBPLLl+Ber+CJ2FwRENzpf8c=;
 b=JcFjPbayPOLHYh2X95TkMa59+c9/zOVsWWr/EQNNBM3C5IoNB4AgRVSkswAP+G8KVlsDZv
 uIeLFV6oiE3ytWYPuiJHIZ09Y9DSoseVX4J/Cp2g57Xmhnm4JXvsgE0HHI2zWFa/l46Jm2
 DNcfLV8ALqgmyrqyczOkUUFCBA6kwyCTGLmc/zouvVs87dI69vgsN96RVaV9bcifqaEhrW
 hlYUgbwVuBLu9JUIK9K6STU6pnHcr7zIaV/HgwaYw6rR0nv0VrjQp/Wvmq6BeIcxlZIxTw
 14kcfAgF4VQ4D27U6H8MVSSaBsXjFsMcD2WCnOt+V7R/0B+8jczjjk4QMrkpEg==
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 19:43:57 +0800
In-Reply-To: <20260714114358.93335-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 7bit
To: <tytso@mit.edu>
Subject: [RFC PATCH 1/2] ext4: avoid caching an extent twice after a leaf read
References: <20260714114358.93335-1-changfengnan@bytedance.com>
Message-Id: <20260714114358.93335-2-changfengnan@bytedance.com>
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a562131+eed41c+vger.kernel.org+changfengnan@bytedance.com>
Cc: <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>, 
	"Fengnan Chang" <changfengnan@bytedance.com>
From: "Fengnan Chang" <changfengnan@bytedance.com>

When ext4_find_extent() reads and verifies an extent leaf,
ext4_cache_extents() adds all extents in that leaf to the extent status tree.
ext4_map_query_blocks() then caches the extent returned by the lookup once
more. That second cache operation takes i_es_lock for writing and repeats the
extent status lookup.

Make ext4_es_cache_extent() report whether the requested range is cached when
it returns, and pass that result through the extent path and map flags. If the
leaf population completed, skip the later query cache. If population was
skipped or an insertion failed, keep the existing cache operation as a
fallback so the query path can still fill the missing range.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/ext4/ext4.h           |  4 ++++
 fs/ext4/ext4_extents.h   |  4 +++-
 fs/ext4/extents.c        | 35 +++++++++++++++++++++++++++--------
 fs/ext4/extents_status.c | 20 ++++++++++++++------
 fs/ext4/extents_status.h |  6 +++---
 fs/ext4/inode.c          | 34 +++++++++++++++++++++++-----------
 6 files changed, 74 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab3..52c75fd44344a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -250,6 +250,8 @@ struct ext4_allocation_request {
  * - We use the next available bit after BH_BITMAP_UPTODATE.
  */
 #define EXT4_MAP_QUERY_LAST_IN_LEAF	BIT(BH_BITMAP_UPTODATE + 1)
+/* Internal flag reporting that the queried extent is already in the ES tree. */
+#define EXT4_MAP_ES_CACHED		BIT(BH_BITMAP_UPTODATE + 2)
 #define EXT4_MAP_FLAGS		(EXT4_MAP_NEW | EXT4_MAP_MAPPED |\
 				 EXT4_MAP_UNWRITTEN | EXT4_MAP_BOUNDARY |\
 				 EXT4_MAP_DELAYED | EXT4_MAP_QUERY_LAST_IN_LEAF)
@@ -736,6 +738,8 @@ enum {
  * Look EXT4_MAP_QUERY_LAST_IN_LEAF.
  */
 #define EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF	0x1000
+	/* Report successful extent status cache population to the query path. */
+#define EXT4_GET_BLOCKS_TRACK_ES_CACHE		0x2000
 
 /*
  * The bit position of these flags must not overlap with any of the
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index ebaf7cc42430f..532b76c318331 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -106,12 +106,15 @@ struct ext4_ext_path {
 	ext4_fsblk_t			p_block;
 	__u16				p_depth;
 	__u16				p_maxdepth;
+	__u16				p_flags;
 	struct ext4_extent		*p_ext;
 	struct ext4_extent_idx		*p_idx;
 	struct ext4_extent_header	*p_hdr;
 	struct buffer_head		*p_bh;
 };
 
+#define EXT4_EX_PATH_ES_CACHED		0x0001
+
 /*
  * Used to record a portion of a cluster found at the beginning or end
  * of an extent while traversing the extent tree during space removal.
@@ -277,4 +280,3 @@ extern struct ext4_ext_path *ext4_split_convert_extents_test(
 				int flags, unsigned int *allocated);
 #endif
 #endif /* _EXT4_EXTENTS */
-
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b317..a86beaaf63727 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -521,11 +521,12 @@ int ext4_ext_check_inode(struct inode *inode)
 	return ext4_ext_check(inode, ext_inode_hdr(inode), ext_depth(inode), 0);
 }
 
-static void ext4_cache_extents(struct inode *inode,
+static bool ext4_cache_extents(struct inode *inode,
 			       struct ext4_extent_header *eh)
 {
 	struct ext4_extent *ex = EXT_FIRST_EXTENT(eh);
 	ext4_lblk_t prev = 0;
+	bool cached = true;
 	int i;
 
 	KUNIT_STATIC_STUB_REDIRECT(ext4_cache_extents, inode, eh);
@@ -541,22 +542,27 @@ static void ext4_cache_extents(struct inode *inode,
 
 		if (ext4_ext_is_unwritten(ex))
 			status = EXTENT_STATUS_UNWRITTEN;
-		ext4_es_cache_extent(inode, lblk, len,
-				     ext4_ext_pblock(ex), status);
+		cached &= ext4_es_cache_extent(inode, lblk, len,
+					  ext4_ext_pblock(ex), status);
 		prev = lblk + len;
 	}
+
+	return cached;
 }
 
 static struct buffer_head *
 __read_extent_tree_block(const char *function, unsigned int line,
 			 struct inode *inode, struct ext4_extent_idx *idx,
-			 int depth, int flags)
+			 int depth, int flags, bool *es_cached)
 {
 	struct buffer_head		*bh;
 	int				err;
 	gfp_t				gfp_flags = __GFP_MOVABLE | GFP_NOFS;
 	ext4_fsblk_t			pblk;
 
+	if (es_cached)
+		*es_cached = false;
+
 	if (flags & EXT4_EX_NOFAIL)
 		gfp_flags |= __GFP_NOFAIL;
 
@@ -583,7 +589,11 @@ __read_extent_tree_block(const char *function, unsigned int line,
 	 */
 	if (!(flags & EXT4_EX_NOCACHE) && depth == 0) {
 		struct ext4_extent_header *eh = ext_block_hdr(bh);
-		ext4_cache_extents(inode, eh);
+
+		if (es_cached)
+			*es_cached = ext4_cache_extents(inode, eh);
+		else
+			ext4_cache_extents(inode, eh);
 	}
 	return bh;
 errout:
@@ -594,7 +604,10 @@ __read_extent_tree_block(const char *function, unsigned int line,
 
 #define read_extent_tree_block(inode, idx, depth, flags)		\
 	__read_extent_tree_block(__func__, __LINE__, (inode), (idx),	\
-				 (depth), (flags))
+				 (depth), (flags), NULL)
+#define read_extent_tree_block_cached(inode, idx, depth, flags, cached) \
+	__read_extent_tree_block(__func__, __LINE__, (inode), (idx),	\
+				 (depth), (flags), (cached))
 
 /*
  * This function is called to cache a file's extent information in the
@@ -888,6 +901,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 {
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
+	bool es_cached = false;
 	short int depth, i, ppos = 0;
 	int ret;
 	gfp_t gfp_flags = GFP_NOFS;
@@ -925,7 +939,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 
 	i = depth;
 	if (!(flags & EXT4_EX_NOCACHE) && depth == 0)
-		ext4_cache_extents(inode, eh);
+		es_cached = ext4_cache_extents(inode, eh);
 	/* walk through the tree */
 	while (i) {
 		ext_debug(inode, "depth %d: num %d, max %d\n",
@@ -936,7 +950,8 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_depth = i;
 		path[ppos].p_ext = NULL;
 
-		bh = read_extent_tree_block(inode, path[ppos].p_idx, --i, flags);
+		bh = read_extent_tree_block_cached(inode, path[ppos].p_idx,
+						   --i, flags, &es_cached);
 		if (IS_ERR(bh)) {
 			ret = PTR_ERR(bh);
 			goto err;
@@ -949,6 +964,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 	}
 
 	path[ppos].p_depth = i;
+	path[ppos].p_flags = es_cached ? EXT4_EX_PATH_ES_CACHED : 0;
 	path[ppos].p_ext = NULL;
 	path[ppos].p_idx = NULL;
 
@@ -4322,6 +4338,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 		/* if found extent covers block, simply return it */
 		if (in_range(map->m_lblk, ee_block, ee_len)) {
+			if ((flags & EXT4_GET_BLOCKS_TRACK_ES_CACHE) &&
+			    (path[depth].p_flags & EXT4_EX_PATH_ES_CACHED))
+				map->m_flags |= EXT4_MAP_ES_CACHED;
 			newblock = map->m_lblk - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (map->m_lblk - ee_block);
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e82191..bcc872dd7fc8d 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1020,26 +1020,29 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
  * information and cannot be used to convert existing extents in the extent
  * status tree. To convert existing extents, use ext4_es_insert_extent()
  * instead.
+ *
+ * Return true if the requested range is present in the cache on return.
  */
-void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
+bool ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 			  ext4_lblk_t len, ext4_fsblk_t pblk,
 			  unsigned int status)
 {
 	struct extent_status *es;
 	struct extent_status chkes, newes;
 	ext4_lblk_t end = lblk + len - 1;
+	bool cached = false;
 	bool conflict = false;
 	int err;
 
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
-		return;
+		return false;
 
 	newes.es_lblk = lblk;
 	newes.es_len = len;
 	ext4_es_store_pblock_status(&newes, pblk, status);
 
 	if (!len)
-		return;
+		return false;
 
 	BUG_ON(end < lblk);
 
@@ -1050,6 +1053,8 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 		if (es->es_lblk <= lblk && es->es_lblk + es->es_len > end) {
 			if (__es_check_extent_status(es, status, &chkes))
 				conflict = true;
+			else
+				cached = true;
 			goto unlock;
 		}
 		/* Check and remove all extents in range. */
@@ -1061,25 +1066,28 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 			goto unlock;
 		}
 	}
-	__es_insert_extent(inode, &newes, NULL);
+	err = __es_insert_extent(inode, &newes, NULL);
+	if (!err)
+		cached = true;
 	trace_ext4_es_cache_extent(inode, &newes);
 	ext4_es_print_tree(inode);
 unlock:
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 	if (!conflict)
-		return;
+		return cached;
 	/*
 	 * A hole in the on-disk extent but a delayed extent in the extent
 	 * status tree, is allowed.
 	 */
 	if (status == EXTENT_STATUS_HOLE &&
 	    ext4_es_type(&chkes) == EXTENT_STATUS_DELAYED)
-		return;
+		return false;
 
 	ext4_warning_inode(inode,
 			   "ES cache extent failed: add [%d,%d,%llu,0x%x] conflict with existing [%d,%d,%llu,0x%x]\n",
 			   lblk, len, pblk, status, chkes.es_lblk, chkes.es_len,
 			   ext4_es_pblock(&chkes), ext4_es_status(&chkes));
+	return false;
 }
 
 /*
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f3396cf32b446..322a442a4eb03 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -137,9 +137,9 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 				  ext4_lblk_t len, ext4_fsblk_t pblk,
 				  unsigned int status,
 				  bool delalloc_reserve_used);
-extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
-				 ext4_lblk_t len, ext4_fsblk_t pblk,
-				 unsigned int status);
+bool ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
+			  ext4_lblk_t len, ext4_fsblk_t pblk,
+			  unsigned int status);
 extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 				  ext4_lblk_t len);
 extern void ext4_es_find_extent_range(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b2..c222b0232d586 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -507,6 +507,8 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
 {
 	struct ext4_map_blocks map2;
 	unsigned int status, status2;
+	bool es_cached = map->m_flags & EXT4_MAP_ES_CACHED;
+	bool es2_cached;
 	int retval;
 
 	status = map->m_flags & EXT4_MAP_UNWRITTEN ?
@@ -519,11 +521,14 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
 	map2.m_lblk = map->m_lblk + map->m_len;
 	map2.m_len = orig_mlen - map->m_len;
 	map2.m_flags = 0;
-	retval = ext4_ext_map_blocks(handle, inode, &map2, 0);
+	retval = ext4_ext_map_blocks(handle, inode, &map2,
+				     EXT4_GET_BLOCKS_TRACK_ES_CACHE);
+	es2_cached = map2.m_flags & EXT4_MAP_ES_CACHED;
 
 	if (retval <= 0) {
-		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
-				     map->m_pblk, status);
+		if (!es_cached)
+			ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
+					     map->m_pblk, status);
 		return map->m_len;
 	}
 
@@ -544,11 +549,12 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
 	 */
 	if (map->m_pblk + map->m_len == map2.m_pblk &&
 			status == status2) {
-		ext4_es_cache_extent(inode, map->m_lblk,
-				     map->m_len + map2.m_len, map->m_pblk,
-				     status);
+		if (!es_cached || !es2_cached)
+			ext4_es_cache_extent(inode, map->m_lblk,
+					     map->m_len + map2.m_len,
+					     map->m_pblk, status);
 		map->m_len += map2.m_len;
-	} else {
+	} else if (!es_cached) {
 		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
 				     map->m_pblk, status);
 	}
@@ -563,13 +569,17 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 	int retval;
 	unsigned int orig_mlen = map->m_len;
 
+	map->m_flags &= ~EXT4_MAP_ES_CACHED;
 	flags &= EXT4_EX_QUERY_FILTER;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		retval = ext4_ext_map_blocks(handle, inode, map, flags);
+		retval = ext4_ext_map_blocks(handle, inode, map,
+					     flags | EXT4_GET_BLOCKS_TRACK_ES_CACHE);
 	else
 		retval = ext4_ind_map_blocks(handle, inode, map, flags);
-	if (retval < 0)
+	if (retval < 0) {
+		map->m_flags &= ~EXT4_MAP_ES_CACHED;
 		return retval;
+	}
 
 	/* A hole? */
 	if (retval == 0)
@@ -592,13 +602,15 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 			map->m_len == orig_mlen) {
 		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
-		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
-				     map->m_pblk, status);
+		if (!(map->m_flags & EXT4_MAP_ES_CACHED))
+			ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
+					     map->m_pblk, status);
 	} else {
 		retval = ext4_map_query_blocks_next_in_leaf(handle, inode, map,
 							    orig_mlen);
 	}
 out:
+	map->m_flags &= ~EXT4_MAP_ES_CACHED;
 	map->m_seq = READ_ONCE(EXT4_I(inode)->i_es_seq);
 	return retval;
 }
-- 
2.39.5 (Apple Git-154)

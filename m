Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2993033FE33
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727443; cv=none; b=agfXoKf2AF4eq70ZCvUsRHP5FyX/a9bUkHgpFxYx3AUkUZXt4zsJ8pO1BxRjwiGyC3VYl/JYf0g44AygfMWNg8DkjETJsQZ693MMGIJA/Ze5cFYOb2jcVPvxQdHm9BzQr5gfx2Ukjtvvu/CkBhWJpn9uQO1BOI/IjTdr2+a9zwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727443; c=relaxed/simple;
	bh=aSTlS8tX4wDDPXfi+JDHygze8Fssc2kuCLdjVRVy3PU=;
	h=Cc:Subject:Date:Message-Id:Mime-Version:Content-Type:To:From; b=Q4CGW5o7TZy6WV76uqiOMrUDevy9GVmnaBLVAPutv2he76D7t1VXiH2rmHxB4Jp7K9t6P4bU86h5kqyvSW86/TxYrkQY1N5kKwqMB3j1eeG6G1MTtyxLtJP72pMfY7DD5HFv7oj9u5YjlLa6xx91O+3N5j0Fo01Nyv7Ksn9M0C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Bqd+TeZs; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Bqd+TeZs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784727435; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=56oyMktccrj3J8dxr7fVznXW3jhJhW+5pfZ4htFA/7g=;
 b=Bqd+TeZsraT0EAXZkbshO9amwyjSLUVC4AN4Z6jt65m2Xy08hDcO6ENjzZ5II36KdozgU9
 oiJLaaO9Ug9mccno5nNE5fIEAyff5sedTwVDYVpkN0VITNynPzVwKuYQzd2CSVx7y1l0jR
 hPM5SApGiMi0Bn326t0wluME8cEPYXWSfhVrckfnRxfgq2m5ZNehS03WGQEipcKBJ95tyw
 T9R7eqKOFwkUMdnJP7OWNNQ1jSboTIM4Y7mHYFRE/cBGixfS2P+6/uCPs4Liyf8Brra29p
 ks8VQFNBysd4BKXOoi6eE5pEHdYIoqzKuKvMq1BKipLKO4foL0T4u1KT45OlUA==
Cc: <linux-ext4@vger.kernel.org>, 
	"Fengnan Chang" <changfengnan@bytedance.com>
Subject: [PATCH v2] ext4: cache full extents during mapping lookup
Date: Wed, 22 Jul 2026 21:36:55 +0800
Message-Id: <20260722133655.70112-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
From: "Fengnan Chang" <changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a60c789+bd0f2a+vger.kernel.org+changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)

The extent status (ES) tree and extent tree leaf buffers are reclaimed
independently. An ES entry can be reclaimed while the leaf buffer remains
cached with BH_Verified set.

When this happens, ext4_es_lookup_extent() misses.  Since the leaf buffer
is already verified, __read_extent_tree_block() returns it without calling
ext4_cache_extents(). ext4_ext_map_blocks() returns the part of the extent
covered by the request, and ext4_map_query_blocks() caches only that range.
Reads to other blocks in the same extent then keep missing the ES tree and
walking the extent tree.

Cache the full extent in ext4_ext_map_blocks() before the returned mapping
is limited to the requested range. Add an optional read-side lookup to
ext4_es_cache_extent().

Do not do this when ext4_ext_map_blocks() is called with
EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE. NOCACHE paths can change extent
mappings, so caching ranges outside the request can leave stale ES entries.
Cache both written and unwritten extents, as ext4_cache_extents() does.

Tested with fio 4K random direct reads using libaio at iodepth 128 on a
128 GiB file with 208 on-disk extents. The results are averages of three
10-second runs:

                 before reclaim    after reclaim
  unpatched        419.6k IOPS       274.6k IOPS
  patched          426.1k IOPS       423.7k IOPS

Average completion latency went from 303.02 to 462.78 us without the patch,
and from 298.36 to 300.07 us with the patch.

No latency regression was seen in A/B test.

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/ext4/extents.c        | 17 +++++++++++++----
 fs/ext4/extents_status.c | 17 ++++++++++++++++-
 fs/ext4/extents_status.h |  2 +-
 fs/ext4/inode.c          | 10 ++++++----
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b317..85e213761a18d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -537,12 +537,12 @@ static void ext4_cache_extents(struct inode *inode,
 
 		if (prev && (prev != lblk))
 			ext4_es_cache_extent(inode, prev, lblk - prev, ~0,
-					     EXTENT_STATUS_HOLE);
+					     EXTENT_STATUS_HOLE, false);
 
 		if (ext4_ext_is_unwritten(ex))
 			status = EXTENT_STATUS_UNWRITTEN;
 		ext4_es_cache_extent(inode, lblk, len,
-				     ext4_ext_pblock(ex), status);
+				     ext4_ext_pblock(ex), status, false);
 		prev = lblk + len;
 	}
 }
@@ -4239,7 +4239,8 @@ static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
 insert_hole:
 	/* Put just found gap into cache to speed up subsequent requests */
 	ext_debug(inode, " -> %u:%u\n", hole_start, len);
-	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE);
+	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE,
+			     false);
 
 	/* Update hole_len to reflect hole size after lblk */
 	if (hole_start != lblk)
@@ -4310,13 +4311,15 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
 		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
 		unsigned short ee_len;
-
+		unsigned int status;
 
 		/*
 		 * unwritten extents are treated as holes, except that
 		 * we split out initialized portions during a write.
 		 */
 		ee_len = ext4_ext_get_actual_len(ex);
+		status = ext4_ext_is_unwritten(ex) ?
+			 EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 
 		trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
 
@@ -4328,6 +4331,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			ext_debug(inode, "%u fit into %u:%d -> %llu\n",
 				  map->m_lblk, ee_block, ee_len, newblock);
 
+			if (!(flags & (EXT4_GET_BLOCKS_CREATE |
+				       EXT4_EX_NOCACHE)))
+				ext4_es_cache_extent(inode, ee_block, ee_len,
+						     ee_start, status,
+						     true);
+
 			/*
 			 * If the extent is initialized check whether the
 			 * caller wants to convert it to unwritten.
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e82191..5a03878b06160 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1023,7 +1023,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
  */
 void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 			  ext4_lblk_t len, ext4_fsblk_t pblk,
-			  unsigned int status)
+			  unsigned int status, bool pre_search)
 {
 	struct extent_status *es;
 	struct extent_status chkes, newes;
@@ -1043,6 +1043,21 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	BUG_ON(end < lblk);
 
+	/*
+	 * Avoid taking i_es_lock for writing if the entire extent is already
+	 * cached. The write-locked search below rechecks after a miss.
+	 */
+	if (pre_search) {
+		read_lock(&EXT4_I(inode)->i_es_lock);
+		es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
+		if (es && es->es_lblk <= lblk && ext4_es_end(es) >= end &&
+		    !__es_check_extent_status(es, status, NULL)) {
+			read_unlock(&EXT4_I(inode)->i_es_lock);
+			return;
+		}
+		read_unlock(&EXT4_I(inode)->i_es_lock);
+	}
+
 	write_lock(&EXT4_I(inode)->i_es_lock);
 	es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
 	if (es && es->es_lblk <= end) {
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f3396cf32b446..c2da72e3c82ba 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -139,7 +139,7 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 				  bool delalloc_reserve_used);
 extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len, ext4_fsblk_t pblk,
-				 unsigned int status);
+				 unsigned int status, bool pre_search);
 extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 				  ext4_lblk_t len);
 extern void ext4_es_find_extent_range(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b2..341b7c649e133 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -523,7 +523,7 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
 
 	if (retval <= 0) {
 		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
-				     map->m_pblk, status);
+				     map->m_pblk, status, true);
 		return map->m_len;
 	}
 
@@ -546,11 +546,11 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
 			status == status2) {
 		ext4_es_cache_extent(inode, map->m_lblk,
 				     map->m_len + map2.m_len, map->m_pblk,
-				     status);
+				     status, true);
 		map->m_len += map2.m_len;
 	} else {
 		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
-				     map->m_pblk, status);
+				     map->m_pblk, status, true);
 	}
 
 	return map->m_len;
@@ -562,6 +562,8 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 	unsigned int status;
 	int retval;
 	unsigned int orig_mlen = map->m_len;
+	bool pre_search = ext4_test_inode_flag(inode,
+					      EXT4_INODE_EXTENTS);
 
 	flags &= EXT4_EX_QUERY_FILTER;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
@@ -593,7 +595,7 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
-				     map->m_pblk, status);
+				     map->m_pblk, status, pre_search);
 	} else {
 		retval = ext4_map_query_blocks_next_in_leaf(handle, inode, map,
 							    orig_mlen);
-- 
2.39.5 (Apple Git-154)

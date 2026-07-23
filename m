Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34D447127D
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 12:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784810635; cv=none; b=LJSKGpKeH1UIj4wyRJeNIYiCEI+cihLLahc7EBnXinwoCYQaEOw3tMEwejf+r4ayDOu41qE5CVKu9jYksAsjSYMew3j9UGPQ+fZvmZ9ZTvTPCXCaO4U8XBwFcP0MXWLEmWANDUXHt8jQC51tIQo34kv5XtNilVHrHroy/GH06aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784810635; c=relaxed/simple;
	bh=MKeX5XbEsAi/kAQBpYqasPuI0cyFdtXoxN5CBBnG2NU=;
	h=Cc:From:Date:Mime-Version:Subject:Content-Type:To:Message-Id; b=EFTGhKaf37EhYIJ7eiWmcXLtWN2e1fbVOb6O6BiqY33/s7Rckpe6HITf+k3/jU9GDoM7IP06d1QjNeMNVPtirsY6k3OSKXwM32HmjvUlBgYZoRWaWt+PTU4oYtlNufRhdMoDlOH8DSImJO0a9kzb9CYUxT95jAgxwnMIObP2u1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=J9w+S5f8; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="J9w+S5f8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784810627; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Cdnky1EI87SG6rNu+eVT/BjY3n5d926agYo17Bx0pMQ=;
 b=J9w+S5f8RalbPhwImZQhVyZKb2CkXQsvbTOTiNmP+J9D3vl+FlbmUtwP0MNsHkB0H7vDpP
 jw5bca9NIVGgcGNj1Nq1e0TZk3eTZXK2i+XM71CVVJADR/T+6BifPwXXNoATTNYEEG5Hsi
 tkzrZqCavJmSEShMmIrM+A7aoGSPxCCMWgtmZ5g5owxeCvaiD0cjdaLmWKXK5M7UtlU4Rv
 YJW5mSc21LEERTwgFg/SBJ0GpuqAO7U49Ckqqq7J1/gn7nsx4nTGI7TKpTfAWxc5hGkbql
 aX5NNLXg348IwmBbWyy5u//RTYXFfr+EQ9MWNUhR/9Ghp//6aByEPafSLr/Irg==
Cc: <linux-ext4@vger.kernel.org>, 
	"Fengnan Chang" <changfengnan@bytedance.com>
From: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Thu, 23 Jul 2026 20:43:26 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v3] ext4: cache full extents during mapping lookup
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a620c81+17b5a4+vger.kernel.org+changfengnan@bytedance.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>
Message-Id: <20260723124326.82446-1-changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/ext4/extents.c        | 17 +++++++++++++----
 fs/ext4/extents_status.c | 17 ++++++++++++++++-
 fs/ext4/extents_status.h |  2 +-
 fs/ext4/inode.c          | 15 +++++++++++----
 4 files changed, 41 insertions(+), 10 deletions(-)

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
index ce99807c5f5b2..d43266c489785 100644
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
@@ -562,6 +562,13 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 	unsigned int status;
 	int retval;
 	unsigned int orig_mlen = map->m_len;
+	/*
+	 * ext4_ext_map_blocks() may have already cached the full extent, so
+	 * search first to avoid taking i_es_lock for writing. The indirect
+	 * path does not prepopulate the ES tree after the initial lookup miss.
+	 */
+	bool pre_search = ext4_test_inode_flag(inode,
+					      EXT4_INODE_EXTENTS);
 
 	flags &= EXT4_EX_QUERY_FILTER;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
@@ -593,7 +600,7 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
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

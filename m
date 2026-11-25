Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611116;
	b=QZdf8wgUa2/Zk7rtLa2FMSM36QJ95hDUHfjJo2JSl26pwtRJ5UtxqEA0DHHXtbQQMSLE
	 AzLEl9W35ffNGWoAzOtg5cxd3YTko2LKumqQOubTTY5nMEcmYAs8+d+gGj7xfel2iSN0s
	 bAV7vMWTzmelIe187u0vzgcCmG3l8DWqhFSKOQsOkCZj7mB2GW5DULo2Wif/2AzETOqHI
	 iiJmzBrHifxOd8h/+ANOsR/xi0gNgdn5Dp7BOXoVHTiDZP8D5Wb3XpWMse9mcBLRiTN7s
	 GLHHrJgZQmv5CYrmyJboRym4p/poQ41/hE5lEOwS0ktHkx57N9SWrgdcqCDKahYXZbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611116;
	h=DMARC-Filter:DKIM-Signature:Subject:To:X-Mailer:From:Message-Id:
	 Mime-Version:Date:X-Original-From:Content-Transfer-Encoding:
	 X-Lms-Return-Path:Content-Type:Cc;
	bh=kgTMqeUBtK3Hcq1XbW1lEgyYysu92JnsMrmKz1xVOCQ=;
	b=OmfBVeebOqgga4tknBotERb/FZuEtS5/1ub+A2cOViqEar3MgaUYZpbowM7NpJGo1TLM
	 89qQNZ0xHgZWS+dJEkQC2o/PnDNADk+tMYNMOZix3qKqQB94U+7ljhjfGfCPW4VHbeEbo
	 Zvcm4y2UjP69/bp5S5hCKruD9EQTCn6Gpzu8/tWANIkyew12us10xp8QPHr3kKgjpOjzs
	 6Cboarq5IQNbiDQ0o7AsWWNMH67dH8oyzG7u+hefMuhO/sQ/unewSenpOzM51Zy1JHa/0
	 s+ivXKwOO5fPQ3Mrz6WuMIo2fceo4ZqVmxh3r0p4qRVuJ38YwRRxBAcd7TD7e1tSXIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=FOmIl+OW;
	arc=none smtp.remote-ip=209.127.231.113
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FE3606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 12:51:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1FE3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=FOmIl+OW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795611110; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=kgTMqeUBtK3Hcq1XbW1lEgyYysu92JnsMrmKz1xVOCQ=;
 b=FOmIl+OWtmFQAddEkkehBAA+fQd8V5jt0fjcXS6mjKongIxJz/G55uhO7IKAFfBeA0u+Il
 SdrDoCp3SydDwEazsUQ125KNVCBMbyysSZoaikfTcxQQo6aSir+0dbLmbRtmHEdvdUtH47
 xKjwsXW7+Xk92BfNLI7DNmc66NcSBdWzqX+iQ0XLsaUNshRRB4Ic2TewalQzXrHo3UOl5T
 C1QiS2b8uzVySP/H40Xqsi/DHIx93GMln4z+bBnXFP/50gpMDyVXSZqKO/oyvc1ehT8ywa
 7VApYKFJgv/CPpVx0MoweN+WXrIWQy2bpGlFS1e2od8n8pYtvDpNhMkDNi0w3w==
Subject: [PATCH v4] ext4: cache full extents during mapping lookup
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>
X-Mailer: git-send-email 2.39.5
From: "Fengnan Chang" <changfengnan@bytedance.com>
Message-Id: <20261125125101.528146-1-changfengnan@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Date: Wed, 25 Nov 2026 12:51:01 +0000
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26b06d9e4+ef1e91+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: "Fengnan Chang" <changfengnan@bytedance.com>, 
	<linux-ext4@vger.kernel.org>

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
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
Changes since v3:
- Rebase onto latest ext4/dev (bae28a1b11f4).
- Update ext4_es_cache_extent() caller in fs/ext4/extents_status-test.c.
- Collect Reviewed-by tag from Jan Kara.

v3: https://lore.kernel.org/r/20260723124326.82446-1-changfengnan@bytedance.com

 fs/ext4/extents.c             | 17 +++++++++++++----
 fs/ext4/extents_status-test.c |  2 +-
 fs/ext4/extents_status.c      | 17 ++++++++++++++++-
 fs/ext4/extents_status.h      |  2 +-
 fs/ext4/inode.c               | 15 +++++++++++----
 5 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10d36012ade49..d43f3e7228e44 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -541,12 +541,12 @@ static void ext4_cache_extents(struct inode *inode,
 
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
@@ -4277,7 +4277,8 @@ ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
 insert_hole:
 	/* Put just found gap into cache to speed up subsequent requests */
 	ext_debug(inode, " -> %u:%u\n", hole_start, len);
-	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE);
+	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE,
+			     false);
 
 	/* Update hole_len to reflect hole size after lblk */
 	if (hole_start != lblk)
@@ -4348,13 +4349,15 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
 
@@ -4366,6 +4369,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
diff --git a/fs/ext4/extents_status-test.c b/fs/ext4/extents_status-test.c
index 825d12513e4af..e5953777d34e8 100644
--- a/fs/ext4/extents_status-test.c
+++ b/fs/ext4/extents_status-test.c
@@ -145,7 +145,7 @@ static void es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 			    unsigned int status)
 {
 	down_read(&EXT4_I(inode)->i_data_sem);
-	ext4_es_cache_extent(inode, lblk, len, pblk, status);
+	ext4_es_cache_extent(inode, lblk, len, pblk, status, false);
 	up_read(&EXT4_I(inode)->i_data_sem);
 }
 
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index b7fb8502f9d46..46601631022e6 100644
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
index 01cddcaaa68ed..c05ac69f07acc 100644
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
index 9368a68db2894..98053dea24c02 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -605,7 +605,7 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
 
 	if (retval <= 0) {
 		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
-				     map->m_pblk, status);
+				     map->m_pblk, status, true);
 		return map->m_len;
 	}
 
@@ -628,11 +628,11 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
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
@@ -644,6 +644,13 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
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
@@ -675,7 +682,7 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
-				     map->m_pblk, status);
+				     map->m_pblk, status, pre_search);
 	} else {
 		retval = ext4_map_query_blocks_next_in_leaf(handle, inode, map,
 							    orig_mlen);

base-commit: bae28a1b11f422d0214654800d9425e042295c71
-- 
2.39.5

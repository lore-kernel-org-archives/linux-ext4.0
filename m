Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118D0330D29
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 07:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784533935; cv=none; b=kTUBjlIIpD2d267P2b+xWDSuax//uZdvjIi4mLT4uNmk60DJOiNusizfUkWGXtg0a+BhpbU4/pbTwp8/qTglGRtvtEmmTApLfpJw6Mt9P2dXgN48A6l8xi0NFSpXXMBv5+FK67q3dNgQqxOZdgjKvs2uobLtDTGIiyNjfiaOYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784533935; c=relaxed/simple;
	bh=unau06xTVOcllIdkRrYIQEr4+jA05DYTizbcJFmX0Q0=;
	h=Subject:Mime-Version:From:Cc:Date:Content-Type:To:Message-Id; b=bxEJrJSCw6sF8kEURyX4pTgBvcPMMWJLkAWHXmo6nWqdS8ftndWuZ98cE5NKV1iqTEQZilGfjt7vEqaaUlEiFWp/0XbjmNBV3kirzSw8+4ykj2CoFYBdIAXs1cC9xzA3Z1nmihkVBDt0iWmK6vfV1DdvECPJGMJYWVBNTXdsud0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=gzWuQlmQ; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="gzWuQlmQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784533920; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ENA2euA0vVV2xzsQQELdY7B1UOMp1ZonL4350rvTwAI=;
 b=gzWuQlmQ3HesYIZYDwDGpPoIPf1AeFmEZG6pFr91fA6EYxLGdCpQaCwYRHv0D/HcGLMitE
 CeW1pxbvNq2Snpmo7TMxBWlgplfRg73c8ZyuHXiY8do+3cKqNM53zviiKRmsxBkyc28xj5
 /BUEWyzbsX8Esx96En0j0rlmreujnnKAcRFqQl2JNRZPLDXrKRPtpwYQgjLzcrGUZ4JlYa
 RZpeK/m9RxUmd8UM6iKEWgspmwdNWNNSpmWR7cbiXhnIbM1ltSdlourh6j8bihimCqlxbP
 JFmsVMY3sanuC198O2yCFMoEoZ/emaONatPb99GHluDtLOa6arKV8EG8T3zdtw==
Subject: [PATCH] ext4: cache full extents during mapping lookup
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fengnan Chang" <changfengnan@bytedance.com>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Mon, 20 Jul 2026 15:51:33 +0800
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <20260720075133.50539-1-changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a5dd39e+e448de+vger.kernel.org+changfengnan@bytedance.com>

The extent status (ES) tree and extent tree leaf buffers are reclaimed
independently.  An ES entry can be reclaimed while the leaf buffer remains
cached with BH_Verified set.

When this happens, ext4_es_lookup_extent() misses.  Since the leaf buffer
is already verified, __read_extent_tree_block() returns it without calling
ext4_cache_extents().  ext4_ext_map_blocks() returns the part of the extent
covered by the request, and ext4_map_query_blocks() caches only that range.
Reads to other blocks in the same extent then keep missing the ES tree and
walking the extent tree.

Cache the full extent in ext4_ext_map_blocks() before the returned mapping
is limited to the requested range.  Check the ES tree under the read lock
first.  If the full extent is not there, ext4_es_cache_extent() checks
again under the write lock before inserting it.

Do not do this when ext4_ext_map_blocks() is called with
EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE.  NOCACHE paths can change extent
mappings, so caching ranges outside the request can leave stale ES entries.
Cache both written and unwritten extents, as ext4_cache_extents() does.

Tested with fio 4K random direct reads using libaio at iodepth 128 on a
128 GiB file with 208 on-disk extents.  The results are averages of three
10-second runs:

                 before reclaim    after reclaim
  unpatched        419.6k IOPS       274.6k IOPS
  patched          426.1k IOPS       423.7k IOPS

Average completion latency went from 303.02 to 462.78 us without the patch,
and from 298.36 to 300.07 us with the patch.

No latency regression was seen in A/B test.

Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/ext4/extents.c        |  9 +++++++++
 fs/ext4/extents_status.c | 33 +++++++++++++++++++++++++++++++++
 fs/ext4/extents_status.h |  3 +++
 3 files changed, 45 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b317..f43dd9c3bc44e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4310,6 +4310,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
 		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
 		unsigned short ee_len;
+		unsigned int status;
 
 
 		/*
@@ -4317,6 +4318,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
+				ext4_es_cache_extent_if_missing(inode, ee_block,
+								ee_len, ee_start,
+								status);
+
 			/*
 			 * If the extent is initialized check whether the
 			 * caller wants to convert it to unwritten.
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e82191..83fe2068ab656 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1082,6 +1082,39 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 			   ext4_es_pblock(&chkes), ext4_es_status(&chkes));
 }
 
+/*
+ * Avoid taking i_es_lock for writing if the entire extent is already cached.
+ * ext4_es_cache_extent() rechecks under the write lock if the cache changes
+ * after this read-side check.
+ */
+void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t lblk,
+				     ext4_lblk_t len, ext4_fsblk_t pblk,
+				     unsigned int status)
+{
+	struct extent_status *es;
+	ext4_lblk_t end;
+	bool cached;
+
+	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
+		return;
+
+	if (!len)
+		return;
+
+	end = lblk + len - 1;
+	if (WARN_ON_ONCE(end < lblk))
+		return;
+
+	read_lock(&EXT4_I(inode)->i_es_lock);
+	es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
+	cached = es && es->es_lblk <= lblk && ext4_es_end(es) >= end &&
+		 !__es_check_extent_status(es, status, NULL);
+	read_unlock(&EXT4_I(inode)->i_es_lock);
+
+	if (!cached)
+		ext4_es_cache_extent(inode, lblk, len, pblk, status);
+}
+
 /*
  * ext4_es_lookup_extent() looks up an extent in extent status tree.
  *
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f3396cf32b446..d8fab84911352 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -140,6 +140,9 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len, ext4_fsblk_t pblk,
 				 unsigned int status);
+void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t lblk,
+				     ext4_lblk_t len, ext4_fsblk_t pblk,
+				     unsigned int status);
 extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 				  ext4_lblk_t len);
 extern void ext4_es_find_extent_range(struct inode *inode,
-- 
2.39.5 (Apple Git-154)

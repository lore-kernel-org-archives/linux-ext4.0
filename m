Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E6D3921ED
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 11:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784029541; cv=none; b=h9sjr/vmizoKasRkTPkXpxOXPHdDdS2X1NJzFrJ/f5ILfLza79o5oUplY8oiddWEtkcLguaYTRR4dTCnnA0Rm2/yqNg/a8sTGyL0QsELUsxVSS2ET6lyr+wQsuawsqaFbRxpVJshx72Jrn7RcULFlS0f+4KnuOv4LQNo6Q+Pijc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784029541; c=relaxed/simple;
	bh=csxGryUQoLsARk6lKn922TOTvpSBOeE+mFPBybDAz4I=;
	h=Mime-Version:In-Reply-To:Content-Type:Cc:Subject:References:Date:
	 Message-Id:To:From; b=I6/KEqG6McGHLTRy0aXWP1DqF/QhPYp6LgRCdrycCF1PAYEBuuHBcwaMA84lj/JAMJIh/+2XNL82wZfdHF6sLWCXONzEHjb40QFETcnuau5wWNVPKaBef76uZreqJ5DAapu+t4JTE6wLPNf/GJXIg4GJ/pZvDVjozlMSimbxicg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=jC9JB5Bh; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jC9JB5Bh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784029534; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=fRCkMIbKkIH1Hpc4hGmKK5onMJVlEiRINcqc2ON8fuQ=;
 b=jC9JB5Bhwqc2i7DsiKJ3WDyNG39bmlpi71QEb0Cewro+1BKIGSugzlvNavTxJjCcG0bgjl
 yr51oMUWMS4QLoeDNRlDH+6rhFEY9i9vGWy+31PkNZyq2LDTzZoP4DBARUtu0m5ALvB+5n
 84XkhDdxMXC0CDI/eTDCs9nXmlOfj1lA/ppzHX8HE+6CXdnB0BGGcgvcYqFfsQoMgCHdyE
 4QYAUl5T9Gi6kn6lF3JH7doYJrw2SzbMPD488Zrj+2Hb/ip9jXzLhmDydbVxFKIKH+luO4
 t8yc2PulXatUEJicNao09eLUwK6CHNDM9/Y/7l0t0XhgYS6BAVEKtS9WruMRsw==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a56215c+31a76c+vger.kernel.org+changfengnan@bytedance.com>
In-Reply-To: <20260714114358.93335-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>, 
	"Fengnan Chang" <changfengnan@bytedance.com>
Subject: [RFC PATCH 2/2] ext4: cache the full extent after a DIO extent status miss
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
References: <20260714114358.93335-1-changfengnan@bytedance.com>
Date: Tue, 14 Jul 2026 19:43:58 +0800
Message-Id: <20260714114358.93335-3-changfengnan@bytedance.com>
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: <tytso@mit.edu>
From: "Fengnan Chang" <changfengnan@bytedance.com>

Extent status entries and extent-tree leaf buffers can be reclaimed
independently.  Memory pressure may remove an extent status entry while the
leaf buffer remains in the buffer cache with its "verified" flag set.

When a DIO read hits this state, the extent status lookup misses but the leaf
buffer is still verified. __read_extent_tree_block() returns the buffer
without calling ext4_cache_extents(), so the leaf is not added back to the
extent status tree.
ext4_ext_map_blocks() then crops the mapping to start at m_lblk, and
ext4_map_query_blocks() caches only that suffix.

Reads to earlier blocks in the same extent keep missing the extent status
tree and walking the extent tree on every I/O, even though the leaf block is
already in memory.

Pass a new EXT4_GET_BLOCKS_CACHE_READ_EXTENT flag from ext4_iomap_begin()
for DIO reads on extent-based inodes.  If the leaf lookup did not populate the
extent status tree, cache the full matching written extent (ee_block, ee_len)
before cropping the mapping to the requested block.  Later reads within that
extent can then hit the extent status tree directly.

Only do this for written extents.  An unwritten extent returns zeroes on a DIO
read without disk I/O, so caching it does not avoid a useful I/O lookup.  If
the full-extent insertion fails, for example because of ENOMEM, keep the
existing suffix-cache behavior.

Testing with fio 4K random direct reads (io_uring, iodepth=128) on a
128 GiB file (75 on-disk extents) after forcing extent status reclamation via
drop_caches=2 and a helper file creating about 40k reclaimable objects:

  After extent status reclaim (no patch): 296k IOPS, clat avg 428.69 us
  Baseline (full extent status cache):    525k IOPS, clat avg 241.96 us

The patch returns performance to the baseline in this test by eliminating the
repeated extent-tree lookups.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/ext4/ext4.h    | 5 ++++-
 fs/ext4/extents.c | 8 ++++++++
 fs/ext4/inode.c   | 6 +++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 52c75fd44344a..528c0d7d921c5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -740,6 +740,8 @@ enum {
 #define EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF	0x1000
 	/* Report successful extent status cache population to the query path. */
 #define EXT4_GET_BLOCKS_TRACK_ES_CACHE		0x2000
+	/* Cache the full written extent found by a read-only query. */
+#define EXT4_GET_BLOCKS_CACHE_READ_EXTENT	0x4000
 
 /*
  * The bit position of these flags must not overlap with any of the
@@ -759,7 +761,8 @@ enum {
  */
 #define EXT4_EX_QUERY_FILTER	(EXT4_EX_NOCACHE | EXT4_EX_FORCE_CACHE |\
 				 EXT4_EX_NOFAIL |\
-				 EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF)
+				 EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF |\
+				 EXT4_GET_BLOCKS_CACHE_READ_EXTENT)
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a86beaaf63727..5790a8bdbb50a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4341,6 +4341,14 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if ((flags & EXT4_GET_BLOCKS_TRACK_ES_CACHE) &&
 			    (path[depth].p_flags & EXT4_EX_PATH_ES_CACHED))
 				map->m_flags |= EXT4_MAP_ES_CACHED;
+			if ((flags & EXT4_GET_BLOCKS_CACHE_READ_EXTENT) &&
+			    !(map->m_flags & EXT4_MAP_ES_CACHED) &&
+			    !ext4_ext_is_unwritten(ex)) {
+				if (ext4_es_cache_extent(inode, ee_block, ee_len,
+							 ee_start,
+							 EXTENT_STATUS_WRITTEN))
+					map->m_flags |= EXT4_MAP_ES_CACHED;
+			}
 			newblock = map->m_lblk - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (map->m_lblk - ee_block);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c222b0232d586..a98a4624b5a71 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3787,6 +3787,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned flags, struct iomap *iomap, struct iomap *srcmap)
 {
 	int ret;
+	int map_flags = 0;
 	struct ext4_map_blocks map;
 	u8 blkbits = inode->i_blkbits;
 	unsigned int orig_mlen;
@@ -3834,7 +3835,10 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		}
 		ret = ext4_iomap_alloc(inode, &map, flags);
 	} else {
-		ret = ext4_map_blocks(NULL, inode, &map, 0);
+		if ((flags & IOMAP_DIRECT) &&
+		    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+			map_flags = EXT4_GET_BLOCKS_CACHE_READ_EXTENT;
+		ret = ext4_map_blocks(NULL, inode, &map, map_flags);
 	}
 
 	if (ret < 0)
-- 
2.39.5 (Apple Git-154)

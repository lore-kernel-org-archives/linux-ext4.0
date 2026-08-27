Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402D33859FD
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 04:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787805574; cv=none; b=fDItb63SgRQjH1eqdQdDAg7CDqzmyVNE+vMtoJLqMagPguVxgc6kqQjA+A+J6NSuexWsgN/i+5+sTPir7gbb6QLph6PU7HB+bOrJSmz6ibA/iFm47vTNOSf/tv/NrbXqH7r2mZ1ZET3khBsdaemVWaQjOikSfkxagQtsZq+tGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787805574; c=relaxed/simple;
	bh=3i8+BvYXwd2chlIvOfFsoXVisJKCF70who3x47feFBA=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=jpZ4b6YkAoU89vK5D2W1ucqJQ7QrmL1KwIdbRimnVD/BfYeAjb1sfqZ5lhInWBaaIBEBXo78shXYfx+6uyKqhcJOFfj6SiAgA29rvrgPEKnrL9woueSchsnz1v2VqYeQxjTbcEQPum40a7nZn0zk9Rf3OuYgR5nQUr110/o1iak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OcEYihxU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OcEYihxU"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260827043929epoutp01def4585aefc2c34b20e30ae904d00744~Pj7F9NDS_0937109371epoutp019
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 04:39:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260827043929epoutp01def4585aefc2c34b20e30ae904d00744~Pj7F9NDS_0937109371epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787805569;
	bh=znhcDZHKVXBlC7SZudYXprdeWWw125hr2erauMMstwg=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=OcEYihxUF9pi7w1HwIvmgENPPt6LDchu7j+CZQs2iQqhWUrrpu3rxYy5SYC612NM+
	 BRKxim/OdR48XLMMSQftVOsM9bv1cHtG+Uvrw+lFFA48iNQP5onE/3+qAec93bGPHL
	 2J6IuImBf6KJu2n03WKgGQd/bF50f5pyGTjR09Ew=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260827043929epcas2p3cab01536700c12f184170a97a6a1501c~Pj7Fc8Dsy1037810378epcas2p3V;
	Thu, 27 Aug 2026 04:39:29 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.208]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hVphJ4x4pz3hhTH; Thu, 27 Aug
	2026 04:39:28 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v2] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>
CC: "jack@suse.cz" <jack@suse.cz>, "yi.zhang@huawei.com"
	<yi.zhang@huawei.com>, "ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"libaokun@linux.alibaba.com" <libaokun@linux.alibaba.com>,
	"ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"amonakov@ispras.ru" <amonakov@ispras.ru>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>
Date: Thu, 27 Aug 2026 13:39:28 +0900
X-CMS-MailID: 20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9
References: <CGME20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>

When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
it reports by counting the empty subtrees under 'partial' in the on-disk
indirect tree.  That count knows nothing about delayed allocation, so a
range holding delalloc data that has not been written back yet is
reported as a plain hole.  The extent-mapped path does not have this
problem: it trims the hole it found at the first delayed extent before
returning it.

ext4_map_blocks() consults the extent status tree before it calls into
the mapping layer, so a query that starts exactly on the delayed block
still finds it.  A query that starts earlier does not, because the hole
reported for the earlier block already spans the delayed one.  On a
4k-block filesystem, lseek(SEEK_DATA) from offset 0 on a file whose only
data block is at logical block N and is still dirty returns:

  N = 0..11      direct blocks                 N << 12
  N = 12         first single-indirect block   N << 12
  N = 13..1035   inside that indirect block    -1 ENXIO
  N = 1036       first double-indirect block   N << 12

Blocks 12 and 1036 survive because the query lands on the delayed block
itself.  Blocks 13..1035 are swallowed by the 1024-block hole reported
for block 12.  fiemap loses the same data for the same reason.

An ext3 filesystem mounted as ext4 hits this during ordinary use: ext3
inodes stay indirect mapped, while mount -t ext4 turns on delayed
allocation even though mounting ext3 with -o delalloc is explicitly
rejected.  install(1) from coreutils uses SEEK_DATA to locate data in
its source file, so installing a sparse file that has not been written
back silently produces a destination of the right size holding none of
the data:

  truncate -s 1G img && mkfs.ext3 -F img && mount -t ext4 img mnt
  echo | dd of=mnt/src bs=1 count=1 seek=64K
  install mnt/src mnt/dst
  cmp mnt/src mnt/dst        # differ: char 65537

Reconciling a hole with the extent status tree does not depend on how
the hole was found, so instead of open coding it a second time, split
the delalloc handling out of ext4_ext_determine_insert_hole() into
ext4_determine_insert_hole(), which takes the hole the caller located,
and call that from ext4_ind_map_blocks() as well.  All the special cases
and the comments explaining them stay in one place.

Two things change for indirect-mapped inodes.  They now cache the holes
they report, as the extent-mapped path already does: ext4_punch_hole()
already puts EXTENT_STATUS_HOLE on such inodes, ext4_map_blocks() and
ext4_da_map_blocks() already handle a cached hole, the latter by
replacing it with the delayed extent, and consecutive hole entries
merge, so the tree does not grow with the length of a scan.  And when a
delayed extent covers the queried block itself - a race, since
ext4_map_blocks() found nothing in the tree just before - the hole is
now reported only up to the end of that extent instead of in full.

The indirect path passes hole_start == lblk, so the "delalloc extent in
front of the queried range" case cannot be reached there:
__es_tree_search() never returns an extent ending before the block it
was searched for.

With this the sweep above returns N << 12 for every N, while the
nodelalloc and extent-mapped controls are unchanged.  generic/225,
generic/285, generic/286, generic/436, generic/448 and generic/490 pass
on ext4 made both with and without the extent feature.

Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
Reported-by: Alexander Monakov <amonakov@ispras.ru>
Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru/
Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
v1: https://lore.kernel.org/linux-ext4/20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5/

v2: rather than open coding the delalloc trim in ext4_ind_map_blocks(),
    split it out of ext4_ext_determine_insert_hole() into
    ext4_determine_insert_hole() and call that from both paths, as Jan
    suggested.  Two things follow from sharing the whole function, both
    noted in the commit message: indirect-mapped inodes now cache the
    holes they report, and a delalloc extent covering the queried block
    now shortens the reported hole instead of leaving it whole.

 fs/ext4/ext4.h     |  3 +++
 fs/ext4/extents.c  | 26 +++++++++++++-------------
 fs/ext4/indirect.c | 11 +++++++++++
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7fd078de265d..f5eff74631a4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3893,6 +3893,9 @@ extern void ext4_ext_tree_init(handle_t *handle, struct inode *inode);
 extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map, int flags);
+ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
+				       ext4_lblk_t hole_start,
+				       ext4_lblk_t hole_len);
 extern int ext4_ext_truncate(handle_t *, struct inode *);
 extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 				 ext4_lblk_t end);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 836396ea7912..e2b7565e2cb4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4190,21 +4190,19 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 }
 
 /*
- * Determine hole length around the given logical block, first try to
- * locate and expand the hole from the given @path, and then adjust it
- * if it's partially or completely converted to delayed extents, insert
- * it into the extent cache tree if it's indeed a hole, finally return
- * the length of the determined extent.
+ * Adjust the hole [@hole_start, @hole_start + @hole_len) the caller found
+ * around the queried block @lblk if it's partially or completely converted
+ * to delayed extents, insert it into the extent cache tree if it's indeed a
+ * hole, finally return the length of the determined extent starting at
+ * @lblk.  @hole_start must not be behind @lblk.
  */
-static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
-						  struct ext4_ext_path *path,
-						  ext4_lblk_t lblk)
+ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
+				       ext4_lblk_t hole_start,
+				       ext4_lblk_t hole_len)
 {
-	ext4_lblk_t hole_start, len;
+	ext4_lblk_t len = hole_len;
 	struct extent_status es;
 
-	hole_start = lblk;
-	len = ext4_ext_find_hole(inode, path, &hole_start);
 again:
 	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, hole_start,
 				  hole_start + len - 1, &es);
@@ -4371,9 +4369,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * we couldn't try to create block if flags doesn't contain EXT4_GET_BLOCKS_CREATE
 	 */
 	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
-		ext4_lblk_t len;
+		ext4_lblk_t hole_start = map->m_lblk, len;
 
-		len = ext4_ext_determine_insert_hole(inode, path, map->m_lblk);
+		len = ext4_ext_find_hole(inode, path, &hole_start);
+		len = ext4_determine_insert_hole(inode, map->m_lblk,
+						 hole_start, len);
 
 		map->m_pblk = 0;
 		map->m_len = min_t(unsigned int, map->m_len, len);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 5aec759eed70..9dc0759c88ef 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -586,6 +586,17 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 		for (i = partial - chain + 1; i < depth; i++)
 			count = count * epb + (epb - offsets[i] - 1);
 		count++;
+
+		/*
+		 * The count knows nothing about delayed allocation, so let
+		 * the common helper reconcile it with the extent status
+		 * tree.  Clamp it first: with a large block size a subtree
+		 * can be bigger than the logical block space.
+		 */
+		count = umin(count, EXT_MAX_BLOCKS - map->m_lblk);
+		count = ext4_determine_insert_hole(inode, map->m_lblk,
+						   map->m_lblk, count);
+
 		/* Fill in size of a hole we found */
 		map->m_pblk = 0;
 		map->m_len = umin(map->m_len, count);

base-commit: 9091c97be34083587a75db174aab51551d8e8543
-- 
2.43.0


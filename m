Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3B93438A8
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2026 05:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787721899; cv=none; b=LPf+fZqO8xobuma06b3TeuJLkoixQrIg3Gi/g1cViiVgJKmqQ9iyDiO4FPaY1pKNIsx/evc7xI2gJSmavnPYSZg8tI7NoBCpP0LzMbNx5N6dVsgGraQMzEGQ6sPjqVW2dX+xnU/R/wT7fDRRXU5fKCxuQyggYTav52Qqm5W0eOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787721899; c=relaxed/simple;
	bh=78MnjTChEpgAxz4YJNBkMVUqxn4HSuMjpX/gDu+9VzI=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=JcJM2tLikQSOqnU3Ns2hV5yjV9fj5S9B7IuK8+YVzLOpCHedq4dNW/dKsrFpoj22K6Fsv7qYuTSvLVaDO61+VQrkGhekzL/QRmjFhPh2h4CjXOfMC88p9sT8bYrUTceB0v+Fb/VrFB9ZO5kNhMowXc/FgTXRT9tqCOtJAQxYA4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NSNEblFV; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NSNEblFV"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260826052448epoutp02386c980474671536e8601d6e69ef30d3~PQ5XntI7e2358923589epoutp02P
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2026 05:24:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260826052448epoutp02386c980474671536e8601d6e69ef30d3~PQ5XntI7e2358923589epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787721888;
	bh=COMQYQ3Lo5EWPtwlsUfLwHyXlHGoZNDAHc5nG+1dUYk=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=NSNEblFVMQnW1RRm6i4Ql5OkOTVHXww/5tUfnMbiXNIj518K+q/Zuwn4B9NmyiAWb
	 cGoeSCTUAOt9T1Q7OZcQEgMxjKVcGtbmPCRl3mHDHtp+PvT1xcfgDX+1Z/fp/+kmcg
	 jd4rKvj7LOBrcQ2WXk9hsJvGiSxgaTD1LpP/gE8Y=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260826052447epcas2p2e6dc6704ab2dc57fa11bd06a80ad8b71~PQ5XOFdb-1767817678epcas2p2Q;
	Wed, 26 Aug 2026 05:24:47 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.207]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hVCl333Mjz6B9mG; Wed, 26 Aug
	2026 05:24:47 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] ext4: don't report delalloc data as a hole on
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
Message-ID: <20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>
Date: Wed, 26 Aug 2026 14:24:46 +0900
X-CMS-MailID: 20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea
References: <CGME20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>

When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
it reports by counting the empty subtrees under 'partial' in the on-disk
indirect tree.  That count knows nothing about delayed allocation, so a
range holding delalloc data that has not been written back yet is
reported as a plain hole.  The extent-mapped path does not have this
problem: ext4_ext_determine_insert_hole() trims the hole it found at the
first delayed extent before returning it.

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

Trim the hole at the first delayed extent, the way the extent-mapped
path does.  ext4_es_find_extent_range() does not clip the extent it
returns to the queried range, so skip one that begins at or before
m_lblk and clamp the result against the hole already found.

With this the sweep above returns N << 12 for every N, while the
nodelalloc and extent-mapped controls are unchanged.  generic/225,
generic/285, generic/286, generic/436, generic/448 and generic/490 pass
on ext4 made both with and without the extent feature.

Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
Reported-by: Alexander Monakov <amonakov@ispras.ru>
Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru/
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/ext4/indirect.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 5aec759eed70..4a1ad86a42bd 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -574,6 +574,7 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	/* Next simple case - plain lookup failed */
 	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
 		unsigned epb = inode->i_sb->s_blocksize / sizeof(u32);
+		struct extent_status es;
 		int i;
 
 		/*
@@ -589,6 +590,21 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 		/* Fill in size of a hole we found */
 		map->m_pblk = 0;
 		map->m_len = umin(map->m_len, count);
+
+		/*
+		 * The hole was measured on the on-disk indirect tree, which
+		 * knows nothing about delayed allocation.  Trim it at the
+		 * first delayed extent, the way the extent-mapped path does
+		 * in ext4_ext_determine_insert_hole(), so that callers do not
+		 * mistake data that is not written back yet for a hole.  The
+		 * extent found is not clipped to the queried range, so it may
+		 * begin before m_lblk or past the end of the hole.
+		 */
+		ext4_es_find_extent_range(inode, &ext4_es_is_delayed,
+					  map->m_lblk,
+					  map->m_lblk + map->m_len - 1, &es);
+		if (es.es_len && es.es_lblk > map->m_lblk)
+			map->m_len = umin(map->m_len, es.es_lblk - map->m_lblk);
 		goto cleanup;
 	}
 

base-commit: 9091c97be34083587a75db174aab51551d8e8543
-- 
2.43.0


Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1929C37F00A;
	Fri,  8 May 2026 12:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242576; cv=none; b=MNxuvRJlibjMNvm7taoyjkU+G53970j5L1jYRARG54nIuweft8mdHXwWv0ij/L385I6QOxrZtc7giFwzmtZnNfJe3VhIk0ETKtXZ6nwm9fD6p6tqFspQ9IhhpuvP1ydl4fgk9V5KnbuCY7We2J2Hh73fgCR7OrPzVj88A4mCmgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242576; c=relaxed/simple;
	bh=OCr7/orzjZm0TJC3ZdQdc8ZIR6kVqo8sCAQ2Ng4CQEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2G2P1PJaKoVGIwH+IOx4XJvhWF28zSHpSJRKbtMlHkB6GL0JpmPqohfH6pp30UOSnL+z5q0VlEXK9mcKDLigFMn8ZHHy+IqulAncZuqDTqe+zswBTfSxBZvOyTiOtoVw8sKJQ/kDwT8PoS8pF3d+D7rgwHK4HPjvEwofnyxb/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oBslsgyw; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oBslsgyw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242566; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=mOG2NnAGPPdQ3W0BX30E8ncse768vHXAuwsNTrJ5Vfw=;
	b=oBslsgyw53QhYZYqDQ8OoZ3q+LS7yS/f7Rs1zDCitQk66DlKQk5flgwsXL2/gkGqSWKw6ZvDTNVnWzvut3jjw1qGN+0Jw0gPdFfPTyd1tShpDW8vMadK4P3VYJFBWa5h5phDthLN54gG6eULOb96EVDPyOPBPpwAJp6j6Qtwzn0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgpZ_1778242564;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgpZ_1778242564 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:04 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	ebiggers@kernel.org,
	ardb@kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH RFC 07/17] ext4: use fast incremental CRC update in ext4_mb_mark_context()
Date: Fri,  8 May 2026 20:15:29 +0800
Message-ID: <20260508121539.4174601-8-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
References: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use ext4_block_bitmap_csum_set_range() in ext4_mb_mark_context() for
fast incremental block bitmap checksum updates. Instead of re-scanning
the entire bitmap after every allocation or free, the incremental update
computes the CRC delta for the modified bit range in O(log N) time.

Add a fast_crc flag that is set when EXT4_MB_BITMAP_MARKED_CHECK is not
used. When fast_crc is true, all bits in the range are guaranteed to flip,
so the incremental CRC via ext4_block_bitmap_csum_set_range() is correct.
Otherwise, fall back to ext4_block_bitmap_csum_set() for a full CRC
recalculation, since idempotent operations (mb_set_bits/mb_clear_bits
with EXT4_MB_BITMAP_MARKED_CHECK) may leave some bits unchanged.

For the BLOCK_UNINIT case, the bitmap was just initialized and there is
no valid old checksum, so fast_crc is forced to false to ensure a full
CRC recalculation establishes a correct baseline.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/mballoc.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ff2023c9f52c..77f6309916d1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4095,6 +4095,7 @@ ext4_mb_mark_context(handle_t *handle, struct super_block *sb, bool state,
 	struct buffer_head *gdp_bh;
 	int err;
 	unsigned int i, already, changed = len;
+	bool fast_crc;
 
 	KUNIT_STATIC_STUB_REDIRECT(ext4_mb_mark_context,
 				   handle, sb, state, group, blkoff, len,
@@ -4127,12 +4128,28 @@ ext4_mb_mark_context(handle_t *handle, struct super_block *sb, bool state,
 			goto out_err;
 	}
 
+	/*
+	 * fast_crc: Use incremental CRC update via crc32c_flip_range().
+	 * This is only valid when all bits in [blkoff, blkoff+len) are
+	 * guaranteed to be in the opposite state (i.e., every bit will
+	 * actually flip). When EXT4_MB_BITMAP_MARKED_CHECK is set,
+	 * mb_set_bits/mb_clear_bits are idempotent, so some bits may not
+	 * change and incremental CRC would produce incorrect results.
+	 */
+	fast_crc = !(flags & EXT4_MB_BITMAP_MARKED_CHECK);
+
 	ext4_lock_group(sb, group);
 	if (ext4_has_group_desc_csum(sb) &&
 	    (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))) {
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 		ext4_free_group_clusters_set(sb, gdp,
 			ext4_free_clusters_after_init(sb, group, gdp));
+		/*
+		 * The bitmap was just initialized, so the old checksum
+		 * is invalid for incremental CRC update. Fall back to
+		 * full recalculation.
+		 */
+		fast_crc = false;
 	}
 
 	if (flags & EXT4_MB_BITMAP_MARKED_CHECK) {
@@ -4154,7 +4171,10 @@ ext4_mb_mark_context(handle_t *handle, struct super_block *sb, bool state,
 			ext4_free_group_clusters(sb, gdp) + changed);
 	}
 
-	ext4_block_bitmap_csum_set(sb, gdp, bitmap_bh);
+	if (fast_crc)
+		ext4_block_bitmap_csum_set_range(sb, gdp, blkoff, len);
+	else
+		ext4_block_bitmap_csum_set(sb, gdp, bitmap_bh);
 	ext4_group_desc_csum_set(sb, group, gdp);
 	ext4_unlock_group(sb, group);
 	if (ret_changed)
-- 
2.43.7


Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442BD37FF76;
	Fri,  8 May 2026 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242569; cv=none; b=K9Uz0OMQtBu/fxbcusAeuD+EFvg6iKFhZLZK0fAdInykbSOn2Hgn7GB42iQRiTyGMXNqo0BFrGYOOPXrUp1iUorBOMfDmEqZoevNLJBjMFKwW0by/TUhf8LS+yI66dlK2rwr0jDavCqJP3PbXHKd0pZEFk5npmRS0cIYOaQGvuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242569; c=relaxed/simple;
	bh=eI+lnb4OIstw+TJ/gSUcTbk+6CPtXDvwn0TN344wuIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni/5Mmj2ipAKXuIUFWOny7Jty782J1O4IQcvQiOVEMn/rVgbYfHjYUt7uDkUVX52ubhhHaKM9cr5xcJ9pufPMAh/xEx+KqwblGLudf/59sK3n2YRww0aN+PRh4gVmg+NBd05Irlr3e45WJXi/eMquD/ieZEaqCUZ0Azfb4sLh5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZiKMth1D; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZiKMth1D"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242563; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=UjyILuNe0LAhrUwcQd6OrpHIO74QHE8aSygiu8ENNoo=;
	b=ZiKMth1DCl8veoBr+UFzIJ5EzNohOFnj4bjiPXxqtTwyff/Yg9egkJBaO/ylGUadrZtoxTt7oYSYDI1J2VMsMijbKI2/CCzQVW1OYoa6U8DxIgTHylqygdTZ7CnVQ3zbCf6erovoSOmXiin4X2b+2CBOydhNfCrvTX9FEGZ2a+Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgo7_1778242562;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgo7_1778242562 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:02 +0800
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
Subject: [PATCH RFC 04/17] ext4: fix incorrect block bitmap free clusters update on metadata overlap
Date: Fri,  8 May 2026 20:15:26 +0800
Message-ID: <20260508121539.4174601-5-libaokun@linux.alibaba.com>
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

In ext4_mb_mark_diskspace_used(), when the allocator detects that the
allocated blocks overlap with filesystem metadata, it enters an error
recovery path that marks these blocks as used in the bitmap via
ext4_mb_mark_context() with flags=0.

Without EXT4_MB_BITMAP_MARKED_CHECK, ext4_mb_mark_context() assumes all
bits in the range will be flipped, so it sets changed=len unconditionally.
However, in a corrupted filesystem, some of these metadata blocks may
already be marked as used (bit=1) in the bitmap. Since mb_set_bits() is
idempotent (sets bits to 1 regardless of current state), bits that are
already set won't actually change, but the free clusters count is still
decremented by the full range length, leading to an inaccurate free
clusters count.

Fix this by passing EXT4_MB_BITMAP_MARKED_CHECK, which correctly counts
only the bits that actually changed state.

Fixes: 2f94711b098b ("ext4: call ext4_mb_mark_context in ext4_mb_mark_diskspace_used")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed1bd00e11cd..ff2023c9f52c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4228,7 +4228,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac, handle_t *handle
 					   ac->ac_b_ex.fe_group,
 					   ac->ac_b_ex.fe_start,
 					   ac->ac_b_ex.fe_len,
-					   0, NULL);
+					   EXT4_MB_BITMAP_MARKED_CHECK, NULL);
 		if (!err)
 			err = -EFSCORRUPTED;
 		return err;
-- 
2.43.7


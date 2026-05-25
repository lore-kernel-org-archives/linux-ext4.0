Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBCB312815;
	Mon, 25 May 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729585; cv=none; b=oeL1d912MZbfBFcqvdod/5lVKqbBHL5tqiX+nB5IQTX1E/S2+4Wyyq3wGEXB68YMsz4mtM0Rh1dBmpZhr4rRGU4z4zPRC0wRLHigRtPwkxonty/1kwV2TEX/UU3X23WMKbr0X5lHm5ZFjF0i+NPa47oVpY0EbXtoncCr/LayHm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729585; c=relaxed/simple;
	bh=B6ShqVzIywMCHyNapceYQjq2yp7xl/QwnvnzsguEVEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Sn1oQb3MwRkaCAyXC2BW1nWmltU+EzqzgOFPscBSH2JcJqko6suPg7LFEaw58IE9LT7VOtXYQItmZiNBly4TqMtCera3Om5MsL4BL7hQX9Sz/Kv5bj2tdXJrA4d1Vt25ynHxCLTy0z0qzc0tSL4kjh4K/bAM8vXxmcm/mtUeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SuKZVYmO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SuKZVYmO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=eBiedvbgN170Z8+Nk2r3mIIpzc4jM+0W2lgvtKZFGP8=; b=SuKZVYmOWs06dnrMMbkTczw3B3
	fF1YzD7aTn127kiTQyCOk2XZb9JrdRvtK92bmzZgvXZn9FR7lcQ+dGEZ/CGoPn9qxAqmtjdCTXGK5
	VXC9Bbm2mvK40JjJsba3vDqUlePNGM++HWZXuvvUQ3Mvd4kBdzGPLw2NN0SAoGMd1evov5hU3fNJ2
	GqAeMmcu8vEYXmRBlXYiw4dQ7nMlwsAGuZl1sfMWvXd/qc1cwbpFKSZjaCMKUdc9uTT7kXACe1x7b
	jFur9PqdTVLTyPVLce6XWEwRP00/LAGgiSUPm/R0XtLAcOmpHcZk4y6q6uewRolNTlO4q0zoym4VC
	wR2oQfSg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxq-0000000HOBA-00nM;
	Mon, 25 May 2026 17:19:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 14/34] ext4: Convert write_mmp_block_thawed() to bh_submit()
Date: Mon, 25 May 2026 18:19:07 +0100
Message-ID: <20260525171931.4144395-15-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525171931.4144395-1-willy@infradead.org>
References: <20260525171931.4144395-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call by using bh_submit() instead of
submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/mmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 6f57c181ff77..493528fbed75 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -46,9 +46,9 @@ static int write_mmp_block_thawed(struct super_block *sb,
 
 	ext4_mmp_csum_set(sb, mmp);
 	lock_buffer(bh);
-	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
-	submit_bh(REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO, bh);
+	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
+			bh_end_write);
 	wait_on_buffer(bh);
 	if (unlikely(!buffer_uptodate(bh)))
 		return -EIO;
-- 
2.47.3


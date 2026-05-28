Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78323FD13F;
	Thu, 28 May 2026 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989519; cv=none; b=plP+FTu1n5/EamIAxZKXg21DgYhhTobABF8vV8Fy20o+GTNuLUV8BhPmWM/CVXwd/iGOC44iWrZbM+XrfC5ZHbFCjGUckTJCXC09emXT7wpJnounDuaKTwmFPHvrlbK6n/CiFVCc8aI+6PoGC5HGLQShP+IfSJDl6ZrZJPvR4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989519; c=relaxed/simple;
	bh=ItaHl8ZkaISr41AfEx7xLpJ8LMPKSlkeq0mZjT9OzBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc1bbDDUVGMj9W3hTTVSe1n3kAkp4ILlwxrezRZ+IatD9NHCmgqwjGAsWWh8d5TZfONsm2gc4q6WheDsiza4aNjRFK4GcYIpjVkZif7qYLUEizh7Rgwci2f9xPxycQm8MXfZC5L2mO9q6bUa7mKQiyTM8+406QqpoO5BlSeFDTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wV1xZNTu; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wV1xZNTu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=LcJp+Ytx240VuBDRcZk9owF5OmUKRtyXb1hYH/hCZVs=; b=wV1xZNTuutYs8nseUvyjw5hfCy
	p2P1pfn8wQtMi/5tOUMgeMdX/eVGQRjfVm/MntsHFjCotkw2zhS/mXBqQbuxqVmiWj0eN/GFd/Hq3
	GIZH59SxngcslvOITJO0AXAH+3m05ZAmFw83LW7rVE0Br29vxNaZn1X37e6AZnh++DFsrSs7xHyKw
	bEJnWv6Q4OfFkLsliwQz/9hTAf6svd3Pg+caYZGPD1QNE/2npynFWAZh1CWbxCNqMRwpL1EsuunXU
	bTwHJ1tNViOTTr9bl3EdlwAGdYm5WhzmmqWJo/orkzPb+ehxpDEcrFkDKIkXAomIJWVi7Oa8Vo1z0
	CkB9GyYQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaI-00000004aZg-3BEE;
	Thu, 28 May 2026 17:31:54 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v2 14/34] ext4: Convert write_mmp_block_thawed() to bh_submit()
Date: Thu, 28 May 2026 18:31:27 +0100
Message-ID: <20260528173150.1093780-15-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528173150.1093780-1-willy@infradead.org>
References: <20260528173150.1093780-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call and changing the buffer refcount
by using bh_submit() instead of submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/mmp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 6f57c181ff77..7ce361484b38 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -46,9 +46,8 @@ static int write_mmp_block_thawed(struct super_block *sb,
 
 	ext4_mmp_csum_set(sb, mmp);
 	lock_buffer(bh);
-	bh->b_end_io = end_buffer_write_sync;
-	get_bh(bh);
-	submit_bh(REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO, bh);
+	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
+			bh_end_write);
 	wait_on_buffer(bh);
 	if (unlikely(!buffer_uptodate(bh)))
 		return -EIO;
-- 
2.47.3


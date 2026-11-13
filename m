Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553640;
	b=CMQfAdl1BWwApFetSZfqyGFMTn0waE4x4m5zOV323SPjk9pC/f/+st1rkqSnJCWIuiEu
	 G1vErKwNQKXCDDtdBYceWU20SaVV1uCfnjIINFz6Qhc1hLU7kAitLU/Q8P39obGv8On9h
	 7Ca+edZ9Hi69ScchWojreUzMzO9ph+OTvX/XRzCjl2N8pCndHr2M9IpjB0KZT1zRxmh2D
	 Oli5Vyx04TkV57I9yvsdn0Zi1e6XJ1Gt/Xgk0S6Lpkw6vdzZ1J7MghCkaCmwBUQSjf7Lv
	 bb9Sslf7rMZ1zqNBzleVroo6L2A2diJPOU83mKIMPvZzJe1vaGlN0OBxnk3lwPCSdHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553640;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GZLtnWbFqtu8KIap5fiJtQhx6w9LpQFKds01tBdh2l0=;
	b=G+O5HiIkzLQe1Uvka28c/l7dcxpPf8RaYc4ai8bNksNUnj4+l8rcfD4Frh47x9WjAESr
	 rMNjImjVpC2kQyW0Z6kbYQEltyqwhPGMwAoJyCHmN18LY0KhcnJsRsqduf1Qpwhc5xiPE
	 2OMZwsPI+DGEK6DkXGRfucnuSsKzbofMhwrYE1f82sOOhME4+EQLUZ/Ty+76qKzdZYqrX
	 S1mm2h74nRLD7/xgSsYU3CoJqyqHPLMdz/e7j+j4WSRAlHxtVETnS2VBXxftHk9RELEPm
	 vlgIezHgAB2aapI463r5LOF7mn4P4NiDk3728QdwHhBO3Yo7zz4tVujm/u9RxZvWpiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u64wSiXr;
	arc=none smtp.remote-ip=95.215.58.180
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247E2606A8B4
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 247E2606A8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u64wSiXr
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wulpxDchqVhG4T16i7jOp2tJVbBXi1laAGjfm4w5eGs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553638; v=1; x=1795158438;
 b=u64wSiXr9YoxMTLiiPFG3x6j3X+qgKk4U2wB14aAvE5z2X/c+S+lLtx4APm9yuZmji9smYZx
 JXNVHCFIMmI7BEQbjNZO1fFwEpVeXYwFKUXVySSIg8MwGOYR4Ol1tMGrDjAmdqHWugAal+GarUR
 NcCSZkR+A1fKd3JgXQ66mWBM=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d2229d58c56c6432;
	Fri, 13 Nov 2026 07:07:17 +0000
X-Mizu-Trace-ID: d2229d58c56c6432
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj1072538@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	christian.koenig@amd.com,
	Philipp Stanner <phasta@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	asml.silence@gmail.com,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Li Wang <liwang@kylinos.cn>,
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: [RFC PATCH v2 2/8] iomap: add dma-buf direct I/O guards
Date: Fri, 13 Nov 2026 15:06:15 +0800
Message-ID: <20261113070621.273953-3-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Direct I/O copies data from the CPU in four places, zero-filling
holes, inline data, bounce pages and integrity metadata. A dma-buf
iterator has no pages behind it, so refuse it there.

Reads that encounter a hole or unwritten extent therefore return
-EOPNOTSUPP for the entire operation, even if I/O for an earlier
mapped extent was already submitted.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/iomap/direct-io.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ad041ac3252a..4a2b0f9df5a7 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -425,6 +425,11 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	unsigned int alignment;
 	ssize_t ret = 0;
 
+	/* integrity metadata is generated from the data pages */
+	if (iov_iter_is_dmabuf_map(dio->submit.iter) &&
+	    (iomap->flags & IOMAP_F_INTEGRITY))
+		return -EOPNOTSUPP;
+
 	/*
 	 * File systems that write out of place and always allocate new blocks
 	 * need each bio to be block aligned as that's the unit of allocation.
@@ -589,7 +594,13 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
-	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	loff_t copied;
+
+	/* zero-filling walks the data pages */
+	if (iov_iter_is_dmabuf_map(dio->submit.iter))
+		return -EOPNOTSUPP;
+
+	copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
 
 	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED) {
 		loff_t aligned_copied = round_down(copied,
@@ -619,6 +630,10 @@ static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
 	loff_t pos = iomi->pos;
 	u64 copied;
 
+	/* inline data is copied from the CPU */
+	if (iov_iter_is_dmabuf_map(iter))
+		return -EOPNOTSUPP;
+
 	if (WARN_ON_ONCE(!inline_data))
 		return -EIO;
 
@@ -717,6 +732,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (!iomi.len)
 		return NULL;
 
+	/* bouncing copies the data from the CPU */
+	if (iov_iter_is_dmabuf_map(iter) && (dio_flags & IOMAP_DIO_BOUNCE))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	dio = kmalloc_obj(*dio);
 	if (!dio)
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.203
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861968;
	b=ALKcpgGU03Py9NiQtWu3Jhzcv7I6H/9/r/L3U35iBgzGddhDFv0TG1al5oRdwhcJdIgQ
	 4Hp87ZAPgLgRrc/ALfbh4krL7RTBGJ/GRG1jia+WBQJHngS4puxbeCLEiOp4v+N+s+g8i
	 zQjmWqGVMU5zozLiWvKz3swkCmtRQvrnnhRdKk8+SGyTcuHQ0xN8fQo0pTxqUT1aA7APY
	 Dbp9FZRp6Ze+Ag7oQ0v/IhH0CcApfxHS/CFycSw6PVodSQQliX+WFpGGsx7hL0AZ5EvFk
	 eAPJanCuF+X9IFCYB5SxT7IEXkFZLEpDh9GJQPVptu3e0NaDVfW26ntt1wuaVp+yANA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861968;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nIzPxp67nycIcgpn1aR+9cX2c2A9Fk/9SrE7eGQSDVI=;
	b=cQfDqMEF7j5tkWHu16ENwPXO+STfQKY17eBZ4296Typ41M5nODTB5aBSt0vioSZAxMg8
	 Oe0rZXrSlIVfzg2ElZPbw6ullqdACnnbc6SCYFHmn0V0Avewdk/9F/U5kXg/0WabbU08c
	 8eRCK6bYDrrVOMznkOANsynr229NKxYbSaGUv8eIf0q/m4hBgX4ekFlCBDrnzlqNAmwhx
	 0ml5gyO/sPHcHBhtd0DA/XiqCEm0sP7X48U/uE30VkQSFyop1lJ6uqHBdJiAs9JUqoWTF
	 O5j4QrOJjLU6JzMTkmUUXnYWovry7Gmg/GOSH2n6qC3vonrfFVHwqnMD62Ba+k1uw0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=URJ69ifo;
	arc=none smtp.remote-ip=95.215.58.203
Received: from mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9A6606A32F
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 06:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C9A6606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=URJ69ifo
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xVc3emtqQK3gdjiaDH2/ozjRn5r+zA/0E88efrFuawg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861965; v=1; x=1794466765;
 b=URJ69ifo97ROruZ6pmwjXf0aKmSur7mh2uvlDandRG7mz4fCmrISF3oG8QPrDgE6EtbpnoLX
 DDOkrLFAjlHrjyterio5ErE9cY4DTjD2rrmzaqCHaS/HCXbs+pcE5kLsyhLVR0lxf7DWy2zDiJH
 ybQo4+FLjg9nVwpWWXkCsyjQ=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7015cdc676c618de;
	Thu, 05 Nov 2026 06:59:25 +0000
X-Mizu-Trace-ID: 7015cdc676c618de
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
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
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto context
Date: Thu,  5 Nov 2026 14:58:42 +0800
Message-ID: <20261105065847.196540-2-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
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

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

A dma-buf bio has no pages for the crypto layer to walk: the
software fallback would read the map as bio_vecs.  Refuse it in
blk_mq_submit_bio() before it can reach that path.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index be5671966787..f0d978b1724f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3138,8 +3138,10 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
+	/* a dma-buf bio has no pages for integrity work or contents crypto */
 	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
-		bdev_has_integrity_csum(bio->bi_bdev))) {
+	    (bdev_has_integrity_csum(bio->bi_bdev) ||
+	     bio_has_crypt_ctx(bio)))) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		goto queue_exit;
 	}
-- 
2.43.0


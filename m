Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553691;
	b=FIeD0iDObzQ4IaH7/qpGKBaGl+JuRnTl98Kgm/vLRYxxv59vRa6gz8kyzAphJILBjrEY
	 0ZCBfPe16y8RN20TjpGLqpahfEhp41nxtHasj/de4ISHL2TGGyTk4kMjLKJLGvxS1A6uU
	 JYXElEVsf+avjDfmrFz3DOV7E6WsM+qkjNLQKPmIm4pr76UByl5UoBDdWf5C1cfYt7ihm
	 96lAfDhKdrLS/qywhWbrzW4bBm2QUWkUy9hzUNlyITvHpU7PRuyb38oPPpfYouLZts//b
	 KOXlf+XQCOkDPcnp8fYsGBIH9qMyoE3pkcHevUNfRxXUl4LeQS6cZPhtJBUg2we+esg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553691;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oE2P4TXXbwbeZXnmaDd39X4I7W+VRQ8H2a+gqtaKE6M=;
	b=fwo9+V5/ac95YNKsz/+sDG0OTu6QK1pKr16iHR96zFHK4yjcsUuTzUlEyfEzZ5eJU2TY
	 d5Y72w4KQnJ2eWaT6ieOx1olWdPaDHowtAOW1UprtLQ0nmVUovKZlRw9iANuTQx0CvYu/
	 5ev/aJvjSEKWU4YuJNrjm2PhlYP0L8W1zpUvdhE/dqCFAAQNYxXWLK6AOf4tjTdHs6zHk
	 XZ4ST6q2nDqWg3CK/iuhfBUFZYri8Vo2lFoVRf8azEhmQa82UBGrNFKzhnNE6RbCQzHGg
	 uP0kTWzE2QszIR+jeufTRU+hBM3HJ1QhAZ2C9hCT8hN9rxN/7htMfhqQdKUz73PoT0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nKxRPFkc;
	arc=none smtp.remote-ip=91.218.175.6
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA3A606A88F
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECA3A606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nKxRPFkc
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TGEyrdi/pv1jc6teZ+wM/XGPkjaMpK/OOKnCVbRJDcg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553689; v=1; x=1795158489;
 b=nKxRPFkcrzPC7ZgkWruNcPuZqp1vlKz1pSass6D1zhpeWU/BBB78IxjJXoYSiRXWR3S/RBIh
 pTYcDSfp7qwzJP6QdsnXUceKvQPByHKrDddl4aN+Hy4zIc6Mi84vxB4uw2NZLDSf1+dwOPop5Pp
 0EP0xibP82F/nsdxwbJaCiDw=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 32332e07033e4feb;
	Fri, 13 Nov 2026 07:08:08 +0000
X-Mizu-Trace-ID: 32332e07033e4feb
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
Subject: [RFC PATCH v2 5/8] blk-crypto: refuse dma-buf bios in the fallback path
Date: Fri, 13 Nov 2026 15:06:18 +0800
Message-ID: <20261113070621.273953-6-mengmeng.zhao@linux.dev>
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

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

The inline encryption fallback encrypts through the data pages of a bio,
which a dma-buf bio does not have: its vec pointer holds the
driver-private dma_buf_io_map.  A crypt context the device supports
natively is programmed from the request instead, so refuse only where
the fallback is about to run.

blk_mq_submit_bio() is too late for this: submit_bio_noacct() has already
rejected a context the device does not support natively, while submitters
reach the fallback before the bio is queued.  No in-tree submitter builds
such a bio today.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index bc3a9f59574b..01b8d26040dc 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -271,6 +271,14 @@ bool __blk_crypto_submit_bio(struct bio *bio)
 			bio_endio_status(bio, BLK_STS_NOTSUPP);
 			return false;
 		}
+		/*
+		 * The fallback encrypts from the data pages, which a dma-buf
+		 * bio does not have.
+		 */
+		if (op_is_dmabuf(bio->bi_opf)) {
+			bio_endio_status(bio, BLK_STS_NOTSUPP);
+			return false;
+		}
 		return blk_crypto_fallback_bio_prep(bio);
 	}
 
-- 
2.43.0


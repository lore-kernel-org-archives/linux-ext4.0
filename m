Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACF942D777
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187509; cv=none; b=AiZANeF9LINfmPQwZzjGHSyulfNuBhcXwEebkWmVvi+jRTsAnyggd5jztcDrYxtnUICPRCAm/eV7vcmbaIcQ0MJLgcjZgtpMmnN+2pjShzHuY/spyCz7iWIz4jOoe+x0xkmn+UCQ/89MVlFEBLcBSZ0z6BisesBCcI3guJCBPjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187509; c=relaxed/simple;
	bh=IoTbFOZjAyf7avwQh5L6KlSkgZ9QuRnmk0lJu3wGpgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RE3qT7y5A3ztN72pK1K7YXE/MFxxjgNcU9TWBoHuMK8jwB0nu6DH5/6jKe6tRsCKGln5qku5gAK6aqAQFslWVS6+LpzYm2qKIhDmwvzeo9WYHy3P9Uxi7u3HqXBHFkqU+VHte4phLl+atX6L3NNzKA6fq5BUNlMGofo6TP2t89I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nhkxn36a; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhkxn36a"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ceaf8a1265so38586485ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187508; x=1785792308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k2+CmEJHSj+FxiNl193sQhU8qb1CcNkL+80ICC9UFKY=;
        b=nhkxn36awlXKJT/9A269oVcVrZzLYZLOFaG99l+EWdCzU/XFxDWZNblcnbfcuQnEPW
         2wMMc0y8yByldPI5gxUJFv2jjRX3pEk/0H0+KL3WEEnjn/Kpnz0g7XQOi5i1MPrwme0q
         1VKTW43/5/SfZGZYC/zGPX9PCFn8rnfJc73fKERZW6B0XtfF/LDBZN/HsvA44tHsO7Ab
         OELO+Dz1A2tEqLJhGAIH1RRvxX4hlg7NVg5NspGEsrUtb2az5+MKeIkhlRfiO0/39weF
         Aj6bI2lkx4+SZy6gjR+EbMPKsFxhs8/uVQwnhZC2nrOv9vKHA4Xy3hVHYh3uYXVKMBe1
         Uzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187508; x=1785792308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k2+CmEJHSj+FxiNl193sQhU8qb1CcNkL+80ICC9UFKY=;
        b=e1adybJN3WB0VRafI9kn5/4DCYPUK3w0IpPeKNQXBhgQOPoZD/qHEy02n9rnQJIkX2
         ZN1cKxWr67LTSBJYS8qJBClyapbyFSWmUbe3AiOYRvBHisVKbnRKgRWTqAnKQ/y+ezmn
         xpXmQRhdUWU3/jNbxqw8WIHCCPUKVMIuOTcumlCwgjYwh7ULYAD6ApHgydtSgZMLZ8mJ
         7tryQodDbsWleD9XoAa7rQfD8SN7eHUuTUu47H/hhwpESFT6QT8vSIM4RK8C85kLHeXI
         SslSyu0BfHEvKJAaAd922mwcLgFIcstYekjEVVZqtkwbdRjomMpWbgICXPc5jbzNLHRD
         j9cA==
X-Forwarded-Encrypted: i=1; AHgh+RqIZdT5TCzqKJi6cqzeULEQc/y5nLR5BiNw/WyPEYed4S4Oy6Y0SddVGJdj5xk/lSgdK9uHiOQaNBhk@vger.kernel.org
X-Gm-Message-State: AOJu0YwXyBYH+iYL7IzdJsarEWdjJVVh3HMSFBQCLE5rZY02t2nzU8HW
	wZdnYypaF8RiHelbQH2tCJu70kTByT4Bu7yFS4VKrtRqy4YL6NuDu2Uy
X-Gm-Gg: AR+sD13gRKkGNo3qCzoOzZUOs/Rxxtyu/RSBjr5bQwlYSmjTQxextuJKvoHJdNnjl2Y
	V66jlb9Jqmf392fu30yj7sE1IlSdziJzI66NsEmyWir2d7xLFlMXuidSaortDrXKYf/dapy5XrH
	Ww3ieV1+a3jnN5gJwerdBIALLo1PJR0rkPLGSiA1E4GRVLvO6cqc6jkwg+/eUrtAfO6efFaUXmI
	IG1xcYqYgwJL14YiTYXCzCi3k3VnT67aHCYOjfzml9/7rEHiJpPvhoXdRCP3umnxOiFtMYyGkZD
	GzqG6eK7uDRnxnO0hWIGYYqTxFTDEhJncy6WD4NV8twoJQ/thZxEVE0WNzLFZYfH6P2vHqhYDvO
	2Xgig4i+O1BHU8YoDERgJIlyTW7cLu4jnYnSwnGcMDq4CQrWVa4kZ0BjMQWGmWxwx2ucZc1f/9G
	vyBm38/J8b9MdfLeeOEcHOw5EKAV/ClpYzwGwAbSNfu1sD5Amy7BEIPWrSSnrosBO+
X-Received: by 2002:a17:902:e843:b0:2cc:7e4a:bcc5 with SMTP id d9443c01a7336-2d00f3e00fbmr8963385ad.32.1785187507779;
        Mon, 27 Jul 2026 14:25:07 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5c7678sm41171065ad.18.2026.07.27.14.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:25:07 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 19/21] iomap: remove ->iomap_begin()/->iomap_end() legacy path
Date: Mon, 27 Jul 2026 14:17:56 -0700
Message-ID: <20260727211758.1116539-20-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With all in-tree filesystems implementing ->iomap_next(), drop the
->iomap_begin()/->iomap_end() path.

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 6 +-----
 include/linux/iomap.h | 6 ++----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e05574602946..f7c4d5cf56be 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -107,11 +107,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	if (ops->iomap_next)
-		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
-	else
-		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-				ops->iomap_begin, ops->iomap_end);
+	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
 
 	iter->status = 0;
 	if (ret > 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index d203d9fe0f89..0bc1beb47a09 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -195,7 +195,7 @@ struct iomap_write_ops {
 };
 
 /*
- * Flags for iomap_begin / iomap_end.  No flag implies a read.
+ * Flags for iomap_next.  No flag implies a read.
  */
 #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
@@ -240,8 +240,6 @@ typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap *srcmap);
 
 struct iomap_ops {
-	iomap_iter_begin_fn iomap_begin;
-	iomap_iter_end_fn iomap_end;
 	iomap_iter_next_fn iomap_next;
 };
 
@@ -256,7 +254,7 @@ struct iomap_ops {
  *	incremental iter advance.
  * @status: Status of the most recent iteration. Zero on success or a negative
  *	errno on error.
- * @flags: Zero or more of the iomap_begin flags above.
+ * @flags: Zero or more of the iomap_next flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
  */
-- 
2.52.0


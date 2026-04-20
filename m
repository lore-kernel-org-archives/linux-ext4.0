Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF9C2C21FE
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2026 06:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776665801; cv=none; b=Erl6KDn2ShxGG93AeiZPGq2QJsb7d6OfHx6zQlOitx2F7PYi+++w2y6xmft1QOIy1LPGuaZhPQbwiE154M0sRviA0vAHbsV7DdWxNlWfcNiza7F9cMNqpJ7ive9r90tvIAF4ZiCy76mWm3Uu5Fi3fhEpblGZZDZ/jLEYBxok3dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776665801; c=relaxed/simple;
	bh=l3l5LStnrkBdnCMkbwCq/lTh+1cpa2xztmlxm2P6lrg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DMTx3RYxBlRRunz51zFG1CXz3R2Yzmx6M+jNIhXebaLEVpCZIoo8/bO9BLyxo+qLrC54iK7KSpWv/CZhgEGE9fStZAze836Q233LOfHyqzmczTNT0r1pnNacIQ6oT0WLR/05tPGykEWu8l4gaj+pft/jA43N2RL1f3FMCBWersE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LnZ4j5QA; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LnZ4j5QA"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b0afa0210bso11763825ad.2
        for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 23:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776665798; x=1777270598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sq8jVjaQsEQ037YnID8m/bdOr18FV4DJuvGfBEXqq74=;
        b=LnZ4j5QAGU9lxr4ThzR3NWilS8l0d1Wxnb87+ltQeGp4VmTGkP9gN5//CoaAKoYHHx
         XhEfKa9+5jkhV6TNEd694cXefTyv+YmpYxugD9Xwjv2RnS7ukKlYBJNDOr/UfyNlC9nD
         FuUsTjt+39epxCjHPmNEd3I/E4gXyQczOhNluibtmjKLAU9UFa786+XIk+t/AmHJNfzD
         aenFiA/2iNIXVLBnJ/gb2WyLQu/5vk/Hphz2rHR0VGQ+H877Y5ylntnby9RvMuFoNU0J
         5NiSSFzO4ZI6lgWhNOVGfjQoME97zbyDkusHX2HJh216v663dW51mL2Q03c5TnQmv38A
         6jPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776665798; x=1777270598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sq8jVjaQsEQ037YnID8m/bdOr18FV4DJuvGfBEXqq74=;
        b=goRZ99s1bmayjfckyI5JdM7Jv1zr+d1PDnA/cWVbZr5SRKlx9txCctfDTEdg+ojFMm
         EAGhfYPZAsXjx29DFaSpZQ7z+v38rdHGDSGAmkeo56BHlOr3Yt/WztXTDZ8HmU+Bh7eR
         sUQR5VIjNT0YehMDaC+7tG5Hhl6SBjWfTqtPftB/yIzh1RyS5roUa/0c1xHL1hR3/UYG
         8AikMfSvF899BkbSpsyCPL+7u91yeEBtSuYCcpEl7NUDBQ5563jeYYNQqqBejfL3P1DQ
         QeFzJZudNDknmOKxEukXANb2QmYI9JrA1GmSddSA2kphq5OVxzoMaNObMqXZSL/PAiaX
         c4kw==
X-Forwarded-Encrypted: i=1; AFNElJ9/+6YSCZHCP5tLnSN+gkMz0neEE7Y3pr5HYHwW9sbeWlzsvR8YzIyxeuoLGmmWhaFND69PqmAful1Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Yr+huzncVkaFot+m6v7B5CFT8T3zE70IZdw4o50AB0TT+oqj
	dfOH2hZo2wqSXsbQ87eyCRYmKWPLQ7tFp1AdMZmihNbjSbN/xEAwLtE3
X-Gm-Gg: AeBDievAJ8NeBNj2e8tgV/t06BfXfi/qFHBy1YrCbIB1hyc7MhuC54RX3trKSmu3WbT
	KT7bgM+ALYvXC51LRILfyGI1ZXjpl3TaGu2poWQyxWRRA4v0fmhx1AC2+8WpvskS0toevb0fZKJ
	G4pBjio5qwdo8+L3Wjy2Fh2dScIMeoX7LSDGB5sLfcLf8wu+THIFSYB02++0JnhHGocgEJyaQG4
	K35lpeQtcRRN/5fs8ZDmdpgsiJbatifbbG2pMIT4bVNCos1wjT0W5MH0Cwg9psYr9oLm7CTcAWB
	wcMu2MMb4IHTjKx2mYIWHxzjtzp6rdrd6ipi9Cn3z8wJaLYhfJT/C8Z3KX6ScAFaNI5qEaqFrNv
	sbPjP5UaCvNjymH5qmu2RUbYjDaDQ1FDax7Wb2Ovrpf7zuQE95IAw3u4DxRi10ty0fH1PZipycf
	m6wXmnLUAaiwJ4kZ5mOyMVPSlDw85v8uCOd6P4JbpCz63bhxqQW4AO7aIrha/ggH2XUQ==
X-Received: by 2002:a17:902:d590:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2b5f9e8e4a9mr122014005ad.1.1776665798486;
        Sun, 19 Apr 2026 23:16:38 -0700 (PDT)
Received: from localhost.localdomain ([2408:8740:c4ff:1::4])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2b5fa9ff8d6sm88586055ad.1.2026.04.19.23.16.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Apr 2026 23:16:37 -0700 (PDT)
From: Fengnan Chang <fengnanchang@gmail.com>
X-Google-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Cc: lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v2] iomap: avoid memset iomap when iter is done
Date: Mon, 20 Apr 2026 14:16:30 +0800
Message-Id: <20260420061630.62077-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When iomap_iter() finishes its iteration (returns <= 0), it is no longer
necessary to memset the entire iomap and srcmap structures.

In high-IOPS scenarios (like 4k randread NVMe polling with io_uring),
where the majority of I/Os complete in a single extent map, this wasted
memory write bandwidth, as the caller will just discard the iterator.
Use this command to test:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /mnt/testfile
IOPS improve about 5% on ext4 and XFS.

However, we MUST still call iomap_iter_reset_iomap() to release the
folio_batch if IOMAP_F_FOLIO_BATCH is set, otherwise we leak page
references. Therefore, split the cleanup logic: always release the
folio_batch, but skip the memset() when ret <= 0.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/iter.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c04796f6e57f..e4a29829591a 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,17 +6,13 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
-static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
+static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
 {
 	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
 		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
 	}
-
-	iter->status = 0;
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
 }
 
 /* Advance the current iterator position and decrement the remaining length */
@@ -102,10 +98,14 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 		ret = 0;
 	else
 		ret = 1;
-	iomap_iter_reset_iomap(iter);
+	iomap_iter_clean_fbatch(iter);
+	iter->status = 0;
 	if (ret <= 0)
 		return ret;
 
+	memset(&iter->iomap, 0, sizeof(iter->iomap));
+	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+
 begin:
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
-- 
2.39.5 (Apple Git-154)


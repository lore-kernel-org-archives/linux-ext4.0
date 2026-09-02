Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6B039DBC0;
	Wed,  2 Sep 2026 07:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335246; cv=none; b=Ug+JZHFHstFvKXyp3dQxVuLys19z0EI5Q/B1Xgup10qYL00Nr2Fkl76mBYYzW5+8gj5RIEp83buNqwNy2WWyGsE866QTFA1+8V+0/qHaOcf504JZbih1PnITg1jZ3CbjDE578HbUgNBaXcGubJ4nucYsbqIGLtTuUdRxTKbfMy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335246; c=relaxed/simple;
	bh=5ktFPYfcS354H0E7w1/ipjmsCACpMiKd8AYObWDY1jA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IP0JeluwnGXInDddOjYLToQlECIQ6uUbdZWBGozlgROb9KsekTS1qa8HML0pOfx2AcbJTKhx92nC0ugh8EhZ3xkVpVoK60HuvQT1nSpW6PEuQj662xS8qbx1sBZoiEkQiTxumWRyJemXRQHCr9aecx1Td6NgG5yWB3P9vtf0CoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rd6Hz3E3; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="rd6Hz3E3"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ao1UDWuDYQRsk9bPKBFmaIKKn4znhhepOdHzIjS7dcs=;
	b=rd6Hz3E3kFFODcc4/kGIU6WQ3O/MF2UNzG8fGv3DfTk1xxbkr5JYxWMHti/CESfAv3QlowOiF
	KpxM7VUaBOOrPoiBFse4b4RNYjhXKbaL61GTXDs/kAXRoMmBSTF1OOw+4B8ofiUSWzJ9cBthC5e
	jq57PsmyzIUaJsuBshV91U0=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hZZKh5zbvzKmB5;
	Wed,  2 Sep 2026 15:36:24 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 789C64056C;
	Wed,  2 Sep 2026 15:47:18 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 2 Sep
 2026 15:47:17 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <bcrl@kvack.org>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<akpm@linux-foundation.org>, <pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <kees@kernel.org>, <tglx@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 3/8] fs: aio: Use acquire/release for ring->tail publication
Date: Wed, 2 Sep 2026 15:48:00 +0800
Message-ID: <20260902074805.398540-4-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260902074805.398540-1-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500011.china.huawei.com (7.185.36.131)

Replace the smp_wmb() + WRITE_ONCE(ring->tail) and READ_ONCE(ring->tail)
+ smp_rmb() barrier pair with smp_store_release()/smp_load_acquire()
on `ring->tail`.

This expresses the publish/subscribe pattern more clearly and allows
architectures with native acquire/release instructions (e.g. arm64's
STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).

The release ensures event data written before updating ring->tail is
visible to readers that observe the new tail value via acquire, which
is exactly the ordering the barrier pair provided.

No functional change intended.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/aio.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index d78acc69f487..a0279e059e97 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1206,13 +1206,12 @@ static void aio_complete(struct aio_kiocb *iocb)
 	/* after flagging the request as done, we
 	 * must never even look at it again
 	 */
-	smp_wmb();	/* make event visible before updating tail */
-
 	ctx->tail = tail;
 
 	ring = folio_address(ctx->ring_folios[0]);
 	head = ring->head;
-	ring->tail = tail;
+	/* Make event visible before updating tail */
+	smp_store_release(&ring->tail, tail);
 	flush_dcache_folio(ctx->ring_folios[0]);
 
 	ctx->completed_events++;
@@ -1288,13 +1287,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	/* Access to ->ring_folios here is protected by ctx->ring_lock. */
 	ring = folio_address(ctx->ring_folios[0]);
 	head = ring->head;
-	tail = ring->tail;
-
 	/*
 	 * Ensure that once we've read the current tail pointer, that
 	 * we also see the events that were stored up to the tail.
+	 * Pairs with smp_store_release() in aio_complete().
 	 */
-	smp_rmb();
+	tail = smp_load_acquire(&ring->tail);
 
 	pr_debug("h%u t%u m%u\n", head, tail, ctx->nr_events);
 
-- 
2.34.1


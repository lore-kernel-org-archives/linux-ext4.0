Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC98418344;
	Tue,  1 Sep 2026 02:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230537; cv=none; b=Xz143lHm0yj3Gn947/JeyF/+tSaISNC0w3ggLc8yhPqgKSqq4PHAhTAb2zqqplDcM97tCNlY6NeZp57isHb9x/N/2AvkBLbFpcNZCq26Y5A4GGi8UHLU6RTzcZicG6hqu9Uh94uANPT7fO6UAE4HYIlB7RaG/2QzhuB+d0wlfbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230537; c=relaxed/simple;
	bh=5ktFPYfcS354H0E7w1/ipjmsCACpMiKd8AYObWDY1jA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T8FseHwatGDvOM+TfL+5i/N+EvVJb2ZB2i+e3IlWtjcMPDZm3T1OGj56A8AM1U54kTB19Ay2WwU4UnuxVUKKM5MVijWneM6q0zApI9ZVn+7OBHdOwcIovU4G8HEMEkYo3fx3uAvfScw0+sZhE7SEhTwrRvTo7/0xfSuHk3EUwik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rd6Hz3E3; arc=none smtp.client-ip=113.46.200.220
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
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hYqbR2P5Lz12LHk;
	Tue,  1 Sep 2026 10:30:43 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 5359340561;
	Tue,  1 Sep 2026 10:42:00 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:41:58 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<ruanjinjie@huawei.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH v2 03/12] fs: aio: Use acquire/release for ring->tail publication
Date: Tue, 1 Sep 2026 10:42:25 +0800
Message-ID: <20260901024234.135119-4-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260901024234.135119-1-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
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


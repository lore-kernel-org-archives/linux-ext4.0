Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADDE3DEACE;
	Tue, 25 Aug 2026 09:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651633; cv=none; b=iuXsU+5bdonXDPPyTflo/+AuCHbgEUJrw4xjh8GSSSZfx/LdJlL1FDbjRva+Th0eacKWio7bwzOh9MlSzEL+yczC/v3ZobJ2WIjut1iLlf3zlBNHTKFgijM+bnxqHvYbuN78DFl7Ikp6UhN07EaeGbOB0ZsFvbg7qFjpa4x8rKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651633; c=relaxed/simple;
	bh=HJdsCfuTtgmJ6PKzFdH/Ql52/qu8azKPMmn8T3cfFTk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHqkuMKmGgispobLFjl9AQilidxT8JxI89fSDFkMvVNXMsLahLQIe3X7mvIXAFUwOc8Cq1hgtqfntz9bnxQHiQ2nGID5bhO1+4wurIvAcC39YzjfGhEgTnUlX+b2fKhIh9Lb7fw7p9ng4twN4PbmW1dj2fCDI/B1L2QAnNMbYFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=sPInjYYs; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="sPInjYYs"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GUcokWdXQpThxiBAOIvnrP9/uDHhISaOf9TGAkhrHoo=;
	b=sPInjYYsXpWPlcSR4ME70cbHDD2P9opcLcsxc/8waXz8hX+c849a/0avJT0EzLUdl8A1E7Lf9
	lhCiXdLpuMSpQuW38UUpzcF7YJGPYKPVEj1nKS6B6cmFDHab0Ag3Z9amI/Lq4goXJ1o1ZxVkkNW
	ZUx95EK94yHIQsP3leuZYZA=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWL1zBXzKm5m;
	Tue, 25 Aug 2026 17:42:54 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id EE88D40565;
	Tue, 25 Aug 2026 17:53:42 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:40 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>,
	<akpm@linux-foundation.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <horms@kernel.org>,
	<socketcan@hartkopp.net>, <mkl@pengutronix.de>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<liuhangbin@gmail.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH 01/11] user_namespace: Use acquire/release for nr_extents synchronization
Date: Tue, 25 Aug 2026 17:54:12 +0800
Message-ID: <20260825095422.3166067-2-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825095422.3166067-1-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
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

Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
when publishing and consuming `nr_extents`. This expresses the
publish/subscribe pattern more clearly and allows architectures with
native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
the cost of full one-way barriers (DMB ISHST/ISHLD).

No functional change intended.

Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 kernel/user_namespace.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 0bed462e9b2a..576b667a8813 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -317,9 +317,9 @@ map_id_range_down_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 co
 
 static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
 {
+	/* Pairs with smp_store_release() in map_write(). */
+	unsigned int extents = smp_load_acquire(&map->nr_extents);
 	struct uid_gid_extent *extent;
-	unsigned extents = map->nr_extents;
-	smp_rmb();
 
 	if (extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
 		extent = map_id_range_down_base(extents, map, id, count);
@@ -383,9 +383,9 @@ map_id_range_up_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count
 
 u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
 {
+	/* Pairs with smp_store_release() in map_write(). */
+	unsigned int extents = smp_load_acquire(&map->nr_extents);
 	struct uid_gid_extent *extent;
-	unsigned extents = map->nr_extents;
-	smp_rmb();
 
 	if (extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
 		extent = map_id_range_up_base(extents, map, id, count);
@@ -676,9 +676,9 @@ static int projid_m_show(struct seq_file *seq, void *v)
 static void *m_start(struct seq_file *seq, loff_t *ppos,
 		     struct uid_gid_map *map)
 {
+	/* Pairs with smp_store_release() in map_write(). */
+	unsigned int extents = smp_load_acquire(&map->nr_extents);
 	loff_t pos = *ppos;
-	unsigned extents = map->nr_extents;
-	smp_rmb();
 
 	if (pos >= extents)
 		return NULL;
@@ -967,9 +967,11 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 * desired behavior is to see the values of the extents that
 	 * were written before the count of the extents.
 	 *
-	 * To achieve this smp_wmb() is used on guarantee the write
-	 * order and smp_rmb() is guaranteed that we don't have crazy
-	 * architectures returning stale data.
+	 * The nr_extents field is the publish point for the extent
+	 * data.  Writers use smp_store_release() to ensure all extent
+	 * data is visible before nr_extents is updated.  Readers use
+	 * smp_load_acquire() to ensure they see a consistent view of
+	 * the extent data when reading nr_extents.
 	 */
 	mutex_lock(&userns_state_mutex);
 
@@ -1098,8 +1100,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 		map->forward = new_map.forward;
 		map->reverse = new_map.reverse;
 	}
-	smp_wmb();
-	map->nr_extents = new_map.nr_extents;
+	/* Pairs with smp_load_acquire() in map_id_range_{up,down}() and m_start(). */
+	smp_store_release(&map->nr_extents, new_map.nr_extents);
 
 	*ppos = count;
 	ret = count;
-- 
2.34.1


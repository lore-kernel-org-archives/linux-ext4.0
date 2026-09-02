Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE03363C43;
	Wed,  2 Sep 2026 07:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335245; cv=none; b=RBlkqi6ieXbRpCObBphVYNEYanjAOg6ly9JG9rXbKm4hYgZLIb7s20ecO1NUrbftG00v7D9og0Jragr9KdruYKBzVS9VtbYYKhoqclfiFMUrCLc8ghM0i0vSV0j6n9exzCUK3WDbnfA4xwrhVDpg6cCyUCDmsLUVLcTGP9squNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335245; c=relaxed/simple;
	bh=2ExYMYQOFQQPwIyWmmjRnsN6d7J+Qq6kfNRhJ1FSOCA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QnLwb0n3NH4tNHW/Zi0frlDq7QzlGNYhfQaB4X22bZ9v98Bg3ydZI6sh6vgQP5ckZvkVxE8tSXS57nF6yO7WFOkg8cZDlk4QHMjW/tRcoDFDGLXqL+yAf7OBiuKlPgC0wTzrO9v3zcavMgCKJhSjbUGhpz/qwgAq0NwysassCCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QudGLxf2; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QudGLxf2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qoAjlya8M+d7R8ZbBFu376QlGU7wsKKm9VDsrz6PzLY=;
	b=QudGLxf2IG1POpNF4FFFGKzpzwPRL7qNIYEKL0+9CPKFxIxW33aq8Jn68fLZYj7bL/Md8ZiDc
	W5Xl4K1EEhYjoYTS9KPDYrZlYJWVFH6FO5HA2eWCMlIm6pD9G0keSgwEjFnxcb9Kjz6enEvDbDq
	8hEA3ehvZox4Ef8AKLOz1pc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hZZKh12Bqz1prLc;
	Wed,  2 Sep 2026 15:36:24 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id D23904057D;
	Wed,  2 Sep 2026 15:47:15 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 2 Sep
 2026 15:47:14 +0800
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
Subject: [PATCH v3 1/8] user_namespace: Use acquire/release for nr_extents synchronization
Date: Wed, 2 Sep 2026 15:47:58 +0800
Message-ID: <20260902074805.398540-2-ruanjinjie@huawei.com>
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

Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
when publishing and consuming `nr_extents`. This expresses the
publish/subscribe pattern more clearly and allows architectures with
native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
the cost of full one-way barriers (DMB ISHST/ISHLD).

No functional change intended.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Seth Forshee <sforshee@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
v2:
- Add missing load replace in copy_mnt_idmap()
---
 fs/mnt_idmapping.c      |  5 ++---
 kernel/user_namespace.c | 24 +++++++++++++-----------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
index cb61fbdb52e9..612b266ab3da 100644
--- a/fs/mnt_idmapping.c
+++ b/fs/mnt_idmapping.c
@@ -219,10 +219,9 @@ EXPORT_SYMBOL_GPL(vfsgid_in_group_p);
 static int copy_mnt_idmap(struct uid_gid_map *map_from,
 			  struct uid_gid_map *map_to)
 {
+	/* Pairs with smp_store_release() in map_write(). */
+	u32 nr_extents = smp_load_acquire(&map_from->nr_extents);
 	struct uid_gid_extent *forward, *reverse;
-	u32 nr_extents = READ_ONCE(map_from->nr_extents);
-	/* Pairs with smp_wmb() when writing the idmapping. */
-	smp_rmb();
 
 	/*
 	 * Don't blindly copy @map_to into @map_from if nr_extents is
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


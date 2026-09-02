Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDE13EB802;
	Wed,  2 Sep 2026 07:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335253; cv=none; b=roAiZs7dOOxeNyw6kYJfmLucVaxpImoxhMdrThJMnN56aQt3c9xoG4iVldarH8LJx+KnXAnB9nl5XYOjZftW90vrAVd2NztPq0nsmNO5SxBlnzHzyJU4pt4GdCnCFS2rYEWM7DXMYLMh4D1KNs9AuX73XvivENwR+QxvsApNhXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335253; c=relaxed/simple;
	bh=pr8WYR44iKCxKBl4J9dalj2VKHZhweH74fIWZSRuaTg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SNE6wKM8IbMTwxefLba1VYrNtgEv8As5AlBEmaeYbI1HbOjzKnNfrLAW3ZL9KOHoMmbK/7GXNfgieS4jcgX0wGpUmZQshNrfp7hgc9MZxwIjupHwoZWUCla6JPDpw8t/8o6gD6gOYTQWMr4NAXQI3Xu01vJqKOvT0v36EkoF54I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4W7L8+ru; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4W7L8+ru"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Iz5MYVXCtGLbTQgpICYK+HoBlz0f/WG3AORXFegzuUU=;
	b=4W7L8+ruHXC9nGqv3nMwB57tXKGaky+xpzhxYsNGkZ4cP5xbDWWe35JEBTMqZKiybwsZZHpCf
	H0HhRoNDRW/6WEPqU4KbeOZ7r/n7rXbuDkaIquGOqPPunkejZkMu/fRTAE7/87lbkC7768wXSGy
	q/dnTls+drI7e6ztdPwQUQo=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hZZKs2h2kzmVY2;
	Wed,  2 Sep 2026 15:36:33 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E57140573;
	Wed,  2 Sep 2026 15:47:23 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 2 Sep
 2026 15:47:22 +0800
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
Subject: [PATCH v3 7/8] ext4: Fix out-of-bounds read in ext4_get_group_info()
Date: Wed, 2 Sep 2026 15:48:04 +0800
Message-ID: <20260902074805.398540-8-ruanjinjie@huawei.com>
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

A plain read of s_groups_count in ext4_get_group_info() allows CPU
load-load reordering. On weak memory models, speculative prefetch of
s_group_info prior to the boundary check could lead to an out-of-bounds
read if a concurrent online resize expands the array and increments
s_groups_count.

The data race occurs between the ioctl configuration path (holding the
resize lock via ext4_resize_begin) and the lockless metadata lookup path:

   CPU 0 (Writer, Resize Lock)                CPU 1 (Reader, Lockless)
   ---------------------------                ------------------------
   ext4_ioctl()
     [EXT4_IOC_GROUP_ADD]
     ext4_ioctl_group_add()
       ext4_resize_begin() // Takes lock
       ext4_group_add()
         ext4_mb_alloc_groupinfo()
           // Publishes expanded array via RCU
           rcu_assign_pointer(s_group_info, ...)

         ext4_flex_group_add()
           ext4_update_super()
                                              ext4_get_group_info()
                                                // Speculative / out-of-order read
                                                [Loads old/smaller s_group_info pointer]
             [Plain C store / smp_wmb()]
             sbi->s_groups_count += ...;
                                                // Reads new s_groups_count,
                                                // boundary check passes
                                                if (group >= s_groups_count)

                                                // Out-of-bounds array access!
                                                sbi_array_rcu_deref(..., s_group_info)

Fix this by using ext4_get_groups_count() to enforce acquire semantics.

Cc: stable@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Baokun Li <libaokun@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/ext4/balloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 52f4c5169f91..778fe8788f06 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -329,7 +329,7 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 	struct ext4_group_info **grp_info;
 	long indexv, indexh;
 
-	if (unlikely(group >= EXT4_SB(sb)->s_groups_count))
+	if (unlikely(group >= ext4_get_groups_count(sb)))
 		return NULL;
 	if (unlikely(!EXT4_SB(sb)->s_group_info))
 		return NULL;
-- 
2.34.1


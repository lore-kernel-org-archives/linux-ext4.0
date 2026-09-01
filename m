Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CDE42E40F;
	Tue,  1 Sep 2026 02:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230540; cv=none; b=fW8Eg1K9qDpN1m25x+8r6XpXa18Y75lhN1zcdhrLbUptfEX0oBE5y2I/5s4LqBzesDhErCUh4jkHnZJ5+lc9NlgmQf8A4QAcZolkEfbniaf29UNXegbsnFGcoKeu9t1eDc76m8yx8MX8cY2zkx7ULtSl62rCmHhzysfri21nBOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230540; c=relaxed/simple;
	bh=mRu+8oI+8yejYmM5U0IYS4f9ZssaZfdqnhX1pgozqEk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sP0To4ba8Npd4jwAGO4QQbm+Y9wB3akgp5RZhTTovl23O+X8S7ad1f0g+9oxcUJq3R278EjhLzbUERuApfgAD/PqLXYfjvSrA5lyHzewsdh1WT0h1euPW84AAxRg6k/84HjKd6dQdCsXxa6+F3RJ9NVfgCCeU4bnknLmaqerF/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=W5vBb9vC; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="W5vBb9vC"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KKEbfOeCLbOOAhU6UgBfdVrcmR/XEEwU6rZUBbIzUo4=;
	b=W5vBb9vC2vK/dr1W84GGMw8wT2SAhPGYXZBM7i3KKuiyeIFwMYrTND+SAvYviuEUw6E5on1IP
	9raRX2qScminjENq+dSm4Xp5jJbaGAiJeXHxX2/ZySZkJSYl/5qepR/CtSL2YWYSdB2EvhzQycD
	77jndysTvDI2xvAtaB0rTcc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hYqc31LKfz1prl2;
	Tue,  1 Sep 2026 10:31:15 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C76C202E6;
	Tue,  1 Sep 2026 10:42:06 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:42:04 +0800
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
Subject: [PATCH v2 07/12] ext4: Fix out-of-bounds read in ext4_get_group_info()
Date: Tue, 1 Sep 2026 10:42:29 +0800
Message-ID: <20260901024234.135119-8-ruanjinjie@huawei.com>
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


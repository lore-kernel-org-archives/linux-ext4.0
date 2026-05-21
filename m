Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E5345CAB;
	Thu, 21 May 2026 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779349739; cv=none; b=E4MnXizlEX7Z7sXV2p1bRncjAfTuvIm9agVWaU0RMcuTilv2EhKfxfuT39ByzB9cuwtPdYBLbWa28E82W/4ndv7Icn6yssH2kelNxm0wO+YYv4L6TT5a0xDTr1ey/y5WXIfUTKVqAQgJLp4TujH0aVrPUnAdcNyc0BKaPs06qwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779349739; c=relaxed/simple;
	bh=88QaD7LacvfLo435VtTcRVx2Nux6dLm+qmjnX2A4RTs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PrwxZByv9FbcMt25/HXqxC8J9cjicVFi4w/AAsYSsOzGzcCAW8C9ieDJ4NKFHd9lRuYAG8IWk8cC8CGlK3DLnicFJV1ystn4+RZnqEdN0JHFtwQauWpvXn4hn3B05Hhp/PyEw2GRHyaiNq9moU9AwIyf5TFRKD6H2iHFaRWp/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=baBJEb4U; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="baBJEb4U"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin
 Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, Zhang
 Yi <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] ext4: convert legacy ext4_debug() to standard pr_debug()
Date: Thu, 21 May 2026 03:46:34 -0400
Message-ID: <20260521074634.2697-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc2.internal.baidu.com (172.31.3.12) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1779349604;
	bh=yoKBsdvQbrSmJ0uD5XEfzFLRBhavwkWq2U3T/ak7jS8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=baBJEb4UAF0hqCnyMIYuycdlzv3u0flubu6ZV5KCS79aNaa/0iW9tExrVtj5gXkc8
	 yamr5+nrp56my2rEAaM9Q12I31pLBWGfvyeOU9Vn4Qj/kBaLNzBj5wQrtqjb3Ykq2g
	 VJj2vKuaKyfhNujJdrjyNTf2E0QmSj97qydpCySQ3BrbRKFsd0dJSnz3aobJ5rkkLX
	 /lyIaAlBTY6v3SzCRKSNHDr8CYAl1jkLPG3HO9qSH1SjbJr2GY1il/C45L1EE41GVo
	 Rd7v4kb2b1nhNvWzpZibbpKeA6i5XDABEV8HafrUdBOwEFHb7TFkxFcSTocYsNLE93
	 Nb7CayelWG3+g==

From: Li RongQing <lirongqing@baidu.com>

The ext4 file system historically implemented its own debug logging macro
ext4_debug() via EXT4FS_DEBUG conditional compilation. This legacy
implementation suffers from two major drawbacks:

1. It makes two consecutive un-serialized printk() calls, which can
   lead to severe log interleaving and corruption under multi-core
   concurrent workloads.
2. It completely bypasses the standard modern kernel dynamic debug
   (CONFIG_DYNAMIC_DEBUG) infrastructure.

Clean up the legacy implementation by leveraging pr_debug(). This squashes
the multiple printk() calls into a single atomic execution, ensuring
log integrity, while seamlessly hooking ext4 into the kernel's native
dynamic debug framework.

The redundant __FILE__ and __LINE__ macros are intentionally removed from
the string format because the dynamic debug infrastructure can already
append them automatically at runtime (via the '+fl' flags) if desired.
This avoids redundancy and double-logging in modern production/debugging
environments while keeping the macro clean and robust against dangling
comma compiler errors.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 fs/ext4/ext4.h | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a9..39e86ff 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -62,24 +62,8 @@
  */
 #define DOUBLE_CHECK__
 
-/*
- * Define EXT4FS_DEBUG to produce debug messages
- */
-#undef EXT4FS_DEBUG
-
-/*
- * Debug code
- */
-#ifdef EXT4FS_DEBUG
-#define ext4_debug(f, a...)						\
-	do {								\
-		printk(KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",	\
-			__FILE__, __LINE__, __func__);			\
-		printk(KERN_DEBUG f, ## a);				\
-	} while (0)
-#else
-#define ext4_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
-#endif
+#define ext4_debug(fmt, ...)						\
+	pr_debug("EXT4-fs DEBUG %s: " fmt, __func__,  ##__VA_ARGS__)
 
  /*
   * Turn on EXT_DEBUG to enable ext4_ext_show_path/leaf/move in extents.c
-- 
2.9.4


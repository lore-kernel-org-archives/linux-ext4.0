Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EFB3B9DB6
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147959; cv=none; b=IMmOxBZsV4JTUxivV0iOxwkod50sxPrMXIA9ZcZm8aYF0DRQ4HbDRQlBmSqoHjzETfiExr9PkVFggs4W5rYLY3C0/mX1NvTgnBBLfloz1JO2HBIGIE/XaMXRvOPBN1Wdt8sWdhtSy2xQQOJNmkC3rY700NpvRNj01nmvPfe/R+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147959; c=relaxed/simple;
	bh=InyXciXjxh4XoQoDPiUsNY/XZg3cJlKGqvVlUYa/VTI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hbkZyzUodtHs5DYbFG7v8XR5pDuLHmhvAEmbFEEHZId1htbkITipRYajvLNMfCCykOYgYt46dlwT/vU7wfew8xYwFzzPs7AYf7qklquOOVs/QgxGGHMB1ca63VEPd0J32esFtqqYono7dsLooklvzqkKoxUIPrR2RrTUsjTmLGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVYys2DvDzKHMh4
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 98EB240590
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUwxF7BpaX6fAQ--.37695S6;
	Tue, 10 Mar 2026 21:05:56 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH -next 2/8] ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
Date: Tue, 10 Mar 2026 21:04:06 +0800
Message-Id: <20260310130412.3156753-3-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310130412.3156753-1-yebin@huaweicloud.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYUwxF7BpaX6fAQ--.37695S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJr13XrW5WrWUAryxGw4UArb_yoW8JFyxpw
	sIyF4xGrWa9345u3y7GF1kX347Wws2g3W8Jw4F93y5XF9xXryfGFn8twn0vF1jga97XF4f
	XFy8ZF15Jr1fCa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUzMKuUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper for kuint test.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/ext4.h    | 5 +++++
 fs/ext4/mballoc.c | 3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4cb2345339ba..8bf2a2ac4787 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3945,6 +3945,11 @@ static inline bool ext4_inode_can_atomic_write(struct inode *inode)
 extern int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 				  loff_t pos, unsigned len,
 				  get_block_t *get_block);
+
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+#define EXPORT_SYMBOL_FOR_EXT4_TEST(sym) \
+	EXPORT_SYMBOL_FOR_MODULES(sym, "ext4-test")
+#endif
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 842a604ae5db..97b3f0e4c80b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -7193,9 +7193,6 @@ ext4_mballoc_query_range(
 }
 
 #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
-#define EXPORT_SYMBOL_FOR_EXT4_TEST(sym) \
-	EXPORT_SYMBOL_FOR_MODULES(sym, "ext4-test")
-
 void mb_clear_bits_test(void *bm, int cur, int len)
 {
 	 mb_clear_bits(bm, cur, len);
-- 
2.34.1


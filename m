Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CFE3C5DCA
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773321290; cv=none; b=sISwuCmoUM3NB2uRiw1wBD3xK5/8FOzNpTDiX5FktvgfZf4ZzfFOS1nu/O2It77w0zkCHQIq4mQA2Dj3cPGUKFpdZQlMAO7Ki66iYgyLaK1JtKH1YaRVuYCxNAzD5fwLwYikRgkrdLFO1Z/0XEPUrAel4HRZNZUZTMbRuUl2FMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773321290; c=relaxed/simple;
	bh=InyXciXjxh4XoQoDPiUsNY/XZg3cJlKGqvVlUYa/VTI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FsKRhZV0SN/LlZILfxA9L/ld0GkceztUI/sLukYXyBKyMVu0JVFwXoPdElGShxYwUotQNNweS9w6gs40l4dR0N8lGHT6xIkXhIdW/tsColC9YSIB3nXjs+aCOrEnNtFmcWj+1MFWOKODf+Ng4CRbdC8lXNAT34DR0mSfC/b2b3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fWp3K5n0TzYQv6Z
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:13:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F3B9440573
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:14:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_Ug8vLJpGVeVAg--.45112S6;
	Thu, 12 Mar 2026 21:14:38 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 2/8] ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
Date: Thu, 12 Mar 2026 21:12:47 +0800
Message-Id: <20260312131253.366296-3-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312131253.366296-1-yebin@huaweicloud.com>
References: <20260312131253.366296-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_Ug8vLJpGVeVAg--.45112S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJr13XrW5WrWUAryxGw4UArb_yoW8JFyxpw
	sIyF4xGrWa9345u3y7GF1kX347Wws2g3W8Jw4F93y5XF9xXryfGFn8twn0vF1jga97XF4f
	XFy8ZF15Jr1fCa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
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


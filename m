Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC5C1A3172
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474888; cv=none; b=UK56uFXbCEwCngqtMdwzCN9pp46JR9Zliap+k3ZeqmjR6c2xX8DxtHTkBhfUb3G9MWa9YLJfcEOUP2+nlVH9z73mH3RmdT5wNCWF7qX1qFkBRj0m+WK8lT8Nn2lka/R36FVUaFFW/AQf06aMhCh33jKteR5pHj7B7vC3C1nSU0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474888; c=relaxed/simple;
	bh=JaWT+6gxz6hM+IZHM1pB8Rv8BgUUOlxoh4w8YPWuK4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GEdROK6/lIsF3eZNRiltIPPI8UA0VpB8MnKAKcHAXc3NqubvDyjdDp0uBmTwMlqnaWXcq6wMPqo4LQ+1aX7NkkynAhear/Ow+9o9nyK8iamFweHY+LHNUIgpiQivX3+Z2g7Rlw0NCI21v8Tr3rj7H7LSgNHoAD3NpqDpptJVbS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fXtsD3s3VzYQtxG
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:53:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B86934058F
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:54:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhEFLVpFaZvAw--.31331S5;
	Sat, 14 Mar 2026 15:54:44 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 1/3] ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
Date: Sat, 14 Mar 2026 15:52:56 +0800
Message-Id: <20260314075258.1317579-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260314075258.1317579-1-yebin@huaweicloud.com>
References: <20260314075258.1317579-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_UhEFLVpFaZvAw--.31331S5
X-Coremail-Antispam: 1UD129KBjvdXoWrZFWUGryfWw47WFy7Gr43Awb_yoW3Zrc_t3
	srAFW8WF9aqrySga10kw1aqF1rKw4Fyr1Yg392grn8Zw4YqFWvy3srt3sxCrs09a15uFWU
	Ary2yry5JFWxZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbsAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M2
	8IrcIa0xkI8VCY1x0267AKxVWUXVWUCwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F
	4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
	6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7IUbdMa5UUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper for kuint test.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/ext4.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9552d154ea8d..b60b334b7693 100644
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
-- 
2.34.1


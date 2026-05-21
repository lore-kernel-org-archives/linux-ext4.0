Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A1538B131;
	Thu, 21 May 2026 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=14.137.139.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368552; cv=none; b=kIUQx8OdW405M6AS8sLLdilhRjUTEqzi3PVk+sQA/FNGR08Tj0f3OfV80uyWApDgIwaTG5qyYgAgMPhs1z+Bj8wvZoTYS29JBol2IYN0v8pwN+xxezI0qXtUswnEiGl3jyEBClx8NvfTfZG96zYFff5wIEdQkrVWvzv+7Mpx7qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368552; c=relaxed/simple;
	bh=8dFADbeO7x2P1yjz9pMDpcJX2ggAUeNyOM28onDcmpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLqv8mQJsM5Cvfy8Z2M9MdAVVfSilM5Zh/EMfvquPWj267a0a5uInzprIMDryg/R4R3VBmAvBQB1pnXdX9W1l9ZQUyVed/YfIu7CAX+1ClzD+ai1hP1NfdiAkOw7Zv9Txlisk5FyXSVVHAormBKr+Ja5KanZLldQQaiOornifgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=14.137.139.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.18.224.235])
	by frasgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gLpN90y3wz1HCj5;
	Thu, 21 May 2026 20:57:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.27])
	by mail.maildlp.com (Postfix) with ESMTP id 3F42C4056C;
	Thu, 21 May 2026 21:02:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.224.106.87])
	by APP2 (Coremail) with SMTP id GxC2BwBXm2dJAg9qEcSQAQ--.61947S3;
	Thu, 21 May 2026 14:02:27 +0100 (CET)
From: Bohdan Trach <bohdan.trach@huaweicloud.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: mchehab+huawei@kernel.org,
	lilith.oberhauser@huawei.com,
	Bohdan Trach <bohdan.trach@huaweicloud.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ext4: avoid RWM atomic in EXT4_MB_GRP_TEST_AND_SET_READ
Date: Thu, 21 May 2026 14:59:28 +0200
Message-ID: <20260521125931.16474-2-bohdan.trach@huaweicloud.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260521125931.16474-1-bohdan.trach@huaweicloud.com>
References: <20260521125931.16474-1-bohdan.trach@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:GxC2BwBXm2dJAg9qEcSQAQ--.61947S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr4kZFWfKryDKw4xZFW3GFg_yoW8Wry3pr
	ZrJryYkr1aqFnxu3y7W3y8A3Zxtw4xCw45Gry7Ww45WasxKrnYqF98KFyYyFnYkFZ7Xw4a
	9FWYk348uFyqkrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUjrHUDUUUUU==
X-CM-SenderInfo: xerkvtvqow2ttfk6x35dzhxuhorxvhhfrp/

EXT4_MB_GRP_TEST_AND_SET_READ uses test_and_set_bit function which
issues an atomic write. This can cause high overhead due to cache
contention when multiple threads iterate over groups in a tight loop,
as is the case for ext4_mb_prefetch(). We have seen this to be a
problem for Kunpeng 920b CPUs which uses a single ARM LSE instruction
for this purpose.

This change significantly reduces costs of fallocate() operations which
trigger linear group scans on large multicore machines where
test_and_set_bit issues an atomic write operation unconditionally.

Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>
---
 fs/ext4/ext4.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 56b82d4a15d7..0713207811a6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3551,7 +3551,17 @@ struct ext4_group_info {
 #define EXT4_MB_GRP_CLEAR_TRIMMED(grp)	\
 	(clear_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
 #define EXT4_MB_GRP_TEST_AND_SET_READ(grp)	\
-	(test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &((grp)->bb_state)))
+	(ext4_mb_grp_test_and_set_read((grp)))
+
+static inline int ext4_mb_grp_test_and_set_read(struct ext4_group_info *grp)
+{
+	int r = test_bit_acquire(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state);
+
+	if (!r)
+		return test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state);
+	else
+		return r;
+}
 
 #define EXT4_MAX_CONTENTION		8
 #define EXT4_CONTENTION_THRESHOLD	2
-- 
2.43.0


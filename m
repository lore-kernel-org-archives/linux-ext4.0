Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66D261388
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474654; cv=none; b=NlldssLxXeirHXmWEO0E7iOcBv8yHFUdP1hbjC8e+Xse7X+N3XGZ69qKdOKUanXibH2bV0eRGc0OFXy2tKRh1YRpcYyj2FhDqLRfneocbFydOo9yJK9CmWRMamp+61vYlOd4rerF13X71UNg+NEX5Ryl+2ltBafFBlz/H842YSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474654; c=relaxed/simple;
	bh=jG+EQPwjTfYEx9Mz69/4QZkBee6g6+wHHrWBzeqWimw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e25LQPKw9tu8615Pzon08QH19ij79WM9aEnRVdFZI2cFm+X6ehZ5WhRahtzqQ4afveWWS0pzZ/li/6frNziriyf3NN9zBZoohLMaq/myuIeJ5PlPYHeQzXUfLem7kC6H29/TKYmyx9NuhvSR/NA9l1Y9QiCcTrJu/Ku8Gr/p+ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fXtnK2MHszKHMc2
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 850814056E
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhZE7Vpm1BvAw--.31250S5;
	Sat, 14 Mar 2026 15:50:50 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v3 1/5] ext4: call deactivate_super() in extents_kunit_exit()
Date: Sat, 14 Mar 2026 15:48:59 +0800
Message-Id: <20260314074903.1314851-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260314074903.1314851-1-yebin@huaweicloud.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_UhZE7Vpm1BvAw--.31250S5
X-Coremail-Antispam: 1UD129KBjvdXoWruFWUuF4ktF48CrW3KFyxGrg_yoW3Arb_Aa
	47Cr1kGr4ayr18u3WrAryUX3WIka1xKr1fXFy3CFykua4fXr4kJrnFgrn3Zry5Crs8C3sr
	JrsxKr109Fy09jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbsAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M2
	8IrcIa0xkI8VCY1x0267AKxVWUXVWUCwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F
	4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
	6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7IU14CJJUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Call deactivate_super() is called in extents_kunit_exit() to cleanup
the file system resource.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/extents-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 5496b2c8e2cd..e3d23e3cda87 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -146,6 +146,7 @@ static void extents_kunit_exit(struct kunit *test)
 	struct ext4_sb_info *sbi = sb->s_fs_info;
 
 	ext4_es_unregister_shrinker(sbi);
+	deactivate_super(sbi->s_sb);
 	kfree(sbi);
 	kfree(k_ctx.k_ei);
 	kfree(k_ctx.k_data);
-- 
2.34.1


Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6702D7D2E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 13:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773321286; cv=none; b=cnPoUl9FdBlRN9tzRAp8mA2bEhBLA9r7xdGGwuStQhC+5Bxn1Hoau/cWlk1U3u2gsvCsv9HvYwKciNV2F2YgrLMPHF5lW6HsYl0PqiVhf1mhWIIM7JDi1PMYCiOWHCRvBV7fq7MMqsg4Cow4i+NeWBdp504IPeH7bGgKEH0WagE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773321286; c=relaxed/simple;
	bh=v6kGDTZotAAMqATYKCCTty6Nft+cWnhpOZv8xvGsqB8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eormTtFp5uxYm0xc+uHbKLifiZrVWKvLcvTh1EDz0iafPnKM5UB2yOd4YUeI5FxHJQQxtXpmCg46rxL82kN5MaMnggHlrwbJjNuEwuFT51+u7XMBMxNye3VsVKOgFR4pZ8H3KLCb6tPDUe331ON1TL6qIKQNxNxYAiXx3RtGbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fWp3v0g0bzKHMmL
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:14:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 805AE40576
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:14:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_Ug8vLJpGVeVAg--.45112S4;
	Thu, 12 Mar 2026 21:14:37 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 0/8] Fix some issues about ext4-test
Date: Thu, 12 Mar 2026 21:12:45 +0800
Message-Id: <20260312131253.366296-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_Ug8vLJpGVeVAg--.45112S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WF4xuF17KFykCrWxJrWfAFb_yoW8GF18pw
	13AFsIgr45Zrn3ZFZxGa1UAw15Wr1kAwsrZry3t3W8Xa43AryrGrsrKF18AFy8XrW8XF17
	Ar18tr4UG3W3C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnI
	WIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Diff v2 vs v1:
1. Fix compile warning when disable EXT4_KUNIT_TESTS for patch[1][3];
2. Remove reviewed-by tag for patch[1];

Patch [1]-[2]:
Decoupled mballoc-test and extents-test from ext4. Patch [1] does not
have any changes compared to the previously released version, so the
reviewed-by is added.
Patch [3-7]:
Bugfix for extents-test.c.
Patch [8]:
Bugfix for mballoc-test.c.

Ye Bin (8):
  ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
  ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
  ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
  ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
  ext4: fix miss free super_block in extents_kunit_exit()
  ext4: fix the error handling process in extents_kunit_init).
  ext4: fix possible null-ptr-deref in extents_kunit_exit()
  ext4: fix possible null-ptr-deref in mbt_kunit_exit()

 fs/ext4/Makefile       |   5 +-
 fs/ext4/ext4.h         |   5 ++
 fs/ext4/ext4_extents.h |  12 +++++
 fs/ext4/extents-test.c |  59 ++++++++++++++++--------
 fs/ext4/extents.c      |  38 ++++++++++++---
 fs/ext4/mballoc-test.c |  87 ++++++++++++++++++-----------------
 fs/ext4/mballoc.c      | 102 +++++++++++++++++++++++++++++++++++++++--
 fs/ext4/mballoc.h      |  30 ++++++++++++
 8 files changed, 268 insertions(+), 70 deletions(-)

-- 
2.34.1


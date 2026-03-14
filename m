Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC75529D26B
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474655; cv=none; b=EiSpBlJsd8XdgDw20dfTJpXDB1Ht4BkErnDFToBTze4ybVEzilFUvqzbviYqF13sbxtehGwmiYFVh9Swniy2WCWX9IkU9BAdbP9GhCRe3FnZIh8PBSG+kYu6onbWvjzOZNop74TTU+mcJ6b34rq8LCLJCEExfjMrBcSbNcQsSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474655; c=relaxed/simple;
	bh=4LbZeXldLSY4SU57/RNOkmnpi3rxMHWt3w+ADS9Me44=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f9SZvfaIbEHnYYAER6EoABmKSnQLvQj8c/voEE8hxWAHmeg50Ht+675i+Ei44VIwqUyzxKwZAcgY0ly3HLDt4vHNkr2QZpACvvA3hsSVvkoJGGNJRBKlVQCUPHjtwA/KdmuDnVw66qg2o/k8pNOxgFQ1hbsbO++QrsOFhpqI638=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fXtnK1k4nzKHMbJ
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 714E340590
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhZE7Vpm1BvAw--.31250S4;
	Sat, 14 Mar 2026 15:50:50 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v3 0/5] Fix some issues about ext4-test
Date: Sat, 14 Mar 2026 15:48:58 +0800
Message-Id: <20260314074903.1314851-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_UhZE7Vpm1BvAw--.31250S4
X-Coremail-Antispam: 1UD129KBjvJXoWrZFy3ZFW8GrWDJryDKF43GFg_yoW8JrWfpa
	13CasIgr4UZrn3AFZxJa4UAry5Wrs7A39rCryay3W7Za43CryrKr47Kr18Zay8Xw4xXF12
	vr10yrWUG3ZxC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Diff v3 vs v2:
1. Remove three patches from this patchset:
  ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
  ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
  ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
2. Fix 'sbi' leak as no "sbi->s_sb->s_op->put_super()" registered.

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

Ye Bin (5):
  ext4: call deactivate_super() in extents_kunit_exit()
  ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
  ext4: fix the error handling process in extents_kunit_init).
  ext4: fix possible null-ptr-deref in extents_kunit_exit()
  ext4: fix possible null-ptr-deref in mbt_kunit_exit()

 fs/ext4/extents-test.c | 54 +++++++++++++++++++++++++++++++-----------
 fs/ext4/mballoc-test.c |  6 ++++-
 2 files changed, 45 insertions(+), 15 deletions(-)

-- 
2.34.1


Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EDD2DCF67
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774877576; cv=none; b=qAVOSd0kGLpJJSyGEYU276hh+fDB/sr+feEgcoaCm1zkdD23zJouQ92LGh//KcHQkOf9bNNcboJ2WzKV5MHP87k0mlRiIgwOhH1tyNOastuQ+OCHzxkumrShE7WRp+GYubOrFqrtch61yBRyMgZep4U80QjmltTTnTp/+mXp8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774877576; c=relaxed/simple;
	bh=sys6wgVFigVFCIMANAbItXJgiRC4Ha5fOLX7LmD1+Nk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DpuTdXUQFIxYTBtDpQa+v/jm/qwhqcQnWn3Vu64QGC7JHPtWmNiLYNGb/SUexnD2kFKaFZ+G7WS3oMZsl9IZ7E0goGOeiC1SscUjFSH7RQVMz6mwxArW+1jvPgji8mfyKkUWibqTfx0dgkXWc7yVDpIm+KbksTtfulDaEBo+Scw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fksc2133zzKHLxJ
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 21:32:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B1F7A4058F
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 21:32:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDHn0p7e8pp7U0sCw--.17260S4;
	Mon, 30 Mar 2026 21:32:45 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v5 0/5] Fix some issues about ext4-test
Date: Mon, 30 Mar 2026 21:30:30 +0800
Message-Id: <20260330133035.287842-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHn0p7e8pp7U0sCw--.17260S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WFWDCr1kAF18ur4rGryrtFb_yoW8WFy5pa
	13CasIgr48Zrn3AFZxG3WUJry5Wwn7A39ruryaq3W7ZF13CFy5Kr4xKFWxZFWDXw4fGF4a
	v340vr4UGasxC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This patch series is based on:
[1]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/

Diff v5 vs v4:
1. Patch[3]
Move ext4_es_register_shrinker() before setting up the mock inode.

Diff v4 vs v3:
1. Re-order PATCH[1] and PATCH[2].
2. Remove unnecessary check when call ext4_es_unregister_shrinker().

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
  ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
  ext4: call deactivate_super() in extents_kunit_exit()
  ext4: fix the error handling process in extents_kunit_init).
  ext4: fix possible null-ptr-deref in extents_kunit_exit()
  ext4: fix possible null-ptr-deref in mbt_kunit_exit()

 fs/ext4/extents-test.c | 60 ++++++++++++++++++++++++++++++------------
 fs/ext4/mballoc-test.c |  6 ++++-
 2 files changed, 48 insertions(+), 18 deletions(-)

-- 
2.34.1


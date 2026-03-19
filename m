Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882973C3BFD
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773924995; cv=none; b=JmRR6XQCSkCnyv27KxQIx8CD6cJ96xIVa4X0UM2A07CztBd3L723eXcJZXhr52kyEzsJ1RqiSAaPWFodOncT/WZew4NSHBOBTz3IOYqlJWcnXMuLKhJrNd7l9rSkTFhmT8z32OYGSP+mXf5ovsZe8bTISKCuj2//VVcnN0YP+NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773924995; c=relaxed/simple;
	bh=Tq/uXzto1eH4SmuBO9BaNMFVH3ZVqMkbMe+tdTPuTm0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VUq9O1pZmASx8Sloucm9mzvEFyUsIP8McBEnxX+AEX+wa8XddJ5Rs2EggZ30DRDO/BEA8ck3F6vtwQm6JLJpv1YIMo76pShLG979P7O2sg4T/xRLBdTqr+UJNlOdD97EPxZeASuzYTiQh/MzSZR4K7RF4c4tsrsXzc9Gj7+8lws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fc5Jx1WZvzYQtmD
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:55:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3570E40577
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:56:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUx68rtpgy7uBQ--.23117S4;
	Thu, 19 Mar 2026 20:56:28 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v4 0/5] Fix some issues about ext4-test
Date: Thu, 19 Mar 2026 20:54:29 +0800
Message-Id: <20260319125434.333117-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYUx68rtpgy7uBQ--.23117S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WFWDCr1kKr1rGw4UuFy3Jwb_yoW8Xw15pa
	13Ca9Igr4rZrn3AFZxG3WUAry5Wwn7A39rury3t3W7ZF13CFy5Krs3KrW8ZFWDXa1fWF4a
	v340yrWUGasxC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
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

This patch series is based on:
[1]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/

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

 fs/ext4/extents-test.c | 53 +++++++++++++++++++++++++++++++-----------
 fs/ext4/mballoc-test.c |  6 ++++-
 2 files changed, 44 insertions(+), 15 deletions(-)

-- 
2.34.1


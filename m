Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E003B9DB0
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147960; cv=none; b=mMt81VuMMmHXJm6PaYt5LSgKwTVLjFUIjBnrIjdQVbZgqi8TgYGtTR93ZmWBkYcg7tqEBAALIBsTq43vixVe+i7MXIGKBbx3A4TXkVclgqNnax95vBvapncgqHIu5lWjGSyQ/eb0KUk6eKX7rxCyZC3xK9J4tn0gF8y1u4W5nJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147960; c=relaxed/simple;
	bh=yn4e6bjy94Lpduj5OA4I41o0aFsgx2ulAaNoQGCRNjg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H4ta0d4oDW1pFipSs1K+xzF3yrfQXsnbSlFdc1EI3GJVPX7fmxrrkI1EU5rdGeUTVhEIRmaEIheanX5JsW41c75mB5L/fLnwDWfOw+w/tRB/hv9UqK/elpCGr0C9grh9XlXE5ShH5D+wzbmtfu7ATRFPP7Gwg5ryuQYJWrJLv4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVYyq1ZkNzKHMWT
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8500B4057D
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUwxF7BpaX6fAQ--.37695S4;
	Tue, 10 Mar 2026 21:05:54 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH -next 0/8] Fix some issues about ext4-test
Date: Tue, 10 Mar 2026 21:04:04 +0800
Message-Id: <20260310130412.3156753-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYUwxF7BpaX6fAQ--.37695S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Jr18WFWfKr1rGr15Zr1fWFg_yoW8JrWxpw
	13AFsxWr45Zrn3ZFZxGw4UAw15Wr18AwsrZry3t3W8XFy3AryrJrsrKr1rAFy8XrW8XF1U
	Ar18tr4UG3W3C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

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


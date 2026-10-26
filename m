Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015965;
	b=wN1ecu40uTct25kfedoG4695Gt+ciNkmv1DIX+wR4R6Vvv7ii457FfrKcadT4bedxLLE
	 Ft0ChQEvlHd4Jw6KXhrwHoRlqcxilfKDYbCSCyZhwYM4yMvDxn0NQ2m2r3zLAbqnVVbBW
	 Yrkw16fA98ew5QjKaEcBlUHaASEQ2crD6l2PXjW64dZAnBDGEzQ/xlAGyZxT0VpeWVmRU
	 HUF5rdaD1X4cUiD8GYpNgI63pv6uMy32OwSX21gAeaJRcUKl1mJvdoySYsLutLDxkRFTj
	 zjS+GR3cjXjORVqQQ54Pb+PuJTujtHL/bpOcrjDGtpObXpfx/VDunbZkJiUevb/RxBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015965;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=+A5fOQg3hWrYBJHmdOnGd7jiJw4YBzFsEeP29AgOyd8=;
	b=XqctPKAJV5TjiUCQqQ22h4RyHwfBrq/93g/OubWtEjoPp07yCwjxV17Th14TCm2uCXWa
	 o1IIdreFtjuFyZ+BBkHDUv8XWCNnCSMSHBTl7b1ejetqHdu+3aC/zWvX4hj/C+7BhGqUs
	 CTGMk7qJqVFB1SE1fKh5hIgTzuMQZNgqiqQUZguwteapedKREnpKnFwe7PgalVRKuf9ZJ
	 oBSowAd5mpidBEAe1fgwjpN1eOwccid1vG2xXiuWfkfMMdr0q5XYkE+7iRJuOTzGE2ASk
	 NCCoPRTZvvKXi/BqbqJK7HiexreASdl928IE6WhpSx9JP7uMRA/GAyMhTN5x/N7fNqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C288E606A322;
	Mon, 26 Oct 2026 11:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C288E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jCsbr4QN2z1c05c;
	Mon, 26 Oct 2026 19:59:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EA4A44056F;
	Mon, 26 Oct 2026 19:59:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvWLQN9q6RyfBw--.40032S5;
	Mon, 26 Oct 2026 19:59:15 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH 1/4] ext4: return 0 instead of stale ret in ext4_iomap_writepages()
Date: Mon, 26 Oct 2026 19:51:28 +0800
Message-ID: <20261026115131.1735014-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZvWLQN9q6RyfBw--.40032S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1kuw1rKF1UtryDGrWkCrg_yoW8Xw18pF
	W3G34kCr1kWrykuan2ga43Zw1jka9rGr4UWF15CFn0v398XFWFgF40gF12vF47CrW8CayY
	qF4F9F48uw1jvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUjrHUDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

smatch reports a "missing error code" warning:

  fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? 'ret'

The 'ret' variable has already been consumed by the
ext4_emergency_state() check at the beginning of the function, so its
value is always zero at this point. Returning it is equivalent to
returning 0, but it is misleading because it looks like an error code is
being propagated.

This branch handles the race with ext4_change_inode_journal_flag(),
which flushes the dirty data and drops the page cache before switching
the inode to the buffer_head path, so there is genuinely nothing to
write back here. Return 0 explicitly to make the intent clear.

Fixes: bdcbb0f19e92 ("ext4: partially enable iomap for the buffered I/O path of regular files")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b4d581aa5ee1a..6b2f1b07f41e6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4515,7 +4515,7 @@ static int ext4_iomap_writepages(struct address_space *mapping,
 	 */
 	if (!ext4_inode_buffered_iomap(inode)) {
 		ext4_writepages_up_read(sb, alloc_ctx);
-		return ret;
+		return 0;
 	}
 
 	trace_ext4_writepages(inode, wbc);
-- 
2.52.0


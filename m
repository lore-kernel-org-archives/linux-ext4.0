Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793326899;
	b=MWVX5uTNNeHKK3NleDwKjzXKbgG+A3gYVdopZhIeOmzCGuiWEyRO4RLrhoLQc6LkfNmL
	 b5dtwo04WyyQ/E62kvRPclgPHg/Wk256zOuBG9w4Pd60zDi04t8NTOElOpEebWI2hhJDc
	 VBRuK1n9UMeWG4BinRWsmMEWHmXErQmrY3PS+Yq9ZgwP+bOUWzerD7gX+YYCZVlRFyhxM
	 htypIoOQ0ykV2JM29BDeHyQ8SIOU5JHdsdPanR6i2KW0+TPILphWPvYI6QdvueKX7/BMJ
	 vUkJR4OQw0HZ4AFBKiG2RMN8ULfUT2CCe6/g7NGjMdwWMln3sI0KwMlL9XLgzV014Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793326899;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=+A5fOQg3hWrYBJHmdOnGd7jiJw4YBzFsEeP29AgOyd8=;
	b=IjwgKO/2fDWZbUlUoAHWtaKvkU+Z5NcIvBicYEGQGQWMwZjt7uKAo0vFetDkkXaNRctv
	 J4revOPmGC28q2ojlMOBzpDr0fegUrlcZ4cRbrSHR1UKRW1Z2eRdAbwIL2wOSIyENLxU4
	 N1aX8VIHGu7X5VAq3F/yuNgxGWVoLdmX6xG+LzHnUZ7eHi/WcfDK7IZCiW3aEotVU+o0C
	 D3mqwQgEQpMAQ2p0oBnkbJVoU+GVVumfkUxu8KxORidWFegxwwxHrQWre8pg/ZgkguGZ+
	 gXlwQQBoBtHEBRlwK+lVKImspKUSmJRsVAnJgdpiUHijlPqB4G6YCprEWEC31N03EKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9F0606A31A;
	Fri, 30 Oct 2026 02:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D9F0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jG4bK20xxz20KN;
	Fri, 30 Oct 2026 10:21:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A0C814056E;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzewm_+NqieRyCQ--.40911S5;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
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
Subject: [PATCH v2 1/4] ext4: return 0 instead of stale ret in ext4_iomap_writepages()
Date: Fri, 30 Oct 2026 10:13:35 +0800
Message-ID: <20261030021338.1768292-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXzewm_+NqieRyCQ--.40911S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1kuw1rKF1UtryDGrWkCrg_yoW8Xw18pF
	W3G34kCr1kWrykuan2ga43Zw1jka9rGr4UWF15CFn0v398XFWFgF40gF12vF47CrW8CayY
	qF4F9F48uw1jvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUewIqUUUUU
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


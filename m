Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696585;
	b=XS/SyTzRIJ8B9bX2mzrfeRNAU9kWnak0brCqQsXxIysLmexqGHoF+2BifPCZpE2HFZPq
	 3BVM4BfsoDCWdiO7yyejHWhOUmXdeQih+YJZtyNRQ3oTSILAo7E4e5+93Eg+o9hE/KbDU
	 v/qVhkVJ1+lWL+9YLkYd/Yjxh+SOxNonVh89d5c3fDOJcGI81S5YbOuhZ6Jt1YMXnimuZ
	 hQHqSiV7bb+x3vuYeTXgPQBzCcx5x3UwWMlxCEkER2et+MvpO5oKYFWns6UTwQNDy4/6c
	 P5nuP6qNgxy45GWMGOdOkQ897qHXMvxkvFiv71QYtGQrhWnbTdOXMqDER/QPrHt5LxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696585;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=mlU+8q1RMosBiatX4ha90g5/dQwjt1eMK/f6tvO9AxM=;
	b=MYfw2QbfDNullKl6IFRQ7FiAWTGnq7JsoQfirV6XrXipOkN2NCsNjEG4z6+8kbgQ1kzD
	 LkJhiUZOWbyNK/h3vmozBYCE/D/qTfXrs/m3+wQtri9RKZr9Cqa0rbRrjSglFzIJnYsO2
	 Abfu6724jIFcfGfO+E2jNluSKtZl/+dB1KJCPjlPmm1NgMubcIOmPo9QEmnOE+qYazPZ1
	 uMbcXjKnub+w39MC0Ac3IYwhQh8dScNref/Rhj9jiAbWPnhf17xPolT3KyW5TMkb4PX04
	 OE+DOmbfcqrkL06bpbh45l5NLEBOAq6JYDHqMisfQrewIwRxgfA9+BKNzQpD6E1ky+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8B6606A329;
	Thu, 26 Nov 2026 12:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C8B6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jZwyH4Tlbz1c1G5;
	Thu, 26 Nov 2026 20:36:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7FD3240B28;
	Thu, 26 Nov 2026 20:36:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu29JwhrXPqGFw--.16525S5;
	Thu, 26 Nov 2026 20:36:14 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 1/2] quota: Forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem
Date: Thu, 26 Nov 2026 20:36:10 +0800
Message-Id: <20261126123611.2517017-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261126123611.2517017-1-yebin@huaweicloud.com>
References: <20261126123611.2517017-1-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXTu29JwhrXPqGFw--.16525S5
X-Coremail-Antispam: 1UD129KBjvJXoWxGFy3KrWfGryfCw4fZr1DKFg_yoW5Xr4xpF
	Z5Cr13Gay8JF1q9rsrGanxZa4Fva1UuFyUGr18Aw1qqr1UGFWrtFnFv345try8XrZayws5
	ZFWI9as7Xr17CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Cb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UN2-5UUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Commit ccf370e43e08 (quota: Forbid Q_GETQUOTA and Q_GETNEXTQUOTA for
frozen filesystem) forbade Q_GETQUOTA and Q_GETNEXTQUOTA on a frozen
filesystem because ext4_acquire_dquot() prepares for allocating space for
a new quota structure and OCFS2 needs to update the on-disk structure use
count when a new cluster node loads quota information from disk.  The
same applies to Q_XGETQUOTA and Q_XGETNEXTQUOTA: userspace treats them as
read-only commands, but if the queried dquot is not cached yet,
->get_dqblk()/->get_nextdqblk() call dqget() -> ->acquire_dquot(), which
may write to the filesystem.

Until now this only made ext4 warn about starting a transaction on a
frozen filesystem.  Now that ext4_acquire_dquot() also takes
sb_start_intwrite() to protect against freezing, it turns into a
deadlock: the query holds s_umount for reading and blocks on the
SB_FREEZE_FS freeze protection, which thaw_super() can only release
after taking s_umount exclusively.

So forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA on a frozen filesystem as well
by moving them out of the read-only set in quotactl_cmd_write(), just
like Q_GETQUOTA and Q_GETNEXTQUOTA.  This also makes quotactl_fd() take
write access for them, so a query on a read-only mount now fails with
-EROFS; that is the same behavior the generic quota commands already
have.  If someone needs read-only querying on a frozen or read-only
filesystem, proper read-only dquot lookup can be implemented separately.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 89c3f9f5bb7b..423a7bcd1d63 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -767,9 +767,10 @@ static int quota_rmxquota(struct super_block *sb, void __user *addr)
 static int quotactl_cmd_write(int cmd)
 {
 	/*
-	 * We cannot allow Q_GETQUOTA and Q_GETNEXTQUOTA without write access
-	 * as dquot_acquire() may allocate space for new structure and OCFS2
-	 * needs to increment on-disk use count.
+	 * We cannot allow Q_GETQUOTA, Q_GETNEXTQUOTA, Q_XGETQUOTA and
+	 * Q_XGETNEXTQUOTA without write access as dquot_acquire() may allocate
+	 * space for new structure and OCFS2 needs to increment on-disk use
+	 * count.
 	 */
 	switch (cmd) {
 	case Q_GETFMT:
@@ -777,8 +778,6 @@ static int quotactl_cmd_write(int cmd)
 	case Q_SYNC:
 	case Q_XGETQSTAT:
 	case Q_XGETQSTATV:
-	case Q_XGETQUOTA:
-	case Q_XGETNEXTQUOTA:
 	case Q_XQUOTASYNC:
 		return 0;
 	}
-- 
2.34.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795605063;
	b=cwJwRd1XWqU4TCAAyTeHXnEpjKSGta+1fGwIhk34pMn68UFTEcf5TaR19AWp9a64KCne
	 IkBV3vRVaMGdm3AhCwpF2KVMlmh/MYvYey3+YTfkR4QCGTDQW0pKY++xPs3varH7EcGWa
	 es8i1AZmAcDtX9Rqx5zYGUWaP/FGDYcphsOZzeE9dZrG9VWEnYSd7yVY8T9yhx8o+BGJs
	 /TPwudzY5cpWpZf62kmctYdmEEX1LislG9nVrx0Q2OmZYz8X1tZHBZd2sfORHOz4YMb6M
	 g+T+SHVT7Q9/krSgRnrspS4C/VbIMAA5lOYc5Ly/L3i56ViB9+YJj2wMyWlkak7xSkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605063;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=2YbT77WG8Dv8u09/b/O26Oaz2dewpuFiaGksh3glnD4=;
	b=wvfnaCg70HSe5OntXse8p6AEbr9gmVC0RhLNizfmcm1yVM48n+mpMXlUGO/Tr/DqtdGs
	 XD6vFJO85Kn6+ni/ccPtDUwxotf68uIAf4Plpt1SKEgJG32wirpHl+xpuDUunLSBCYgC1
	 xs4mpZDnLSL+44d0rTXAu5w3JBRuc3i+MN+hN6hZ7oDZ7U5vxEqGX5SN9BUTDxJd9R0N+
	 jkAeN1aA5hEWHpF1NIiIscwBWziKMnrvvRfS/8SwtGAlmg/eJPdW8eiERhuNhAyW//nFt
	 GEHEr2nvU3/dhuZYtNdsyvAQd1mOIvpXfPqmL5388Sih7vWaeMMjiwqM0BpDKQmf9vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2257606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 11:11:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2257606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jZH6Q4CSmz20c8
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 19:10:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1226F4056B
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 19:10:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzexAwgZrMoj5Fg--.27408S5;
	Wed, 25 Nov 2026 19:10:57 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 1/2] quota: Forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem
Date: Wed, 25 Nov 2026 19:10:54 +0800
Message-Id: <20261125111055.3672233-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125111055.3672233-1-yebin@huaweicloud.com>
References: <20261125111055.3672233-1-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXzexAwgZrMoj5Fg--.27408S5
X-Coremail-Antispam: 1UD129KBjvJXoWxGFy3KrWfGryfCw4fZr1DKFg_yoW5Gw13pF
	Z5Cr1fGayrJr1q9rsrGanxZa4Yva1UuFyDGr18A34qqr1UGFWrtFnrZ345tr18Zrsaywn5
	ZFWI9as7Xr17GrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvmb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
	6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7IU14CJJUUUUU==
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
---
 fs/quota/quota.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 94e6407734c7..1669bb09b9f7 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -834,9 +834,10 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
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
@@ -844,8 +845,6 @@ static int quotactl_cmd_write(int cmd)
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


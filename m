Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795605063;
	b=gT0fEsrCAObsXvhMu0PDodevGrbj8uK6Ui+RLH/YsMAHd/0fZCsXC/OCHV4p4yxXOD9G
	 KSvEalXfGlA2cM+ab6Tx7h7wsYDvdPQgvJ+RrOfWjd8/MhVVtI9Gcv+0+z7a2Z2xzqgch
	 s0tf/S3oVYn3MoOnr7s67T68eHU99tRGBtFK5kULfQA/XtNqILqD14wH9WyIxZc/Unbh7
	 MMY5oLm1b2zW7vp57DxtjS3rMsZ/Q2m/1+Vwg3UOOVjXIovShNuj9k+xyQbyS+WFC1dv8
	 1HId1qCach6wTG98l8TM4LafW85nE6GeLUG2GR1Zu6yNc6Z2fcyqfh1Hg0gNMEcKy3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605063;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=mOVKD/RokZmYHNTtnF8CJDYNFBNejkopzOpM58vU0Rg=;
	b=yxXsSgavUnEKXCQbkgzWgD9PKz7iEeQFocsy6KV9Ud/YIIud5FPSwNCKuTKxoFz3fjx1
	 wkVUJpLzf1B9GDAUWmEXR8eAt1GDAOORNPUsdvo+XD3MquKbAoPOHgd24v3HD+iI11Kko
	 mtubmNM8zjsPBjFUaOZs6+tXLGh1R0l20ORNTgZ+VWE9GC+YVHdkhDD3BUO0jx/QzFnrm
	 UJJjAoa6zdJpcBWALtc+8q1ckEBK8BibmEh/5C6Y+881BTrk//s3QK8d2OeiDmTSxvC57
	 jFhzNdky97KgBOmpDYIFd7cBPkoV548eyIhgZaQdKO2gz6ERv9frJ8M1ARqiPoBmMbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50488606A321
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 11:11:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50488606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jZH6Q60kWz1rr7b
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 19:10:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0944140A34
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 19:10:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzexAwgZrMoj5Fg--.27408S4;
	Wed, 25 Nov 2026 19:10:57 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 0/2] ext4: protect quota acquisition against filesystem freezing
Date: Wed, 25 Nov 2026 19:10:53 +0800
Message-Id: <20261125111055.3672233-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:gCh0CgCXzexAwgZrMoj5Fg--.27408S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWDWFW5Cw4kGrWxCF1kAFb_yoW8Kr4kpF
	Z5C3W5Kan5JryI9rW2ka1xZ3yFy3Z5Za4DtrykCryDZFnxX3W8tF9Fk34F9Fy8Zrsakw1Y
	vF1Ik3sF9F47ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgmb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This series fixes quota operations running against a frozen filesystem,
and the resulting freeze protection for ext4's dquot acquisition.

Patch 1 makes Q_XGETQUOTA/Q_XGETNEXTQUOTA consistent with Q_GETQUOTA and
Q_GETNEXTQUOTA and forbids them on a frozen filesystem.  These commands
may end up in ->acquire_dquot() when the queried dquot is not cached yet,
and thus may write to the filesystem, just like Q_GETQUOTA/Q_GETNEXTQUOTA
which commit ccf370e43e08 ("quota: Forbid Q_GETQUOTA and Q_GETNEXTQUOTA
for frozen filesystem") already handles.  They were historically treated
as read-only because they come from XFS, where quota is always coherent,
but generic quota now routes them through dquot_get_dqblk()/
dquot_get_next_dqblk() and dqget().  Running them on a frozen filesystem
makes ext4 start a transaction on it and warn.  As suggested by Jan, they
are now handled exactly like the generic commands, including taking write
access, so a Q_XGETQUOTA on a read-only mount will report -EROFS; proper
read-only querying can be added later if somebody actually needs it.

Patch 2 protects ext4_acquire_dquot() itself.  A writable open reaches
the filesystem's ->open() callback without superblock freeze protection,
so ext4_file_open() -> dquot_file_open() -> dquot_initialize() can
acquire a dquot and start a transaction after the filesystem has been
frozen.  Take sb_start_intwrite() around ext4_acquire_dquot() when no
transaction is already running; running transactions are already
protected against freezing.

Patch 2 relies on the preceding patch 1.  Taking freeze protection in
ext4_acquire_dquot() while holding s_umount, as the Q_XGETQUOTA and
Q_XGETNEXTQUOTA paths do, would deadlock against thaw_super(), which
needs s_umount exclusively to release the SB_FREEZE_FS protection.
Patch 1 forbids those commands on a frozen filesystem and thus makes the
new protection in patch 2 safe.  Both patches must be applied together.

Ye Bin (2):
  quota: Forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem
  ext4: protect ext4_acquire_dquot against freezing

 fs/ext4/super.c  | 20 +++++++++++++++++++-
 fs/quota/quota.c |  9 ++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.34.1


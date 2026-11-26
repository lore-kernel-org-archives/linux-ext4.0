Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696584;
	b=MtrFC6MMP4M4GeSR1UQZH6pH7tsd3iyDGF1Nqn6+B/kufELq86wMRXdHQn9PUr2jMhRv
	 rti7E5zQtbVSKS4eaeob0MqwZwlAZhIMwpLR3zoQG1tISMX/bGuQqjVAk/bmIVkviX9tz
	 9FArsVuO+9q+BLuVD0jv2CGdOwVtFHx5YddQJQDmeGgjPSZw+89GPGQJIY+7cX2gbkJrM
	 A+LEeNxTxVU37CGe4hw1zkIxKBlXBEFLt6EoHGnbixbONmiOSFEOtIizlSc+VECKvD4Hl
	 WmAa+i8/osyWn0HC7o3IRU8B47GealbmsGmmoMd+agFc06sHHIjhElur+xp1oUSNUzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696584;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=il5Fa1FPP/Xkz8M5ENlFQt0aXvl0fMjH40Xw0G4UQOE=;
	b=kw5T7YRM5RTlzLQOJBsFbk0ikolThCnCM8FIN5kaUWYEHU9xeYm1IUYMn2dhHL41388P
	 qQwtYkSeHz9o59ZNNbEWALxwoSuSqp0PZC1oWVNSvqX72tJSTlUsmd0YQLpzW8T9/KYpo
	 sLhqdmGLVLk2ELbaHgf+oQCFjmRSFg8InQkNowvcRXiCPIbYVEYJMpgn56+0FXMBWWDPX
	 1jRjz38bWh/8NCUeznHdycjRNktwwxc+K87sI440Su74Qe/AXzb6/N0evIARRqoUAHm9c
	 PARQShfelkOewtOYodQPiv7H/CjE9UJ0lkWT6OiFrq+o9xFchf/ccKtafhnvqpn1o5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BAA606A31E;
	Thu, 26 Nov 2026 12:36:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5BAA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jZwyK3Kr1z1rrTt;
	Thu, 26 Nov 2026 20:36:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8925A4056B;
	Thu, 26 Nov 2026 20:36:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu29JwhrXPqGFw--.16525S6;
	Thu, 26 Nov 2026 20:36:14 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 2/2] ext4: protect ext4_acquire_dquot against freezing
Date: Thu, 26 Nov 2026 20:36:11 +0800
Message-Id: <20261126123611.2517017-3-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXTu29JwhrXPqGFw--.16525S6
X-Coremail-Antispam: 1UD129KBjvJXoWxuFy8ZF4ktr4UAw1fWw4DArb_yoW5Cr4kpF
	Z3CFy3tF4vqa4xu39rGa1fC3yrAw1v9a47JFyIgrn8Xan8X3W8KF17t34F9FyUJrW3urn0
	qF4jkry7Ca12yrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Cb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jbqXdUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

A writable open of a regular file reaches the filesystem's ->open()
callback without holding any superblock write (freeze) protection, but
ext4_file_open() -> dquot_file_open() -> dquot_initialize() may need to
acquire a dquot and write the quota file.  If the filesystem reaches
SB_FREEZE_COMPLETE in that window, ext4_journal_check_start() hits

	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);

and the open then sleeps in jbd2 until the filesystem is thawed.

Taking freeze protection for every writable open in the VFS would make a
plain open(O_WRONLY) on a frozen filesystem block even when it never
writes, which is an unacceptable behaviour change.  Instead protect the
quota acquisition path itself: take sb_start_intwrite() around
ext4_acquire_dquot() when no transaction is already running.  Running
transactions are already protected against freezing and taking
sb_start_intwrite() inside one can deadlock.

This protection relies on the preceding quota change ("quota: Forbid
Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem").  Those commands
are treated as read-only and run with s_umount held for reading, but they
can still reach ext4_acquire_dquot().  Taking sb_start_intwrite() there
would deadlock against thaw_super(), which can only release the
SB_FREEZE_FS protection after taking s_umount exclusively.  The preceding
change forbids those commands on a frozen filesystem, which makes the new
protection safe, so both patches have to be applied together.

Fixes: 907f4554e252 ("dquot: move dquot initialization responsibility into the filesystem")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b021cbeb5f3a..0134f1c7668e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7177,11 +7177,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 {
 	int ret, err;
 	handle_t *handle;
+	bool freeze_protected = false;
+
+	/*
+	 * Trying to sb_start_intwrite() in a running transaction
+	 * can result in a deadlock. Further, running transactions
+	 * are already protected from freezing.
+	 */
+	if (!ext4_journal_current_handle()) {
+		sb_start_intwrite(dquot->dq_sb);
+		freeze_protected = true;
+	}
 
 	handle = ext4_journal_start(dquot_to_inode(dquot), EXT4_HT_QUOTA,
 				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		if (freeze_protected)
+			sb_end_intwrite(dquot->dq_sb);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_acquire(dquot);
 	if (ret < 0)
 		ext4_error_err(dquot->dq_sb, -ret,
@@ -7190,6 +7204,10 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
+
+	if (freeze_protected)
+		sb_end_intwrite(dquot->dq_sb);
+
 	return ret;
 }
 
-- 
2.34.1


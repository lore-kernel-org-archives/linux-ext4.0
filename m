Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795605063;
	b=TYtFhl1fQJn7CVOf5dSEh3Ej2xE33QwI/XDwW6yHsdVdq1PXdZCLHTkLJtQBXXZ0q3Mn
	 +CFn0phvSvUgPFF9puW6C4n2j45QaJupMjHIs6YYsXh7gTMTZ2bZq5gAQdZcXtUPOohnl
	 gun3p5iOGZ9e0xiHkBdQv91MbP/0LB9whlB9ePo9yWAYYoV6W6J92y/YxcWbjP5+9V0/0
	 mpmOXaGkHyO70auvz5OxSibLYLyx2VJqS8Zqv8ZC34FzKjbI5BAKJX5Fqnnc7mzm/TF+f
	 YhLYEpAc03Hxx7FJSyB/8FFyLuWOCuPr2cPkH3KEGSZiZDBWxlawP3nPfXkW1jqLd2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605063;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=peQ1MdX3JGAcyrbWC4U+t2nwbZ79eSVPefOqGoiFRPQ=;
	b=C7IQQ9y2sumGOU+dyU0aRl8u43rfuXCNLyb+ASpHJpFI3mAVjSMmkbR6hgBMlp4A8sJV
	 KlMBEhI24lnwwVlU/qqqgv2BAtxPvN6FJxnZ3NgLOWFLMBq/Ez1b+gsembAQJAfVP0mZs
	 bhXZ1qlAnSaznxurMf+CHflEYSdu9IaqQJzjfX8izJW2U0MP2HRFsSs9/xWVPzoqDFESF
	 hv7aunTrpEQeJm0NY54Q/FZFJqCetxJplUNad2tjQ01wweyiXuqXZVvBxqc2DfYuw815d
	 QifMV0wFQPjMb7bLM0b7TltN9M5igGBzS+iDkk7rR9x8xxcQjmVdaR2btzX/U6cYi8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2A0606A323
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 11:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D2A0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jZH6P0dSYz1c0V2
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 19:10:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1521940561
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 19:10:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzexAwgZrMoj5Fg--.27408S6;
	Wed, 25 Nov 2026 19:10:58 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 2/2] ext4: protect ext4_acquire_dquot against freezing
Date: Wed, 25 Nov 2026 19:10:55 +0800
Message-Id: <20261125111055.3672233-3-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXzexAwgZrMoj5Fg--.27408S6
X-Coremail-Antispam: 1UD129KBjvJXoWxuFy8ZF4ktr4UAw1fWw4DArb_yoW5Aw13pr
	Z3CF9xtFW0va4xu39rGa1fC34rAw1v9a4UJryI9Fn8Xan8X3W8KF17t34F9FyUJrW3urn0
	qF4jkr9rGa12yrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvmb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
	6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7IU1iiSJUUUUU==
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
---
 fs/ext4/super.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d0415e5948e1..fc63219f5972 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7110,11 +7110,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
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
@@ -7123,6 +7137,10 @@ static int ext4_acquire_dquot(struct dquot *dquot)
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


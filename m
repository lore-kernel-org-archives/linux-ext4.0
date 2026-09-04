Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143C141D631;
	Fri,  4 Sep 2026 06:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505021; cv=none; b=XWtMSftAopU0WFkdk7ccmfi7WBgAkt3Vq1ueS7Jo8/v3bz3IE0t+UfFhbHlG1WpUdWnFiXEjm6m7P4ayPyytS7Swb7KipsOj7ApnyJCU0WWrSC68uJJcQPFYaeoyeRhEI9i2wlv5xEyZVMog5fEtna+SLy0HmsWpN5booKyPhnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505021; c=relaxed/simple;
	bh=6ZOx3T9dc0hdtCv+TyGdOiPUeHOMqZYeHNTDggTJ9I8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GMw/ztzYVJcq5rUDqAIdpzktcUgG7jJIOlTgeO7BBDPuOajr9lrO78BQ+OWKCjwc77mMvANuLJbGeGg0weukze6LIhVsYRJthemj3y6kW3F2WTxcsm0egnUPfowVEux+WkDQvkcFIL2SjOrr5//A5JLJ7hs0stwbp8iCASskPM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=GSFuUJ7w; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="GSFuUJ7w"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4c86de9dd;
	Fri, 4 Sep 2026 14:56:54 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] ext4: shut down error report timer on failed mount
Date: Fri,  4 Sep 2026 14:56:48 +0800
Message-Id: <20260904065648.4048108-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa06b34c08803a1kunm13cb41e32d018
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTR9MVk0ZQxpJT08dTkNPHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=GSFuUJ7warmzwkkURt6Pe04S1dWc6A0jYLD/h/bsuGuqjJdI3/tQ62dLkXQrRJVb0j3JtR0bSP9ZGiNqnzgehtRzLn2bK9Qa/B0lhVHbNfLwW/8lzcJwdztgzQptQS6lrke/gjYMjFKJyburJQ+xJpdABLTvwAPIIifncW8gLXQ=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=DYu2CTpxOfuLOq7oZsL4Tvgmo8qLf4rSU/HbBPnTvGk=;
	h=date:mime-version:subject:message-id:from;

__ext4_fill_super() arms s_err_report when the on-disk error count is
nonzero. If a later mount step fails, the failed-mount cleanup path uses
timer_delete_sync() before freeing sbi.

print_daily_error_info() rearms the timer when s_err_report_sec is nonzero,
so timer_delete_sync() does not prevent the timer from being queued again.
The rearmed callback can then access sbi after the failed mount has freed
it.

Use timer_shutdown_sync() for failed-mount cleanup. This matches the normal
unmount path and prevents the timer from being rearmed before sbi is freed.

Fixes: 66e61a9e9504 ("ext4: Once a day, printk file system error information to dmesg")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bca0dc87d..154e00901 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5809,7 +5809,7 @@ failed_mount8: __maybe_unused
 	/* flush s_sb_upd_work before sbi destroy */
 	flush_work(&sbi->s_sb_upd_work);
 	ext4_stop_mmpd(sbi);
-	timer_delete_sync(&sbi->s_err_report);
+	timer_shutdown_sync(&sbi->s_err_report);
 	ext4_group_desc_free(sbi);
 failed_mount:
 #if IS_ENABLED(CONFIG_UNICODE)
-- 
2.34.1


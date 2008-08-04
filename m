From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: fix ext4_fill_super memory leak
Date: Mon, 04 Aug 2008 16:50:10 +0800
Message-ID: <4896C2C2.4010604@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60039 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYHDIxc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Aug 2008 04:53:32 -0400
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id E07FE170131
	for <linux-ext4@vger.kernel.org>; Mon,  4 Aug 2008 16:53:28 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id m748rQOR001050
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 16:53:27 +0800
Received: from localhost.localdomain (unknown [10.167.141.45])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id 231F3D4193
	for <linux-ext4@vger.kernel.org>; Mon,  4 Aug 2008 16:54:59 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


When ext4_fill_super fails, s_flex_groups is not freed.
Fix it.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b5479b1..6ed0e27 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2487,6 +2487,7 @@ failed_mount4:
 	jbd2_journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
 failed_mount3:
+	kfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
1.5.5.1

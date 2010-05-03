From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Fix for ext4_mb_collect_stats()
Date: Mon, 3 May 2010 10:26:43 -0700
Message-ID: <AANLkTinpiynL7Jq3RAbMtiye89wEsLjs07ZkxGWGg_lX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:24938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0ECR0s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 May 2010 13:26:48 -0400
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id o43HQj0Y032051
	for <linux-ext4@vger.kernel.org>; Mon, 3 May 2010 10:26:46 -0700
Received: from vws14 (vws14.prod.google.com [10.241.21.142])
	by wpaz9.hot.corp.google.com with ESMTP id o43HQiWN019349
	for <linux-ext4@vger.kernel.org>; Mon, 3 May 2010 10:26:44 -0700
Received: by vws14 with SMTP id 14so1695335vws.16
        for <linux-ext4@vger.kernel.org>; Mon, 03 May 2010 10:26:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix ext4_mb_collect_stats() to use the correct test for s_bal_success; it
should be testing "best-extent.fe_len >= orig-extent.fe_len" , not
"orig-extent.fe_len >= goal-extent.fe_len" .

	Signed-off-by: Curt Wohlgemuth <curtw@google.org>
---
diff -uprN orig/fs/ext4/mballoc.c new/fs/ext4/mballoc.c
--- orig/fs/ext4/mballoc.c	2010-05-03 10:11:36.000000000 -0700
+++ new/fs/ext4/mballoc.c	2010-05-03 10:13:31.000000000 -0700
@@ -2981,7 +2981,7 @@ static void ext4_mb_collect_stats(struct
 	if (sbi->s_mb_stats && ac->ac_g_ex.fe_len > 1) {
 		atomic_inc(&sbi->s_bal_reqs);
 		atomic_add(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
-		if (ac->ac_o_ex.fe_len >= ac->ac_g_ex.fe_len)
+		if (ac->ac_b_ex.fe_len >= ac->ac_o_ex.fe_len)
 			atomic_inc(&sbi->s_bal_success);
 		atomic_add(ac->ac_found, &sbi->s_bal_ex_scanned);
 		if (ac->ac_g_ex.fe_start == ac->ac_b_ex.fe_start &&

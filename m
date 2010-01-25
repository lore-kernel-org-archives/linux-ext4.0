From: dingdinghua <dingdinghua@nrchpc.ac.cn>
Subject: [PATCH 2/2] Jbd2: fix an assertion, jh->b_transaction should be
Date: Mon, 25 Jan 2010 11:45:04 +0800
Message-ID: <1264391104-10950-3-git-send-email-dingdinghua@nrchpc.ac.cn>
References: <1264391104-10950-1-git-send-email-dingdinghua@nrchpc.ac.cn>
 <1264391104-10950-2-git-send-email-dingdinghua@nrchpc.ac.cn>
Cc: dingdinghua <dingdinghua@nrchpc.ac.cn>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [159.226.39.252] ([159.226.39.252]:34356 "EHLO bwstor.com.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751410Ab0AYEMl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jan 2010 23:12:41 -0500
In-Reply-To: <1264391104-10950-2-git-send-email-dingdinghua@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---
 fs/jbd2/commit.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 1bc74b6..28ad981 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -883,8 +883,7 @@ restart_loop:
 		spin_unlock(&journal->j_list_lock);
 		bh = jh2bh(jh);
 		jbd_lock_bh_state(bh);
-		J_ASSERT_JH(jh,	jh->b_transaction == commit_transaction ||
-			jh->b_transaction == journal->j_running_transaction);
+		J_ASSERT_JH(jh,	jh->b_transaction == commit_transaction);
 
 		/*
 		 * If there is undo-protected committed data against
-- 
1.5.5.6


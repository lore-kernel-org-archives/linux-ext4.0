From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] jbd2: make shure that we do not miss aborted state
Date: Thu, 16 May 2013 16:28:09 +0400
Message-ID: <1368707290-26185-3-git-send-email-dmonakhov@openvz.org>
References: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:17509 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab3EPM2U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 08:28:20 -0400
In-Reply-To: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd2/journal.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 886ec2f..57b9120 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -700,12 +700,11 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 				!tid_gt(tid, journal->j_commit_sequence));
 		read_lock(&journal->j_state_lock);
 	}
-	read_unlock(&journal->j_state_lock);

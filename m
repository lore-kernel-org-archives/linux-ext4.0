From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] jbd: make shure that we do not miss aborted state
Date: Thu, 16 May 2013 16:28:10 +0400
Message-ID: <1368707290-26185-4-git-send-email-dmonakhov@openvz.org>
References: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:8747 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab3EPM2V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 08:28:21 -0400
In-Reply-To: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd/journal.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 81cc7ea..dc00240 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -575,12 +575,11 @@ int log_wait_commit(journal_t *journal, tid_t tid)
 				!tid_gt(tid, journal->j_commit_sequence));
 		spin_lock(&journal->j_state_lock);
 	}
-	spin_unlock(&journal->j_state_lock);

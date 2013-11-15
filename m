From: Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] jbd: Lower severity of aborted journal from EMERG to CRIT
Date: Fri, 15 Nov 2013 15:56:52 +0100
Message-ID: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lubomir Rintel <lkundrak@v3.sk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

According to Documentation/kernel-parameters.txt, KERN_EMERG is reserved for
events that render system unusable.

This is hardly the case in case of flash memory stick hardware removal without
umounting. Syslog is often configured to forward messages with EMERG severity
to all logged-in terminals, often causing unnecessary noise.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 2d04f9a..9dbc1b6 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -605,7 +605,7 @@ out_unlock:
 	spin_unlock(&journal->j_state_lock);
 
 	if (unlikely(is_journal_aborted(journal))) {
-		printk(KERN_EMERG "journal commit I/O error\n");
+		printk(KERN_CRIT "journal commit I/O error\n");
 		err = -EIO;
 	}
 	return err;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5203264..2d1f53c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -719,7 +719,7 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 	read_unlock(&journal->j_state_lock);
 
 	if (unlikely(is_journal_aborted(journal))) {
-		printk(KERN_EMERG "journal commit I/O error\n");
+		printk(KERN_CRIT "journal commit I/O error\n");
 		err = -EIO;
 	}
 	return err;
-- 
1.7.1

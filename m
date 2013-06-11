From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/6] jbd2: fix duplicate debug label for phase 2
Date: Tue, 11 Jun 2013 18:44:27 -0400
Message-ID: <1370990670-49249-4-git-send-email-paul.gortmaker@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently we see this output:

  $git grep phase fs/jbd2
  fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 1\n");
  fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 2\n");
  fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 2\n");
  fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 3\n");
  fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 4\n");
  [...]

There is clearly a duplicate label for phase 2, and they are
both active (i.e. not in #if ... #else block).  Rename them to
be "2a" and "2b" so the debug output is unambiguous.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd2/commit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3263e4a..ab3c9d9 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -533,7 +533,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	wake_up(&journal->j_wait_transaction_locked);
 	write_unlock(&journal->j_state_lock);
 
-	jbd_debug(3, "JBD2: commit phase 2\n");
+	jbd_debug(3, "JBD2: commit phase 2a\n");
 
 	/*
 	 * Now start flushing things to disk, in the order they appear
@@ -548,7 +548,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 					  WRITE_SYNC);
 	blk_finish_plug(&plug);
 
-	jbd_debug(3, "JBD2: commit phase 2\n");
+	jbd_debug(3, "JBD2: commit phase 2b\n");
 
 	/*
 	 * Way to go: we have now written out all of the data for a
-- 
1.8.1.2


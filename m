From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make jbd/journal.c:__journal_abort_hard() static
Date: Wed, 24 Oct 2007 18:23:25 +0200
Message-ID: <20071024162325.GO30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, sct@redhat.com, akpm@linux-foundation.org,
	adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33316 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757208AbXJXQW4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 12:22:56 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

__journal_abort_hard() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/jbd/journal.c    |    2 +-
 include/linux/jbd.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

ce452fbc5ebf8a4751183cfb731496c595b4ef6f 
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 5d14243..3943a89 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1457,7 +1457,7 @@ static const char *journal_dev_name(journal_t *journal, char *buffer)
  * Aborts hard --- we mark the abort as occurred, but do _nothing_ else,
  * and don't attempt to make any other journal updates.
  */
-void __journal_abort_hard(journal_t *journal)
+static void __journal_abort_hard(journal_t *journal)
 {
 	transaction_t *transaction;
 	char b[BDEVNAME_SIZE];
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 16e7ed8..a9961cb 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -922,7 +922,6 @@ extern int	   journal_recover    (journal_t *journal);
 extern int	   journal_wipe       (journal_t *, int);
 extern int	   journal_skip_recovery	(journal_t *);
 extern void	   journal_update_superblock	(journal_t *, int);
-extern void	   __journal_abort_hard	(journal_t *);
 extern void	   journal_abort      (journal_t *, int);
 extern int	   journal_errno      (journal_t *);
 extern void	   journal_ack_err    (journal_t *);

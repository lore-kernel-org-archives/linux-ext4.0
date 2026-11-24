Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795491592;
	b=UxbZ4il6hSd3GABFXpHyRZDTMLNQgJQjB86cpC8YwMxOvXiprUy1kP5DdpYMD8k3tVCi
	 /m4/X1EO52eHr0mH/FV1cdS0ZJ1ZEH/OOibDuzlXL7ASMWIyTaSFtIwIaGG+eSkwIgIlv
	 QUtRVfYp1ThoWRv8sntd9xAy5Zu4QPYMlbJB6lUCMclFw1NOxQPwpNLUydlxTJFGNsDK/
	 ME+bF/4qb/ScnLO2BNAAMsuFoB4ajEtlk5xvoo2CDbxAW9swLZxBpGZMTCIkwo2VCv6bq
	 5I2S+fRM7SHPqMO4J/BsK+PcKl1FUHh8RVsUzxORTMBpuXdNqacY3tvOYTrcR5HV+bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795491592;
	h=DMARC-Filter:DKIM-Signature:X-Original-From:Content-Type:To:Cc:
	 Subject:X-Lms-Return-Path:Content-Transfer-Encoding:From:Date:
	 Message-Id:Mime-Version:X-Mailer;
	bh=F25wVZTc8MZogT8dIS6joE+l6la+ymAY6BmgWioa9tc=;
	b=c9Fm4L+Kho0XwHAolQPEeFBaNGy72qnTJAgS6QdjOGcR2SxOKYgJS9fPISs7SsqPkjjv
	 FsBk7nia1P8/VIp0qALrog+gPhsk8AB54i705zhO52ge/JshJIgjfe00g7WUAaUsaeSEq
	 iY2yfLxcWfmM25SXUVXho9lgRfQtULnN/yVgH+Ja+ITEQPzIkeHZXAjz3am2V2x9bUFD/
	 I3xsgqOWzujnAH4I2Vcb5QWLQ/fvVK0sZWUOYpG/jYZ+UytUPpyp7pwPUwAnVJak+h8Ae
	 ep/1LF36gM2qFXv31h/ec1u6RJrR9Mx6tFs9/+9cfNxqncCRWOIvbQpSSRfhv6HkLJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=U0PU2Fu4;
	arc=none smtp.remote-ip=209.127.230.112
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F722606A321
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 03:39:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F722606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=U0PU2Fu4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795491586; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=F25wVZTc8MZogT8dIS6joE+l6la+ymAY6BmgWioa9tc=;
 b=U0PU2Fu4Nkv2DMub1VpLoV67ft7sHQX1opGLzhPVBELSbsRbhxlWvvds9GevsUSpvSnCHy
 OsUktNVt/hnUk0yRc3JybJer0KBxt0TLf5veIc2zDf+/OcV/rIrBjz85rqSVi3rSf8eE6U
 /a6UO3Vs1M/ScJUCbKrz+uz5PNw0DP/W2jxdQP2YtcfxM2RZr4yZCniySVi6oBu49AVoZB
 iV8g24IjKU5DBES36h5v5HjCexJIByhTOKRyOuUJ4v81FmLPatMAxCCpnuzw5zpjn0YKeW
 Lz2mQ+ozI9gxuZfkKlNW9hGmp+vr13Nq2nD45LY53gFasNUHakol+x1MLr/OAw==
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-ext4@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <tytso@mit.edu>, 
	<adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>
Subject: [PATCH v4 1/2] jbd2: add a metadata validation hook to journal recovery
X-Lms-Return-Path: <lba+26b050700+758b10+vger.kernel.org+zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Date: Tue, 24 Nov 2026 11:38:59 +0800
Message-Id: <20261124033900.76700-2-zhaogongyi@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)

Filesystems can need to validate metadata that block replay has changed
before fast commit replay consumes it. They can also need to check
metadata that fast commit replay updates before completing recovery.

Provide an optional callback after block replay, including when the
journal is empty, and after fast commit replay. Propagate validation
errors before resetting the journal. Keep the existing replay flow for
callers of jbd2_journal_load().

If the scan has recorded a failed commit, skip the callback and fast
commit replay for callback users. This preserves the failed-commit
diagnostic and leaves the error handling of the load path in place.

Document the callback's execution context, I/O rules and data lifetime.

Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
 fs/jbd2/journal.c    | 33 ++++++++++++++++++++++++++-------
 fs/jbd2/recovery.c   | 42 +++++++++++++++++++++++++++++++-----------
 include/linux/jbd2.h |  7 ++++++-
 3 files changed, 63 insertions(+), 19 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index eb8e944..1bbb530 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2079,20 +2079,33 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 
 /**
- * jbd2_journal_load() - Read journal from disk.
+ * jbd2_journal_load_with_callback() - Read journal from disk.
  * @journal: Journal to act on.
- *
- * Given a journal_t structure which tells us which disk blocks contain
- * a journal, read the journal from disk to initialise the in-memory
- * structures.
+ * @callback: Optional validation callback for recovery.
+ * @data: Private data for @callback, valid until this function returns.
+ *
+ * Read the journal from disk and initialise the in-memory structures.
+ * Call @callback with after_fast_commit false after block replay,
+ * including for an empty journal, and with true after fast commit
+ * replay. A callback error stops recovery before the journal is reset.
+ * Recovery skips the callback if the journal scan recorded a failed
+ * commit.
+ *
+ * JBD2 invokes @callback synchronously in the loading task, with no
+ * JBD2 locks held. It may sleep and issue filesystem I/O. A callback
+ * may update metadata using nonjournaled I/O. It must not start a
+ * transaction or reenter recovery on @journal. On the empty journal
+ * path, the callback is responsible for synchronizing any writes it
+ * needs completed before the journal is reset.
  */
-int jbd2_journal_load(journal_t *journal)
+int jbd2_journal_load_with_callback(journal_t *journal,
+				    jbd2_replay_callback_t callback, void *data)
 {
 	int err;
 
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
-	err = jbd2_journal_recover(journal);
+	err = jbd2_journal_recover(journal, callback, data);
 	if (err) {
 		pr_warn("JBD2: journal recovery failed\n");
 		return err;
@@ -2125,6 +2138,12 @@ int jbd2_journal_load(journal_t *journal)
 	write_unlock(&journal->j_state_lock);
 	return 0;
 }
+EXPORT_SYMBOL(jbd2_journal_load_with_callback);
+
+int jbd2_journal_load(journal_t *journal)
+{
+	return jbd2_journal_load_with_callback(journal, NULL, NULL);
+}
 
 /**
  * jbd2_journal_destroy() - Release a journal_t structure.
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index cac8c2c..8e9b3bf 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -37,8 +37,9 @@ struct recovery_info
 	int		nr_revoke_hits;
 };
 
-static int do_one_pass(journal_t *journal,
-				struct recovery_info *info, enum passtype pass);
+static int do_one_pass(journal_t *journal, struct recovery_info *info,
+		       enum passtype pass, jbd2_replay_callback_t callback,
+		       void *data);
 static int scan_revoke_records(journal_t *, enum passtype, struct buffer_head *,
 				tid_t, struct recovery_info *);
 
@@ -270,6 +271,8 @@ static int fc_do_one_pass(journal_t *journal,
 /**
  * jbd2_journal_recover - recovers a on-disk journal
  * @journal: the journal to recover
+ * @callback: optional check after each replay stage
+ * @data: private data for the replay callback
  *
  * The primary function for recovering the log contents when mounting a
  * journaled device.
@@ -279,7 +282,8 @@ static int fc_do_one_pass(journal_t *journal,
  * blocks.  In the third and final pass, we replay any un-revoked blocks
  * in the log.
  */
-int jbd2_journal_recover(journal_t *journal)
+int jbd2_journal_recover(journal_t *journal,
+			 jbd2_replay_callback_t callback, void *data)
 {
 	int			err, err2;
 	struct recovery_info	info;
@@ -300,14 +304,14 @@ int jbd2_journal_recover(journal_t *journal)
 			  be32_to_cpu(sb->s_sequence), be32_to_cpu(sb->s_head));
 		journal->j_transaction_sequence = be32_to_cpu(sb->s_sequence) + 1;
 		journal->j_head = be32_to_cpu(sb->s_head);
-		return 0;
+		return callback ? callback(journal, data, false) : 0;
 	}
 
-	err = do_one_pass(journal, &info, PASS_SCAN);
+	err = do_one_pass(journal, &info, PASS_SCAN, NULL, NULL);
 	if (!err)
-		err = do_one_pass(journal, &info, PASS_REVOKE);
+		err = do_one_pass(journal, &info, PASS_REVOKE, NULL, NULL);
 	if (!err)
-		err = do_one_pass(journal, &info, PASS_REPLAY);
+		err = do_one_pass(journal, &info, PASS_REPLAY, callback, data);
 
 	jbd2_debug(1, "JBD2: recovery, exit status %d, "
 		  "recovered transactions %u to %u\n",
@@ -365,7 +369,7 @@ int jbd2_journal_skip_recovery(journal_t *journal)
 
 	memset (&info, 0, sizeof(info));
 
-	err = do_one_pass(journal, &info, PASS_SCAN);
+	err = do_one_pass(journal, &info, PASS_SCAN, NULL, NULL);
 
 	if (err) {
 		printk(KERN_ERR "JBD2: error %d scanning journal\n", err);
@@ -585,8 +589,9 @@ skip_write:
 	return ret;
 }
 
-static int do_one_pass(journal_t *journal,
-			struct recovery_info *info, enum passtype pass)
+static int do_one_pass(journal_t *journal, struct recovery_info *info,
+		       enum passtype pass, jbd2_replay_callback_t callback,
+		       void *data)
 {
 	unsigned int		first_commit_ID, next_commit_ID;
 	unsigned long		next_log_block, head_block;
@@ -936,10 +941,25 @@ chksum_ok:
 		}
 	}
 
-	if (jbd2_has_feature_fast_commit(journal) &&  pass != PASS_REVOKE) {
+	/* Only PASS_REPLAY can carry a validation callback. */
+	if (callback) {
+		/*
+		 * Leave a failed commit for the load path to report. At
+		 * that point we already know recovery cannot succeed.
+		 */
+		if (success || journal->j_failed_commit)
+			return success;
+		err = callback(journal, data, false);
+		if (err)
+			return err;
+	}
+
+	if (jbd2_has_feature_fast_commit(journal) && pass != PASS_REVOKE) {
 		err = fc_do_one_pass(journal, info, pass);
 		if (err)
 			success = err;
+		else if (callback)
+			success = callback(journal, data, true);
 	}
 
 	return success;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 69f1236..28358c6 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1565,9 +1565,14 @@ extern int	   jbd2_journal_set_features
 		   (journal_t *, unsigned long, unsigned long, unsigned long);
 extern void	   jbd2_journal_clear_features
 		   (journal_t *, unsigned long, unsigned long, unsigned long);
+typedef int (*jbd2_replay_callback_t)(journal_t *journal, void *data,
+				      bool after_fast_commit);
 extern int	   jbd2_journal_load       (journal_t *journal);
+int jbd2_journal_load_with_callback(journal_t *journal,
+				    jbd2_replay_callback_t callback, void *data);
 extern int	   jbd2_journal_destroy    (journal_t *);
-extern int	   jbd2_journal_recover    (journal_t *journal);
+int jbd2_journal_recover(journal_t *journal,
+			 jbd2_replay_callback_t callback, void *data);
 extern int	   jbd2_journal_wipe       (journal_t *, int);
 extern int	   jbd2_journal_skip_recovery	(journal_t *);
 extern void	   jbd2_journal_update_sb_errno(journal_t *);

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143355;
	b=3jbWc0bgFmD6g+cDPc4isRxObYj4GW43rK9ZiTaeMLEZwTl4bQpSjR+VZnm8PfPu4bqj
	 HsUNBaTv5Br8nfW/k8WeGGnPkCd6KyGU1kV8rjPWPWwDRI9bk8gbT+giVgtF4mwQyuIg8
	 ER4yGatOw4B8laxQ+Tr4mV+ghsQZIutMzs/6GG3xKUrXR56FrtBVamQSDzjGaU4jXmisP
	 EDaTkH7zCUugkAO/cvuqIVq5ZUYbkorArYUYaXbf2XbbjKt9BIyWjhf1EigD5BZ6YSe9l
	 Tlgj0Vg+3AxXJv5xQIiZYsFraWVsIcNm5Ti2077pTkZu14Sm0xWEZPcbzNgR/N8Z/eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143355;
	h=DMARC-Filter:DKIM-Signature:Mime-Version:X-Original-From:Subject:
	 Date:X-Mailer:Content-Type:From:Message-Id:Content-Transfer-Encoding:
	 X-Lms-Return-Path:To:Cc;
	bh=juM1+8sqQHExnx7dticPglEVplrLkcQAD1B43yUSAM4=;
	b=dhrxmE1CS3AOwAfBfYVFrdTmts5KxsCR1QaBC0Ia0GRrn++YMc6MQ1NnxO7pwEF3glpG
	 0J239sRxrPYletv+rd0VvoqOoZ5kc/XqnVkh7K1nszwQ1ukySE6wpcnx7TcVoFFxgBbAE
	 UfTeX8zldylaMdUurBTsXhCN2TIqXCWNnAHASVca92TMTFNzUAiCWEgo8TrFswI1kU7ea
	 n3n/Ysz4kBIZv3Lf+DtLPa+CZv1RQ8viicysqTavgaaY0Z1Ux6gOz88OCHfumHIh37IGP
	 5OVEexN8po7POecDn1L4Lz6/sV76e5o13fOTJSoYJFgL3G0/clOfHj3E7WHoOTBKqBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=cY7ft5Yg;
	arc=none smtp.remote-ip=209.127.230.111
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643D0606A325
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 02:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 643D0606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=cY7ft5Yg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795143349; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=juM1+8sqQHExnx7dticPglEVplrLkcQAD1B43yUSAM4=;
 b=cY7ft5YghbGXm9p8qZUUylbAtpRbjX7kfNifUa8KyDtx5Gma6xo4FFgS1qsqOlgkQ+RndZ
 VJ2HUynl5iwEvwTR2WuSIKRM/MDLCdrkaOiZdpsku0Nc+3JOeJOV6O6tV974ZNDwxONGld
 wCWbZejsA5WFxboVxLFU3fCNs29ch8VFe1HQmoShs1u3WsjS0zllaUMbnTQtsMnqFXnbZ7
 oT98kOpBk84UBMyp3+9+av69gyIFSDvt90DBEWIv/yr05SHcdMQayOjIdye+q3sgJCsZPV
 YFVY8pSfAkt2Jy7uamH6aMaeuWcZo49r4eucx4z6BzI1TioD+nPZJOy3KO5KUw==
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Subject: [PATCH v3 1/2] jbd2: add a metadata validation hook to journal recovery
Date: Fri, 20 Nov 2026 10:54:58 +0800
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Message-Id: <20261120025459.70290-2-zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26affb6b3+3fef10+vger.kernel.org+zhaogongyi@bytedance.com>
To: <linux-ext4@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <tytso@mit.edu>, 
	<adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>

Filesystems can need to validate metadata that block replay has changed
before fast commit replay consumes it. They can also need to check
metadata that fast commit replay updates before completing recovery.

Provide an optional callback after block replay, including when the
journal is empty, and after fast commit replay. Propagate validation
errors before resetting the journal. Keep the existing replay flow for
callers of jbd2_journal_load().

Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
 fs/jbd2/journal.c    | 22 ++++++++++++++++------
 fs/jbd2/recovery.c   | 38 +++++++++++++++++++++++++++-----------
 include/linux/jbd2.h |  7 ++++++-
 3 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index eb8e944..383606a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2079,20 +2079,24 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 
 /**
- * jbd2_journal_load() - Read journal from disk.
+ * jbd2_journal_load_with_callback() - Read journal from disk.
  * @journal: Journal to act on.
+ * @callback: Optional validation callback for recovery.
+ * @data: Private data for the replay callback.
  *
- * Given a journal_t structure which tells us which disk blocks contain
- * a journal, read the journal from disk to initialise the in-memory
- * structures.
+ * Read the journal from disk and initialise the in-memory structures.
+ * Call @callback with after_fast_commit false after block replay,
+ * including for an empty journal, and with true after fast commit
+ * replay. A callback error stops recovery before the journal is reset.
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
@@ -2125,6 +2129,12 @@ int jbd2_journal_load(journal_t *journal)
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
index cac8c2c..be4fd27 100644
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
@@ -936,10 +941,21 @@ chksum_ok:
 		}
 	}
 
-	if (jbd2_has_feature_fast_commit(journal) &&  pass != PASS_REVOKE) {
+	/* Only PASS_REPLAY can carry a validation callback. */
+	if (callback) {
+		if (success)
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

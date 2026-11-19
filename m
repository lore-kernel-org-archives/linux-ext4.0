Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795091211;
	b=GY1xCom7VIP3WZ89c8Wf4OEb8sdhHcervfCEc99C80TOdYd/QSAvErdowfsP4Y8YAXRG
	 fM7lIH2YMBhTVwR69OEXua0HCairI2mfYvD8KkZzTaR75jauxqPZ87VeWOkosyUTnS3+E
	 XnKUqd7y9KX+pbNQZd0JXtq737kD/91TmqGTmAsDD+ke68Ry3+zMFPRjhsE6gvdroRQgi
	 9QzPCZOTfrkJzWxtg7R+A1lFpB+Ls3D3gy/Moaj4uXdHd65chffhgBWIglYAYoVY4pNEL
	 Fwf8vccAgD4D4fMhpZ362qD3ANmkZqVjw18MFCqRzS+/HNFJPYjqUaUIcKMj/XM94AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795091211;
	h=DMARC-Filter:DKIM-Signature:Mime-Version:X-Lms-Return-Path:
	 References:X-Mailer:Content-Type:To:From:Subject:Date:X-Original-From:
	 In-Reply-To:Content-Transfer-Encoding:Cc:Message-Id;
	bh=juM1+8sqQHExnx7dticPglEVplrLkcQAD1B43yUSAM4=;
	b=NdQrQ/+2bRPPArfCp7Dv5z4RdpG92leWFyWpwhYBbRIx6qTwlJEIBe8Gscq5XdERM3ak
	 vloX+k7XrD6sy8C1pEzMVG1mCKEPTLpd6AjzHRvI76qoPTyjp6lQAi7sYJjrAKmvBzsoW
	 sQt6TMC9/kgogomKhrg7rZw+M/+HFWlwX+PLgUbzlBfOlWJ/MHWs8T2M4YisJSME/QAIi
	 Jm4gf39G/IEX5QmfQfgB7U/DRkPV1Ua4j7KZ4Xj9Q8YEtV8U1vMpi0ikhE8fEN5UTSHBl
	 uXO1Aj6KYbW9c7Y3mUQjupgxVg6h4oSYHYEx7BAn//s70e/N6GgtCH2Bxt7fMbnH1kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=iLOVjm6b;
	arc=none smtp.remote-ip=209.127.230.113
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD06C606A33E
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 12:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD06C606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=iLOVjm6b
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795091203; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=juM1+8sqQHExnx7dticPglEVplrLkcQAD1B43yUSAM4=;
 b=iLOVjm6btJejBKwgqxn0nDj40MVswVHscCGq/xf5abeey2gKvrhzKf3AF+eJzTe5mfQ884
 R2NYxPNB13BIOcya+LmZeR+h7eKVaZceLxuqQ7Ar7EgneemDAtqf7USTnlIduF5hQqrK4r
 VJDhDmXtYZRXaQTeXtty2p/BpYvV4CI3WmxoDHldaXpwL1455dS496aEc4AQD9RMPoxfsD
 Tiz77eERvrtVk5JtQBkfVZzXQeZYDq8IcpJxlT5LxX78Tck0DuKoS9pqkrXd0heUK2jB2G
 zj0Nei38l7gxHsnfxaC3HSgkXva9ty0Atf12qU96P+GxJdqL+XpGzdC04rw+vQ==
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26afeeb02+ac3fae+vger.kernel.org+zhaogongyi@bytedance.com>
References: <20261119122601.85293-1-zhaogongyi@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
To: <linux-ext4@vger.kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Subject: [PATCH v2 1/2] jbd2: add a metadata validation hook to journal recovery
Date: Thu, 19 Nov 2026 20:26:00 +0800
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
In-Reply-To: <20261119122601.85293-1-zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: "Zhao Gongyi" <zhaogongyi@bytedance.com>, <linux-kernel@vger.kernel.org>, 
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>
Message-Id: <20261119122601.85293-2-zhaogongyi@bytedance.com>

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

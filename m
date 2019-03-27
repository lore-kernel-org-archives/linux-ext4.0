Return-Path: <SRS0=Z8NG=R6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15C3C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 18:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4BE5217D9
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 18:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553710710;
	bh=u07zAHoQnx3H7wffS7KsFe9oqFn3DnUA+UcbqYEkda8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ssGjZajOEbvIP7iFJ4r5E6BblK+HUDUo+A/DEHpri4QH80ajRP6AOv4SiBuyPsNJ9
	 cLAtblVXNRJ6an9O3JHmdKCvT/90kSbr8DRBA2inzf3Ly04FEowq0brvStZdrcP5iW
	 jdLouKVkuYbLKv5hjolxMhjqLSe+T6TWsxlyDJRI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390491AbfC0SSZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390479AbfC0SSY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Mar 2019 14:18:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793802087C;
        Wed, 27 Mar 2019 18:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710703;
        bh=u07zAHoQnx3H7wffS7KsFe9oqFn3DnUA+UcbqYEkda8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC40Dm8bCQCnfHcKmk9M5Ie06klh7P0nBp09xohQpMABEnL3nkkbPZAYiOWTqoTPf
         PdOfSDMbTPr3zYPN7cMAkQPA/0sEescO7N/gsNrhAuEBsceHQbzql9BnzIsW2n4JMz
         uPiLfvrAV4R5sTVoTaO7LXqWUFG/+E+VR9eEruLk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 064/123] jbd2: fix race when writing superblock
Date:   Wed, 27 Mar 2019 14:15:28 -0400
Message-Id: <20190327181628.15899-64-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181628.15899-1-sashal@kernel.org>
References: <20190327181628.15899-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 538bcaa6261b77e71d37f5596c33127c1a3ec3f7 ]

The jbd2 superblock is lockless now, so there is probably a race
condition between writing it so disk and modifing contents of it, which
may lead to checksum error. The following race is the one case that we
have captured.

jbd2                                fsstress
jbd2_journal_commit_transaction
 jbd2_journal_update_sb_log_tail
  jbd2_write_superblock
   jbd2_superblock_csum_set         jbd2_journal_revoke
                                     jbd2_journal_set_features(revork)
                                     modify superblock
   submit_bh(checksum incorrect)

Fix this by locking the buffer head before modifing it.  We always
write the jbd2 superblock after we modify it, so this just means
calling the lock_buffer() a little earlier.

This checksum corruption problem can be reproduced by xfstests
generic/475.

Reported-by: zhangyi (F) <yi.zhang@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 52 ++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 61d48f0c41a1..0c8f77db60e2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1343,6 +1343,10 @@ static int journal_reset(journal_t *journal)
 	return jbd2_journal_start_thread(journal);
 }
 
+/*
+ * This function expects that the caller will have locked the journal
+ * buffer head, and will return with it unlocked
+ */
 static int jbd2_write_superblock(journal_t *journal, int write_flags)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
@@ -1352,7 +1356,6 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
-	lock_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the journal
@@ -1411,6 +1414,7 @@ int jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
 	jbd_debug(1, "JBD2: updating superblock (start %lu, seq %u)\n",
 		  tail_block, tail_tid);
 
+	lock_buffer(journal->j_sb_buffer);
 	sb->s_sequence = cpu_to_be32(tail_tid);
 	sb->s_start    = cpu_to_be32(tail_block);
 
@@ -1441,18 +1445,17 @@ static void jbd2_mark_journal_empty(journal_t *journal, int write_op)
 	journal_superblock_t *sb = journal->j_superblock;
 
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
-	read_lock(&journal->j_state_lock);
-	/* Is it already empty? */
-	if (sb->s_start == 0) {
-		read_unlock(&journal->j_state_lock);
+	lock_buffer(journal->j_sb_buffer);
+	if (sb->s_start == 0) {		/* Is it already empty? */
+		unlock_buffer(journal->j_sb_buffer);
 		return;
 	}
+
 	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
 		  journal->j_tail_sequence);
 
 	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    = cpu_to_be32(0);
-	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, write_op);
 
@@ -1475,9 +1478,8 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	journal_superblock_t *sb = journal->j_superblock;
 	int errcode;
 
-	read_lock(&journal->j_state_lock);
+	lock_buffer(journal->j_sb_buffer);
 	errcode = journal->j_errno;
-	read_unlock(&journal->j_state_lock);
 	if (errcode == -ESHUTDOWN)
 		errcode = 0;
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n", errcode);
@@ -1881,28 +1883,27 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 
 	sb = journal->j_superblock;
 
+	/* Load the checksum driver if necessary */
+	if ((journal->j_chksum_driver == NULL) &&
+	    INCOMPAT_FEATURE_ON(JBD2_FEATURE_INCOMPAT_CSUM_V3)) {
+		journal->j_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
+		if (IS_ERR(journal->j_chksum_driver)) {
+			printk(KERN_ERR "JBD2: Cannot load crc32c driver.\n");
+			journal->j_chksum_driver = NULL;
+			return 0;
+		}
+		/* Precompute checksum seed for all metadata */
+		journal->j_csum_seed = jbd2_chksum(journal, ~0, sb->s_uuid,
+						   sizeof(sb->s_uuid));
+	}
+
+	lock_buffer(journal->j_sb_buffer);
+
 	/* If enabling v3 checksums, update superblock */
 	if (INCOMPAT_FEATURE_ON(JBD2_FEATURE_INCOMPAT_CSUM_V3)) {
 		sb->s_checksum_type = JBD2_CRC32C_CHKSUM;
 		sb->s_feature_compat &=
 			~cpu_to_be32(JBD2_FEATURE_COMPAT_CHECKSUM);
-
-		/* Load the checksum driver */
-		if (journal->j_chksum_driver == NULL) {
-			journal->j_chksum_driver = crypto_alloc_shash("crc32c",
-								      0, 0);
-			if (IS_ERR(journal->j_chksum_driver)) {
-				printk(KERN_ERR "JBD2: Cannot load crc32c "
-				       "driver.\n");
-				journal->j_chksum_driver = NULL;
-				return 0;
-			}
-
-			/* Precompute checksum seed for all metadata */
-			journal->j_csum_seed = jbd2_chksum(journal, ~0,
-							   sb->s_uuid,
-							   sizeof(sb->s_uuid));
-		}
 	}
 
 	/* If enabling v1 checksums, downgrade superblock */
@@ -1914,6 +1915,7 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 	sb->s_feature_compat    |= cpu_to_be32(compat);
 	sb->s_feature_ro_compat |= cpu_to_be32(ro);
 	sb->s_feature_incompat  |= cpu_to_be32(incompat);
+	unlock_buffer(journal->j_sb_buffer);
 
 	return 1;
 #undef COMPAT_FEATURE_ON
-- 
2.19.1


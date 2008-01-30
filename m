From: Jan Kara <jack@suse.cz>
Subject: [PATCH RESEND] jbd: Remove useless loop in
	journal_write_commit_record()
Date: Wed, 30 Jan 2008 11:08:00 +0100
Message-ID: <20080130100800.GB16140@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49235 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750964AbYA3KIB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 05:08:01 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  resending the patch just in case you've missed it.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Commit block was intended to have several copies of the header. But
due to a bug it never had them and actually, nobody checks that. So
just remove the useless loop.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 610264b..b54948f 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -104,7 +104,8 @@ static int journal_write_commit_record(journal_t *journal,
 {
 	struct journal_head *descriptor;
 	struct buffer_head *bh;
-	int i, ret;
+	journal_header_t *header;
+	int ret;
 	int barrier_done = 0;
 
 	if (is_journal_aborted(journal))
@@ -116,13 +117,10 @@ static int journal_write_commit_record(journal_t *journal,
 
 	bh = jh2bh(descriptor);
 
-	/* AKPM: buglet - add `i' to tmp! */
-	for (i = 0; i < bh->b_size; i += 512) {
-		journal_header_t *tmp = (journal_header_t*)bh->b_data;
-		tmp->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
-		tmp->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
-		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
-	}
+	header = (journal_header_t*)(bh->b_data);
+	header->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
+	header->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
+	header->h_sequence = cpu_to_be32(commit_transaction->t_tid);
 
 	JBUFFER_TRACE(descriptor, "write commit block");
 	set_buffer_dirty(bh);

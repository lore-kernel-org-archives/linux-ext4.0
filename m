From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix commit block write in JBD
Date: Wed, 23 Jan 2008 20:09:43 +0100
Message-ID: <20080123190943.GG10144@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:55392 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752506AbYAWTJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 14:09:45 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  the patch below fixes preparation of commit block in
journal_write_commit_record(). Obviously the bug doesn't really matter
since nobody reported it so far but let's cleanup the code... Andrew, could
you please queue it up? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Commit block is expected to have several copies of the header. Fix the
bug Andrew has spotted ages ago.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 610264b..a69b240 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -116,9 +116,8 @@ static int journal_write_commit_record(journal_t *journal,
 
 	bh = jh2bh(descriptor);
 
-	/* AKPM: buglet - add `i' to tmp! */
 	for (i = 0; i < bh->b_size; i += 512) {
-		journal_header_t *tmp = (journal_header_t*)bh->b_data;
+		journal_header_t *tmp = (journal_header_t*)(bh->b_data+i);
 		tmp->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
 		tmp->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
 		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);

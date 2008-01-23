From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix commit block write in JBD2
Date: Wed, 23 Jan 2008 20:10:54 +0100
Message-ID: <20080123191054.GH10144@duck.suse.cz>
References: <20080123190943.GG10144@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:55395 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753157AbYAWTKz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 14:10:55 -0500
Content-Disposition: inline
In-Reply-To: <20080123190943.GG10144@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 23-01-08 20:09:43, Jan Kara wrote:
>   Hi,
> 
>   the patch below fixes preparation of commit block in
> journal_write_commit_record(). Obviously the bug doesn't really matter
> since nobody reported it so far but let's cleanup the code... Andrew, could
> you please queue it up? Thanks.
  And the same fix for JBD2.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Commit block is expected to have several copies of the header. Fix the
bug Andrew has spotted ages ago.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6986f33..ed61283 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -116,9 +116,8 @@ static int journal_write_commit_record(journal_t *journal,
 
 	bh = jh2bh(descriptor);
 
-	/* AKPM: buglet - add `i' to tmp! */
 	for (i = 0; i < bh->b_size; i += 512) {
-		journal_header_t *tmp = (journal_header_t*)bh->b_data;
+		journal_header_t *tmp = (journal_header_t*)(bh->b_data+i);
 		tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
 		tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
 		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);

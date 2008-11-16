From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 10/20] jbd2: Fix buffer head leak when writing the commit block
Date: Sun, 16 Nov 2008 11:05:30 -0500
Message-ID: <1226851540-8032-11-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44730 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbYKPQhT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:37:19 -0500
In-Reply-To: <1226851540-8032-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also make sure the buffer heads are marked clean before submitting bh
for writing.  The previous code was marking the buffer head dirty,
which would have forced an unneeded write (and seek) to the journal
for no good reason.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 45a90bfd90c1215bf824c0f705b409723f52361b)
---
 fs/jbd2/commit.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f2ad061..6caf22d 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -126,8 +126,7 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
-	get_bh(bh);
-	set_buffer_dirty(bh);
+	clear_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
 
@@ -160,7 +159,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		/* And try again, without the barrier */
 		lock_buffer(bh);
 		set_buffer_uptodate(bh);
-		set_buffer_dirty(bh);
+		clear_buffer_dirty(bh);
 		ret = submit_bh(WRITE, bh);
 	}
 	*cbh = bh;
-- 
1.6.0.4.8.g36f27.dirty


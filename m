From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Fix oops in jbd2_journal_put_journal_head()
Date: Mon, 13 May 2013 15:31:56 +0200
Message-ID: <1368451916-16785-1-git-send-email-jack@suse.cz>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, eunb.song@samsung.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3EMNcE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 09:32:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit ae4647fb (jbd2: reduce journal_head size.) introduced a
regression where we occasionally hit panic in
jbd2_journal_put_journal_head() because of wrong b_jcount. The bug is
caused by gcc making 64-bit access to 32-bit bitfield and thus
clobbering b_jcount.

At least for now, those 8 bytes saved in struct journal_head are not
worth the trouble with gcc bitfield handling so revert that part of the
patch.

Reported-by: EUNBONG SONG <eunb.song@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/journal-head.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

  Ted, this should fix the regression reported by EUNBONG SONG. Please apply.

diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
index 13a3da2..3594c74 100644
--- a/include/linux/journal-head.h
+++ b/include/linux/journal-head.h
@@ -30,15 +30,19 @@ struct journal_head {
 
 	/*
 	 * Journalling list for this buffer [jbd_lock_bh_state()]
+	 * NOTE: We *cannot* combine this with b_modified into a bitfield
+	 * as gcc would then (correctly according to C++11) make 64-bit
+	 * accesses to the bitfield and clobber b_jcount if its update
+	 * races with bitfield modification.
 	 */
-	unsigned b_jlist:4;
+	unsigned b_jlist;
 
 	/*
 	 * This flag signals the buffer has been modified by
 	 * the currently running transaction
 	 * [jbd_lock_bh_state()]
 	 */
-	unsigned b_modified:1;
+	unsigned b_modified;
 
 	/*
 	 * Copy of the buffer data frozen for writing to the log.
-- 
1.8.1.4


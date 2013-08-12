From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix use after free after error in jbd2_journal_dirty_metadata()
Date: Mon, 12 Aug 2013 15:39:04 +0200
Message-ID: <1376314744-17678-1-git-send-email-jack@suse.cz>
Cc: Sage Weil <sage@inktank.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab3HLNjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Aug 2013 09:39:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When jbd2_journal_dirty_metadata() returns error,
__ext4_handle_dirty_metadata() stops the handle. However callers of this
function do not count with that fact and still happily used now freed
handle. This use after free can result in various issues but very likely
we oops soon.

The motivation of adding __ext4_journal_stop() into
__ext4_handle_dirty_metadata() in commit 9ea7a0df seems to be only to
improve error reporting. So replace __ext4_journal_stop() with
ext4_journal_abort_handle() which was there before that commit and add
WARN_ON_ONCE() to dump stack to provide useful information.

Reported-by: Sage Weil <sage@inktank.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 72a3600..735e946 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -255,10 +255,11 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 	set_buffer_prio(bh);
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
-		if (err) {
-			/* Errors can only happen if there is a bug */
-			handle->h_err = err;
-			__ext4_journal_stop(where, line, handle);
+		/* Errors can only happen if there is a bug */
+		if (WARN_ON_ONCE(err)) {
+			ext4_journal_abort_handle(where, line, __func__, bh,
+						  handle, err);
+			
 		}
 	} else {
 		if (inode)
-- 
1.8.1.4


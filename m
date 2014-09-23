From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] ext4: fix over-defensive complain after journal abort
Date: Tue, 23 Sep 2014 11:02:30 +0400
Message-ID: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:28482 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaIWHCl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 03:02:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4_jbd2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 0074e0d..3445035 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -256,8 +256,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 	set_buffer_prio(bh);
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
-		/* Errors can only happen if there is a bug */
-		if (WARN_ON_ONCE(err)) {
+		/* Errors can only happen due to aborted journal or a nasty bug */
+		if (!is_handle_aborted(handle) && WARN_ON_ONCE(err)) {
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
 			if (inode == NULL) {
-- 
1.7.1


From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: Fix ext4_ext_journal_restart()
Date: Sat, 02 Aug 2008 01:27:29 -0400
Message-ID: <E1KP9eL-0002TO-MH@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47922 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751648AbYHBF1b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 01:27:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The ext4_ext_journal_restart() is a convenience function which checks
to see if the requested number of credits is present, and if so it
closes the current transaction and attaches the current handle to the
new transaction.  Unfortunately, it wasn't proprely checking the
return value from ext4_journal_extend(), so it was starting a new
transaction when one was not necessary, and returning an error when
all that was necessary was to restart the handle with a new
transaction.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
This addresses the "orphan list check failed" which Frederic Bohe found
once the journal credits patch was applied.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dc6ca5e..b050259 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -99,7 +99,7 @@ static int ext4_ext_journal_restart(handle_t *handle, int needed)
 	if (handle->h_buffer_credits > needed)
 		return 0;
 	err = ext4_journal_extend(handle, needed);
-	if (err)
+	if (err <= 0)
 		return err;
 	return ext4_journal_restart(handle, needed);
 }

From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 06/53] ext4: return correct wbc.nr_to_write in ext4_da_writepages
Date: Sun, 30 May 2010 22:49:19 -0400
Message-ID: <1275274206-3900-6-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Richard Kennedy <richard@rsk.demon.co.uk>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44544 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Richard Kennedy <richard@rsk.demon.co.uk>

commit 2faf2e19dd0e060eeb32442858ef495ac3083277 upstream (as of v2.6.33-rc3)

When ext4_da_writepages increases the nr_to_write in writeback_control
then it must always re-base the return value.  Originally there was a
(misguided) attempt prevent wbc.nr_to_write from going negative.  In
fact, it's necessary to allow nr_to_write to be negative so that
wb_writeback() can correctly calculate how many pages were actually
written.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b81b76..89f4362 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3010,8 +3010,7 @@ retry:
 out_writepages:
 	if (!no_nrwrite_index_update)
 		wbc->no_nrwrite_index_update = 0;
-	if (wbc->nr_to_write > nr_to_writebump)
-		wbc->nr_to_write -= nr_to_writebump;
+	wbc->nr_to_write -= nr_to_writebump;
 	wbc->range_start = range_start;
 	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
 	return ret;
-- 
1.6.6.1.1.g974db.dirty


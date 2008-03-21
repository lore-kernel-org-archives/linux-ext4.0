From: akpm@linux-foundation.org
Subject: - jbd2-correctly-unescape-journal-data-blocks.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:35 -0700
Message-ID: <200803212029.m2LKTZRP008884@imap1.linux-foundation.org>
To: duaneg@dghda.com, jack@suse.cz, linux-ext4@vger.kernel.org,
	stable@kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758694AbYCUU3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd2: correctly unescape journal data blocks
has been removed from the -mm tree.  Its filename was
     jbd2-correctly-unescape-journal-data-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: correctly unescape journal data blocks
From: "Duane Griffin" <duaneg@dghda.com>

Fix a long-standing typo (predating git) that will cause data corruption if a
journal data block needs unescaping.  At the moment the wrong buffer head's
data is being unescaped.

To test this case mount a filesystem with data=journal, start creating and
deleting a bunch of files containing only JBD2_MAGIC_NUMBER (0xc03b3998), then
pull the plug on the device.  Without this patch the files will contain zeros
instead of the correct data after recovery.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/recovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jbd2/recovery.c~jbd2-correctly-unescape-journal-data-blocks fs/jbd2/recovery.c
--- a/fs/jbd2/recovery.c~jbd2-correctly-unescape-journal-data-blocks
+++ a/fs/jbd2/recovery.c
@@ -535,7 +535,7 @@ static int do_one_pass(journal_t *journa
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JBD2_FLAG_ESCAPE) {
-						*((__be32 *)bh->b_data) =
+						*((__be32 *)nbh->b_data) =
 						cpu_to_be32(JBD2_MAGIC_NUMBER);
 					}
 
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch
jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch


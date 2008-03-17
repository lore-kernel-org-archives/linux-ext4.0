From: akpm@linux-foundation.org
Subject: + jbd-correctly-unescape-journal-data-blocks.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:54:26 -0700
Message-ID: <200803172354.m2HNsR8S004736@imap1.linux-foundation.org>
Cc: duaneg@dghda.com, jack@suse.cz, linux-ext4@vger.kernel.org,
	stable@kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbYCQXyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 19:54:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: correctly unescape journal data blocks
has been added to the -mm tree.  Its filename is
     jbd-correctly-unescape-journal-data-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: correctly unescape journal data blocks
From: "Duane Griffin" <duaneg@dghda.com>

Fix a long-standing typo (predating git) that will cause data corruption if a
journal data block needs unescaping.  At the moment the wrong buffer head's
data is being unescaped.

To test this case mount a filesystem with data=journal, start creating and
deleting a bunch of files containing only JFS_MAGIC_NUMBER (0xc03b3998), then
pull the plug on the device.  Without this patch the files will contain zeros
instead of the correct data after recovery.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/recovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jbd/recovery.c~jbd-correctly-unescape-journal-data-blocks fs/jbd/recovery.c
--- a/fs/jbd/recovery.c~jbd-correctly-unescape-journal-data-blocks
+++ a/fs/jbd/recovery.c
@@ -478,7 +478,7 @@ static int do_one_pass(journal_t *journa
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JFS_FLAG_ESCAPE) {
-						*((__be32 *)bh->b_data) =
+						*((__be32 *)nbh->b_data) =
 						cpu_to_be32(JFS_MAGIC_NUMBER);
 					}
 
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-correctly-unescape-journal-data-blocks.patch
jbd2-correctly-unescape-journal-data-blocks.patch
jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch


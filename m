From: akpm@linux-foundation.org
Subject: + ext3-clean-up-outdated-and-incorrect-comment-for-ext3_write_super.patch added to -mm tree
Date: Tue, 11 Nov 2008 16:34:46 -0800
Message-ID: <200811120034.mAC0YkcO015566@imap1.linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbYKLAfa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 19:35:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: Clean up outdated and incorrect comment for ext3_write_super()
has been added to the -mm tree.  Its filename is
     ext3-clean-up-outdated-and-incorrect-comment-for-ext3_write_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: Clean up outdated and incorrect comment for ext3_write_super()
From: Theodore Tso <tytso@mit.edu>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/ext3/super.c~ext3-clean-up-outdated-and-incorrect-comment-for-ext3_write_super fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-clean-up-outdated-and-incorrect-comment-for-ext3_write_super
+++ a/fs/ext3/super.c
@@ -2375,12 +2375,9 @@ int ext3_force_commit(struct super_block
 /*
  * Ext3 always journals updates to the superblock itself, so we don't
  * have to propagate any other updates to the superblock on disk at this
- * point.  Just start an async writeback to get the buffers on their way
- * to the disk.
- *
- * This implicitly triggers the writebehind on sync().
+ * point.  (We can probably nuke this function altogether, and remove
+ * any mention to sb->s_dirt in all of fs/ext3; eventual cleanup...)
  */

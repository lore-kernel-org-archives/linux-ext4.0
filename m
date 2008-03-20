From: chrisw@sous-sol.org
Subject: patch jbd2-correctly-unescape-journal-data-blocks.patch queued to 2.6.24-stable tree
Date: Thu, 20 Mar 2008 16:32:21 -0700
Message-ID: <200803202332.m2KNWLw9027997@sous-sol.org>
References: <200803200245.m2K2j5Lw024656@hera.kernel.org>
Cc: stable@kernel.org, stable-commits@vger.kernel.org
To: duaneg@dghda.com, akpm@linux-foundation.org, chrisw@sous-sol.org,
	jack@suse.cz, linux-ext4@vger.kernel.org, stable@kernel.org,
	torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56375 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYCTXcv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 19:32:51 -0400
In-Reply-To: <200803200245.m2K2j5Lw024656@hera.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: jbd2: correctly unescape journal data blocks

to the 2.6.24-stable tree.  Its filename is

     jbd2-correctly-unescape-journal-data-blocks.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org  Thu Mar 20 16:12:49 2008
Date: Thu, 20 Mar 2008 02:45:05 GMT
Message-Id: <200803200245.m2K2j5Lw024656@hera.kernel.org>
From: jejb@kernel.org
To: jejb@kernel.org, stable@kernel.org
Subject: jbd2: correctly unescape journal data blocks

From: Duane Griffin <duaneg@dghda.com>
commit: d00256766a0b4f1441931a7f569a13edf6c68200

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/jbd2/recovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -488,7 +488,7 @@ static int do_one_pass(journal_t *journa
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JBD2_FLAG_ESCAPE) {
-						*((__be32 *)bh->b_data) =
+						*((__be32 *)nbh->b_data) =
 						cpu_to_be32(JBD2_MAGIC_NUMBER);
 					}
 


Patches currently in stable-queue which might be from duaneg@dghda.com are

queue-2.6.24/jbd2-correctly-unescape-journal-data-blocks.patch
queue-2.6.24/jbd-correctly-unescape-journal-data-blocks.patch

From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] don't call jbd2_journal_force_commit_nested w/o journal
Date: Wed, 25 Feb 2009 14:15:21 -0600
Message-ID: <49A5A6D9.2080602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbZBYUPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 15:15:25 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1PKFMCw005287
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 15:15:22 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PKFNW2026601
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 15:15:23 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n1PKFM3n004376
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 15:15:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Running without a journal, I oopsed when I ran out of space,
because we called jbd2_journal_force_commit_nested() from
ext4_should_retry_alloc() without a journal.

This should take care of it, I think.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/balloc.c
+++ linux-2.6/fs/ext4/balloc.c
@@ -609,7 +609,9 @@ int ext4_claim_free_blocks(struct ext4_s
  */
 int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) || (*retries)++ > 3)
+	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) ||
+	    (*retries)++ > 3 ||
+	    !EXT4_SB(sb)->s_journal)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c
+++ linux-2.6/fs/ext4/inode.c
@@ -2540,7 +2540,7 @@ retry:
 
 		ext4_journal_stop(handle);
 
-		if (mpd.retval == -ENOSPC) {
+		if ((mpd.retval == -ENOSPC) && sbi->s_journal) {
 			/* commit the transaction which would
 			 * free blocks released in the transaction
 			 * and try again


From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [5/7] Remove incorrect comment refering to lock_kernel() from jbd/jbd2
Date: Mon, 28 Jan 2008 11:16:14 +0100 (CET)
Message-ID: <20080128101614.A55DF152E1@wotan.suse.de>
References: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYA1KQP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:15 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id C419E309BF
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:14 +0100 (CET)
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


None of the callers of this function does actually take the BKL
as far as I can see. So remove the comment refering to the BKL.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/jbd/recovery.c  |    2 +-
 fs/jbd2/recovery.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/fs/jbd/recovery.c
===================================================================
--- linux.orig/fs/jbd/recovery.c
+++ linux/fs/jbd/recovery.c
@@ -354,7 +354,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
Index: linux/fs/jbd2/recovery.c
===================================================================
--- linux.orig/fs/jbd2/recovery.c
+++ linux/fs/jbd2/recovery.c
@@ -364,7 +364,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of

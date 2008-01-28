From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [2/7] Remove incorrect BKL comment in ext2
Date: Mon, 28 Jan 2008 11:16:11 +0100 (CET)
Message-ID: <20080128101611.78442152DF@wotan.suse.de>
References: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:33313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYA1KQM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:12 -0500
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 9CED327015
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:11 +0100 (CET)
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


No BKL used anywhere, so don't mention it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext2/inode.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/fs/ext2/inode.c
===================================================================
--- linux.orig/fs/ext2/inode.c
+++ linux/fs/ext2/inode.c
@@ -569,7 +569,6 @@ static void ext2_splice_branch(struct in
  *
  * `handle' can be NULL if create == 0.
  *
- * The BKL may not be held on entry here.  Be sure to take it early.
  * return > 0, # of blocks mapped or allocated.
  * return = 0, if plain lookup failed.
  * return < 0, error case.

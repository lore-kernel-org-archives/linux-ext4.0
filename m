From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't load the block bitmap for block groups which have no space
Date: Fri, 10 Aug 2012 14:21:25 -0400
Message-ID: <1344622885-14982-1-git-send-email-tytso@mit.edu>
References: <20120809181059.A5BAA11FC69@bugzilla.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44022 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759750Ab2HJSV1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2012 14:21:27 -0400
In-Reply-To: <20120809181059.A5BAA11FC69@bugzilla.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a short circuit check to ext4_mb_group_group() so that we don't
bother to load the block bitmap for a block group which does not have
any space available.  (Or which does not have enough space until we
are in desperation mode, i.e., when cr == 3.)

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=45741
Reported-by: mirek@me.com
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8eae947..3a57975 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1862,6 +1862,12 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 
 	BUG_ON(cr < 0 || cr >= 4);
 
+	free = grp->bb_free;
+	if (free == 0)
+		return 0;
+	if (cr <= 2 && free < ac->ac_g_ex.fe_len)
+		return 0;
+
 	/* We only do this if the grp has never been initialized */
 	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
 		int ret = ext4_mb_init_group(ac->ac_sb, group);
@@ -1869,10 +1875,7 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 			return 0;
 	}
 
-	free = grp->bb_free;
 	fragments = grp->bb_fragments;
-	if (free == 0)
-		return 0;
 	if (fragments == 0)
 		return 0;
 
-- 
1.7.12.rc0.22.gcdd159b


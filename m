Return-Path: <SRS0=3IYB=5D=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB589C10DCE
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Mar 2020 12:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEF102076D
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Mar 2020 12:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgCRMNX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:13:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:53666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgCRMNX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Mar 2020 08:13:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 722C4AC62;
        Wed, 18 Mar 2020 12:13:21 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B7ACA1E11A0; Wed, 18 Mar 2020 13:13:20 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Avoid ENOSPC when avoiding to reuse recently deleted inodes
Date:   Wed, 18 Mar 2020 13:13:17 +0100
Message-Id: <20200318121317.31941-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When ext4 is running on a filesystem without a journal, it tries not to
reuse recently deleted inodes to provide better chances for filesystem
recovery in case of crash. However this logic forbids reuse of freed
inodes for up to 5 minutes and especially for filesystems with smaller
number of inodes can lead to ENOSPC errors returned when allocating new
inodes.

Fix the problem by allowing to reuse recently deleted inode if there's
no other inode free in the scanned range.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ialloc.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

This patch is ramping down the enforcement of recently_deleted() logic rather
significantly. I believe it is fine since IMO it is better to reuse deleted
inode than to disrupt allocation patterns but there's also another option to
disable the recently_deleted() logic only if there's no free inode found in the
whole fs. I can switch to that if people think that it is OK for
recently_deleted() logic to push inode allocations to different group or so.

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f95ee99091e4..74f0fe145370 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -712,21 +712,34 @@ static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
 static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 			  struct buffer_head *bitmap, unsigned long *ino)
 {
+	bool check_recently_deleted = EXT4_SB(sb)->s_journal == NULL;
+	unsigned long recently_deleted_ino = EXT4_INODES_PER_GROUP(sb);
+
 next:
 	*ino = ext4_find_next_zero_bit((unsigned long *)
 				       bitmap->b_data,
 				       EXT4_INODES_PER_GROUP(sb), *ino);
 	if (*ino >= EXT4_INODES_PER_GROUP(sb))
-		return 0;
+		goto not_found;
 
-	if ((EXT4_SB(sb)->s_journal == NULL) &&
-	    recently_deleted(sb, group, *ino)) {
+	if (check_recently_deleted && recently_deleted(sb, group, *ino)) {
+		recently_deleted_ino = *ino;
 		*ino = *ino + 1;
 		if (*ino < EXT4_INODES_PER_GROUP(sb))
 			goto next;
-		return 0;
+		goto not_found;
 	}
-
+	return 1;
+not_found:
+	if (recently_deleted_ino >= EXT4_INODES_PER_GROUP(sb))
+		return 0;
+	/*
+	 * Not reusing recently deleted inodes is mostly a preference. We don't
+ 	 * want to report ENOSPC or skew allocation patterns because of that.
+	 * So return even recently deleted inode if we could find better in the
+	 * given range.
+	 */
+	*ino = recently_deleted_ino;
 	return 1;
 }
 
-- 
2.16.4


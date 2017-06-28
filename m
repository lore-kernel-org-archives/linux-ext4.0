From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] ext4: fix __ext4_xattr_set_credits()
Date: Wed, 28 Jun 2017 14:47:50 -0700
Message-ID: <20170628214750.31548-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36404 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdF1Vrz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jun 2017 17:47:55 -0400
Received: by mail-pf0-f171.google.com with SMTP id q86so39695859pfl.3
        for <linux-ext4@vger.kernel.org>; Wed, 28 Jun 2017 14:47:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__ext4_xattr_set_credits() calculates journal credits needed for a
set xattr operation. Currently, credits needed for quota updates are
added only if ea_inode feature is enabled which is wrong. Fix this by
moving quota related additions to above ea_inode feature check.

Fixes: 74c5bfa651af ("ext4: xattr inode deduplication")

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index ce12c3fb7e59..062756b4e6d8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -845,6 +845,9 @@ static int __ext4_xattr_set_credits(struct super_block *sb,
 	 */
 	credits = 5;
 
+	/* Quota updates. */
+	credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(sb);
+
 	/* We are done if ea_inode feature is not enabled. */
 	if (!ext4_has_feature_ea_inode(sb))
 		return credits;
@@ -878,9 +881,6 @@ static int __ext4_xattr_set_credits(struct super_block *sb,
 	/* Block bitmap and group descriptor updates for each block. */
 	credits += blocks * 2;
 
-	/* Quota updates. */
-	credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(sb);

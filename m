Return-Path: <SRS0=pPB2=6U=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED3BC47256
	for <linux-ext4@archiver.kernel.org>; Wed,  6 May 2020 18:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32BCA2078C
	for <linux-ext4@archiver.kernel.org>; Wed,  6 May 2020 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588789996;
	bh=fJhdJekRIWF69GjY+ppTTO1Bi64v5yi+lxSDuhmH5qE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=cWmcFbJxia8rUsoQLVgrfbcRABum2ficfnLjAbuD90fK4pCl6CiRW2OZ18TVtwMyC
	 5hV6o+LBGJ+D8CqPpmxfXxDWiYRclGAg7Lpf+rM+B/y1b2g512REpBukCfo3LAv7g8
	 u8tX3XJ0eferzvXWZjT2npHn2Hm/nhPIZN6aJyf8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgEFSdP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 May 2020 14:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbgEFSdO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 May 2020 14:33:14 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1354206D5;
        Wed,  6 May 2020 18:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588789994;
        bh=fJhdJekRIWF69GjY+ppTTO1Bi64v5yi+lxSDuhmH5qE=;
        h=From:To:Cc:Subject:Date:From;
        b=uZDI+uutaqoaYBvVdUgDEI3NkcCLnh32FZiWQNB5wyy2CS1mBSdLZx1aWQuDzlODW
         HlTpwQsl1F7/kF8KwxYnWAlMH15MlUL18+qu2Y58ZytlBOiiVRE/NpGCZmQbbmg4cu
         03hoLWIfsc4y2PpME9jbNE8EI6Sq35xgmd60Xp6w=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: [PATCH] ext4: fix race between ext4_sync_parent() and rename()
Date:   Wed,  6 May 2020 11:31:40 -0700
Message-Id: <20200506183140.541194-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

'igrab(d_inode(dentry->d_parent))' without holding dentry->d_lock is
broken because without d_lock, d_parent can be concurrently changed due
to a rename().  Then if the old directory is immediately deleted, old
d_parent->inode can be NULL.  That causes a NULL dereference in igrab().

To fix this, use dget_parent() to safely grab a reference to the parent
dentry, which pins the inode.  This also eliminates the need to use
d_find_any_alias() other than for the initial inode, as we no longer
throw away the dentry at each step.

This is an extremely hard race to hit, but it is possible.  Adding a
udelay() in between the reads of ->d_parent and its ->d_inode makes it
reproducible on a no-journal filesystem using the following program:

    #include <fcntl.h>
    #include <unistd.h>

    int main()
    {
        if (fork()) {
            for (;;) {
                mkdir("dir1", 0700);
                int fd = open("dir1/file", O_RDWR|O_CREAT|O_SYNC);
                write(fd, "X", 1);
                close(fd);
            }
        } else {
            mkdir("dir2", 0700);
            for (;;) {
                rename("dir1/file", "dir2/file");
                rmdir("dir1");
            }
        }
    }

Fixes: d59729f4e794 ("ext4: fix races in ext4_sync_parent()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fsync.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e10206e7f4bbe7..093c359952cdba 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -44,30 +44,28 @@
  */
 static int ext4_sync_parent(struct inode *inode)
 {
-	struct dentry *dentry = NULL;
-	struct inode *next;
+	struct dentry *dentry, *next;
 	int ret = 0;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY))
 		return 0;
-	inode = igrab(inode);
+	dentry = d_find_any_alias(inode);
+	if (!dentry)
+		return 0;
 	while (ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
-		dentry = d_find_any_alias(inode);
-		if (!dentry)
-			break;
-		next = igrab(d_inode(dentry->d_parent));
+
+		next = dget_parent(dentry);
 		dput(dentry);
-		if (!next)
-			break;
-		iput(inode);
-		inode = next;
+		dentry = next;
+		inode = dentry->d_inode;
+
 		/*
 		 * The directory inode may have gone through rmdir by now. But
 		 * the inode itself and its blocks are still allocated (we hold
-		 * a reference to the inode so it didn't go through
-		 * ext4_evict_inode()) and so we are safe to flush metadata
-		 * blocks and the inode.
+		 * a reference to the inode via its dentry), so it didn't go
+		 * through ext4_evict_inode()) and so we are safe to flush
+		 * metadata blocks and the inode.
 		 */
 		ret = sync_mapping_buffers(inode->i_mapping);
 		if (ret)
@@ -76,7 +74,7 @@ static int ext4_sync_parent(struct inode *inode)
 		if (ret)
 			break;
 	}
-	iput(inode);
+	dput(dentry);
 	return ret;
 }
 
-- 
2.26.2


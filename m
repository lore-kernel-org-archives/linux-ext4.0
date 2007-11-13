From: Adrian Bunk <bunk@kernel.org>
Subject: [RFC: 2.6.16 patch] return ENOENT from ext3_link when racing with
	unlink
Date: Tue, 13 Nov 2007 11:05:25 +0100
Message-ID: <20071113100525.GA4250@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54095 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751376AbXKMKFs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2007 05:05:48 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It seems the commit below (I've removed the ext4 part that doesn't 
apply) should also be included in the 2.6.16 branch, or do I miss 
anything?

TIA
Adrian


commit 2988a7740dc0dd9a0cb56576e8fe1d777dff0db3
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Feb 10 01:46:16 2007 -0800

    [PATCH] return ENOENT from ext3_link when racing with unlink
    
    Return -ENOENT from ext[34]_link if we've raced with unlink and i_nlink is
    0.  Doing otherwise has the potential to corrupt the orphan inode list,
    because we'd wind up with an inode with a non-zero link count on the list,
    and it will never get properly cleaned up & removed from the orphan list
    before it is freed.
    
    [akpm@osdl.org: build fix]
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Cc: <linux-ext4@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4df39c4..57402b5 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2191,6 +2191,12 @@ static int ext3_link (struct dentry * old_dentry,
 
 	if (inode->i_nlink >= EXT3_LINK_MAX)
 		return -EMLINK;
+	/*
+	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
+	 * otherwise has the potential to corrupt the orphan inode list.
+	 */
+	if (inode->i_nlink == 0)
+		return -ENOENT;
 
 retry:
 	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +

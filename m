From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] [RESEND] return ENOENT from ext3_link when racing with unlink
Date: Tue, 23 Jan 2007 11:23:56 -0600
Message-ID: <45B644AC.5030109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965012AbXAWRXn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jan 2007 12:23:43 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

(resend now that LCA is done)

An update from the earlier thread, 
[PATCH] [RFC] remove ext3 inode from orphan list when link and unlink race

I think this is better than the original idea of trying to handle the race;
I've seen that the orphan inode list can get corrupted, but there may well
be other implications of the race which haven't yet been exposed.  I think
it's safer to simply return -ENOENT in this race window, and avoid other
potential problems.  Anything wrong with this?

Thanks for the comments suggesting this approach in the prior thread.

Thanks,

-Eric

---

Return -ENOENT from ext[34]_link if we've raced with unlink and
i_nlink is 0.  Doing otherwise has the potential to corrupt the
orphan inode list, because we'd wind up with an inode with a
non-zero link count on the list, and it will never get properly
cleaned up & removed from the orphan list before it is freed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.19/fs/ext3/namei.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/namei.c
+++ linux-2.6.19/fs/ext3/namei.c
@@ -2191,6 +2191,8 @@ static int ext3_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT3_LINK_MAX)
 		return -EMLINK;
+	if (inode->i_nlink == 0)
+		return -ENOENT;
 
 retry:
 	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
Index: linux-2.6.19/fs/ext4/namei.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/namei.c
+++ linux-2.6.19/fs/ext4/namei.c
@@ -2189,6 +2189,8 @@ static int ext4_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
+	if (inode->i_nlink == 0)
+		return -ENOENT;
 
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +

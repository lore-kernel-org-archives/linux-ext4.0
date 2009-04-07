From: Dan Carpenter <error27@gmail.com>
Subject: [patch] missing unlock in ext2_quota_write()
Date: Tue, 7 Apr 2009 10:52:03 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0904070844220.820@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:38205 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZDGHzl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 03:55:41 -0400
Received: by ewy9 with SMTP id 9so2285372ewy.37
        for <linux-ext4@vger.kernel.org>; Tue, 07 Apr 2009 00:55:38 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The inode->i_mutex should be unlocked.

Found by smatch (http://repo.or.cz/w/smatch.git).  Compile tested.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/ext2/super.c	2009-04-07 08:42:15.000000000 +0300
+++ devel/fs/ext2/super.c	2009-04-07 08:43:19.000000000 +0300
@@ -1394,8 +1394,10 @@
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
 	inode->i_version++;

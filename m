From: roel kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] ext4: simple_strtol returns signed.
Date: Mon, 20 Oct 2008 22:00:48 -0400
Message-ID: <48FD37D0.6030509@gmail.com>
References: <48FA4558.2020603@gmail.com> <20081018143610.GA8383@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:35453 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYJTUAy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2008 16:00:54 -0400
Received: by ey-out-2122.google.com with SMTP id 6so639175eyi.37
        for <linux-ext4@vger.kernel.org>; Mon, 20 Oct 2008 13:00:52 -0700 (PDT)
In-Reply-To: <20081018143610.GA8383@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

simple_strtol returns signed, but a negative return values is lost when stored
in an unsigned. As suggested use simple_strtoul() instead. 

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Since p is dereferenced with the unsigned long return of simple_strtoul, I think
p should be a pointer to an unsigned long, am I wrong?

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9b2b2bc..0ab6cb4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3514,18 +3514,15 @@ static int ext4_ui_proc_open(struct inode *inode, struct file *file)
 static ssize_t ext4_ui_proc_write(struct file *file, const char __user *buf,
 			       size_t cnt, loff_t *ppos)
 {
-	unsigned int *p = PDE(file->f_path.dentry->d_inode)->data;
+	unsigned long *p = PDE(file->f_path.dentry->d_inode)->data;
 	char str[32];
-	unsigned long value;
 
 	if (cnt >= sizeof(str))
 		return -EINVAL;
 	if (copy_from_user(str, buf, cnt))
 		return -EFAULT;
-	value = simple_strtol(str, NULL, 0);
-	if (value < 0)
-		return -ERANGE;
-	*p = value;
+
+	*p = simple_strtoul(str, NULL, 0);
 	return cnt;
 }
 

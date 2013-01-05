From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ext4: remove duplicate assignment in ext4_init_new_dir()
Date: Sat,  5 Jan 2013 15:43:01 +0800
Message-ID: <1357371781-18194-3-git-send-email-yan@linux.vnet.ibm.com>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35795 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab3AEHnP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 02:43:15 -0500
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Sat, 5 Jan 2013 13:12:18 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 8EFD2E004C
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jan 2013 13:13:16 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r057h4nb40173668
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jan 2013 13:13:05 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r057h6jZ001803
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jan 2013 07:43:06 GMT
In-Reply-To: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It should be a typo unless I miss something.

Cc: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e249a47..db3b1e9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2368,7 +2368,6 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 	}
 
 	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
-	dir_block = ext4_bread(handle, inode, 0, 1, &err);
 	if (!(dir_block = ext4_bread(handle, inode, 0, 1, &err))) {
 		if (!err) {
 			err = -EIO;
-- 
1.7.9.5


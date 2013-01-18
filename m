From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ext4: remove unused variable in add_dirent_to_buf()
Date: Fri, 18 Jan 2013 16:01:12 +0800
Message-ID: <1358496074-6228-2-git-send-email-yan@linux.vnet.ibm.com>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55366 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3ARIBZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 03:01:25 -0500
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 18 Jan 2013 17:55:18 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 94DDC2CE804F
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:18 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0I81HD138469768
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:18 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0I81HSr031916
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:17 +1100
In-Reply-To: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After commit 978fef9 (create __ext4_insert_dentry for dir entry
insertion), 'reclen' is not used anymore.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a445247..b3717a3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1703,7 +1703,6 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	const char	*name = dentry->d_name.name;
 	int		namelen = dentry->d_name.len;
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
-	unsigned short	reclen;
 	int		csum_size = 0;
 	int		err;
 
@@ -1711,7 +1710,6 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
-	reclen = EXT4_DIR_REC_LEN(namelen);
 	if (!de) {
 		err = ext4_find_dest_de(dir, inode,
 					bh, bh->b_data, blocksize - csum_size,
-- 
1.7.9.5


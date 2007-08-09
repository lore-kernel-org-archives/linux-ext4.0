From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] dir_index: error out instead of BUG on corrupt hash dir limit
Date: Thu, 09 Aug 2007 16:33:36 -0500
Message-ID: <46BB8830.3060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXHIVdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2007 17:33:36 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l79LXZZG024789
	for <linux-ext4@vger.kernel.org>; Thu, 9 Aug 2007 17:33:35 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l79LXZmf007719
	for <linux-ext4@vger.kernel.org>; Thu, 9 Aug 2007 17:33:35 -0400
Received: from [127.0.0.1] (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l79LXYrr022509
	for <linux-ext4@vger.kernel.org>; Thu, 9 Aug 2007 17:33:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

A corrupt ondisk hash dir limit will trip an assert in dx_probe,
which calls BUG().  Instead, we can just issue the warning and
fail dx_probe like the other 3 tests just before it.  Thanks
to aviro for suggesting this...  Tested with a hand-crafted
corrupt ext3 image, issues:

EXT3-fs warning (device loop0): dx_probe: Corrupt limit in dir inode 14337

vs. previous:

Assertion failure in dx_probe() at fs/ext3/namei.c:383: "dx_get_limit(entries) == dx_root_limit(dir, root->info.info_length)"
------------[ cut here ]------------
kernel BUG at fs/ext3/namei.c:383!
...


Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22-rc4/fs/ext3/namei.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext3/namei.c
+++ linux-2.6.22-rc4/fs/ext3/namei.c
@@ -379,8 +379,16 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt limit in dir inode %ld\n", dir->i_ino);
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
Index: linux-2.6.22-rc4/fs/ext4/namei.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/namei.c
+++ linux-2.6.22-rc4/fs/ext4/namei.c
@@ -379,8 +379,16 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt limit in dir inode %ld\n", dir->i_ino);
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{

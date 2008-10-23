From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ext4: remove unused variable in ext4_get_parent
Date: Thu, 23 Oct 2008 20:33:29 +0200
Message-ID: <20081023183329.GA26003@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: torvalds@osdl.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40597 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYJWSdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2008 14:33:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ext4/namei.c
===================================================================
--- linux-2.6.orig/fs/ext4/namei.c	2008-10-23 20:32:28.000000000 +0200
+++ linux-2.6/fs/ext4/namei.c	2008-10-23 20:32:47.000000000 +0200
@@ -1061,7 +1061,6 @@ static struct dentry *ext4_lookup(struct
 struct dentry *ext4_get_parent(struct dentry *child)
 {
 	unsigned long ino;
-	struct dentry *parent;
 	struct inode *inode;
 	static const struct qstr dotdot = {
 		.name = "..",

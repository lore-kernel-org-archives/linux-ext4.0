From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/4] exofs: Handle error from d_splice_alias()
Date: Wed, 30 May 2012 13:39:08 +0300
Message-ID: <4FC5F8CC.20400@panasas.com>
References: <1338322067-17566-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:58570 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2E3Kpx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2012 06:45:53 -0400
In-Reply-To: <1338322067-17566-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


When directory hierarchy is corrupted and contains cycles, d_splice_alias() can
fail. Handle the failure cleanly.

Identical/coppied from:
	ext2: Handle error from d_splice_alias()
	Signed-off-by: Jan Kara <jack@suse.cz>

[exofs is just yet another copy/paste of ext2 code]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/namei.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index fc7161d..82de452 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -50,13 +50,19 @@ static struct dentry *exofs_lookup(struct inode *dir, struct dentry *dentry,
 {
 	struct inode *inode;
 	ino_t ino;
+	struct dentry *ret;
 
 	if (dentry->d_name.len > EXOFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
 	ino = exofs_inode_by_name(dir, dentry);
 	inode = ino ? exofs_iget(dir->i_sb, ino) : NULL;
-	return d_splice_alias(inode, dentry);
+	ret = d_splice_alias(inode, dentry);
+	if (IS_ERR(ret)) {
+		EXOFS_ERR("directory #%lu corrupted", dir->i_ino);
+		iput(inode);
+	}
+	return ret;
 }
 
 static int exofs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-- 
1.7.10.2.677.gb6bc67f


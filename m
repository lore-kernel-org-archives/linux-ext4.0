Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35227 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbeKUNQ5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 08:16:57 -0500
Received: by mail-pl1-f196.google.com with SMTP id v1-v6so3208954plo.2
        for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2018 18:44:35 -0800 (PST)
From: Eiichi Tsukata <devel@etsukata.com>
To: andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Cc: Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH v1 4/4] overlayfs: fix race between llseek SEEK_END and write
Date: Wed, 21 Nov 2018 11:44:00 +0900
Message-Id: <20181121024400.4346-5-devel@etsukata.com>
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
References: <20181121024400.4346-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement individual lock for SEEK_END for overlayfs which directly calls
generic_file_llseek_size().

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/overlayfs/file.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 84dd957efa24..57bc6538eea8 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -146,10 +146,27 @@ static int ovl_release(struct inode *inode, struct file *file)
 static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *realinode = ovl_inode_real(file_inode(file));
+	loff_t ret;
 
-	return generic_file_llseek_size(file, offset, whence,
-					realinode->i_sb->s_maxbytes,
-					i_size_read(realinode));
+	switch (whence) {
+	default:
+		return generic_file_llseek_size(file, offset, whence,
+						realinode->i_sb->s_maxbytes,
+						i_size_read(realinode));
+	case SEEK_END:
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		/*
+		 * protects against inode size race with write so that llseek
+		 * doesn't see inode size being updated in individual fs write
+		 */
+		inode_lock(realinode);
+		ret = generic_file_llseek_size(file, offset, whence,
+					       realinode->i_sb->s_maxbytes,
+					       i_size_read(realinode));
+		inode_unlock(realinode);
+		return ret;
+	}
 }
 
 static void ovl_file_accessed(struct file *file)
-- 
2.19.1

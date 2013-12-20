From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Fwd: [RESEND PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use
 cluster size
Date: Fri, 20 Dec 2013 13:13:33 +0800
Message-ID: <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com> <1387515880-10185-2-git-send-email-yangyongqiang01@baidu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44871 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3LTFN5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Dec 2013 00:13:57 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so822063eaj.1
        for <linux-ext4@vger.kernel.org>; Thu, 19 Dec 2013 21:13:56 -0800 (PST)
In-Reply-To: <1387515880-10185-2-git-send-email-yangyongqiang01@baidu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.

Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9115f28..1869fcf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -145,7 +145,7 @@ static int ext4_meta_trans_blocks(struct inode
*inode, int lblocks,
 static int ext4_inode_is_fast_symlink(struct inode *inode)
 {
        int ea_blocks = EXT4_I(inode)->i_file_acl ?
-               (inode->i_sb->s_blocksize >> 9) : 0;
+                       EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;

        return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks == 0);
 }
--
1.8.5.2

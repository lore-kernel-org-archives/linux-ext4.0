From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2 v2] ext4: Do not convert to indirect with bigalloc enabled
Date: Tue,  9 Apr 2013 13:24:47 +0200
Message-ID: <1365506687-9216-2-git-send-email-lczerner@redhat.com>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com>
Cc: gnehzuil.liu@gmail.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3DILYx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 07:24:53 -0400
In-Reply-To: <1365506687-9216-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With bigalloc feature enabled we do not support indirect addressing at all
so we have to prevent extent addressing to indirect addressing
conversion in this case. The problem has been introduced with the commit
"ext4: support simple conversion of extent-mapped inodes to use i_blocks"

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: added to the series

 fs/ext4/migrate.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 3464604..f13a289 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -625,6 +625,10 @@ int ext4_ind_migrate(struct inode *inode)
 	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EINVAL;
 
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+		return -EOPNOTSUPP;
+
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_ext_check_inode(inode);
 	if (ret)
-- 
1.7.7.6


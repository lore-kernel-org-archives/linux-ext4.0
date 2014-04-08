From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext2/3: check the acl's validity before setting
Date: Tue, 8 Apr 2014 10:04:09 +0800
Message-ID: <53435919.7000509@huawei.com>
References: <1396922030-4800-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:8246 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbaDHCEX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 22:04:23 -0400
In-Reply-To: <1396922030-4800-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Before setting the acl, call posix_acl_valid() to check if it is
valid or not.

Signed-off-by: zhang zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext2/acl.c |    6 ++++++
 fs/ext3/acl.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 27695e6..64b53b8 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -189,6 +189,12 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	size_t size = 0;
 	int error;

+	if (acl) {
+		error = posix_acl_valid(acl);
+		if (error < 0)
+			return error;
+	}
+
 	switch(type) {
 		case ACL_TYPE_ACCESS:
 			name_index = EXT2_XATTR_INDEX_POSIX_ACL_ACCESS;
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 8bbaf5b..68f873a 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -191,6 +191,12 @@ __ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 	size_t size = 0;
 	int error;

+	if (acl) {
+		error = posix_acl_valid(acl);
+		if (error < 0)
+			return error;
+	}
+
 	switch(type) {
 		case ACL_TYPE_ACCESS:
 			name_index = EXT3_XATTR_INDEX_POSIX_ACL_ACCESS;
-- 
1.6.0.2





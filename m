From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext4: check the acl's validity before setting
Date: Tue, 8 Apr 2014 10:02:50 +0800
Message-ID: <534358CA.3050808@huawei.com>
References: <1396922063-4879-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [119.145.14.66] ([119.145.14.66]:7438 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaDHCEB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 22:04:01 -0400
In-Reply-To: <1396922063-4879-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Before setting the acl, call posix_acl_valid() to check if it is
valid or not.

Signed-off-by: zhang zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext4/acl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index d40c8db..97f7650 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -197,6 +197,12 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 	size_t size = 0;
 	int error;

+	if (acl) {
+		error = posix_acl_valid(acl);
+		if (error < 0)
+			return error;
+	}
+
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
-- 
1.6.0.2





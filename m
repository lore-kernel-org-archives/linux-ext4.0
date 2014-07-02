From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext4: remove readpage() check up for mmap file
Date: Wed, 2 Jul 2014 12:01:56 +0800
Message-ID: <53B38434.7030500@huawei.com>
References: <1404273488-4612-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:1262 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaGBECQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jul 2014 00:02:16 -0400
In-Reply-To: <1404273488-4612-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no kind of file does not supply page reading function.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext4/file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8695f70..f5c0a17 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -202,8 +202,6 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct address_space *mapping = file->f_mapping;

-	if (!mapping->a_ops->readpage)
-		return -ENOEXEC;
 	file_accessed(file);
 	vma->vm_ops = &ext4_file_vm_ops;
 	return 0;
-- 
1.8.1.2


.





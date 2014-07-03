From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH v2] ext4: remove readpage() check up for mmap file
Date: Thu, 3 Jul 2014 14:18:31 +0800
Message-ID: <53B4F5B7.7060209@huawei.com>
References: <1404368274-10404-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <wangnan0@huawei.com>, "Zwisler, Ross" <ross.zwisler@intel.com>,
	"tytso@mit.edu" <tytso@mit.edu>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:17022 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaGCGSt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2014 02:18:49 -0400
In-Reply-To: <1404368274-10404-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no kind of file does not supply page reading function.

Change v1 -> v2:
- deleted the mapping variable

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext4/file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8695f70..aca7b24 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -200,10 +200,6 @@ static const struct vm_operations_struct ext4_file_vm_ops = {

 static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct address_space *mapping = file->f_mapping;

From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 16/21] ext3: add support for .read_iter and .write_iter
Date: Fri, 30 Mar 2012 10:43:43 -0500
Message-ID: <1333122228-13633-17-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43908 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091Ab2C3Pog (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2012 11:44:36 -0400
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zach Brown <zab@zabbo.net>

ext3 uses the generic .read_iter and .write_iter functions.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 724df69..30447a5 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -58,6 +58,8 @@ const struct file_operations ext3_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
-- 
1.7.9.5


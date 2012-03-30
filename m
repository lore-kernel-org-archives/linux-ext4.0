From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 18/21] ext4: add support for read_iter and write_iter
Date: Fri, 30 Mar 2012 10:43:45 -0500
Message-ID: <1333122228-13633-19-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46990 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab2C3Pod (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2012 11:44:33 -0400
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

use the generic .read_iter and .write_iter functions

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..ce76745 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -234,6 +234,8 @@ const struct file_operations ext4_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext4_file_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
-- 
1.7.9.5


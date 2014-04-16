From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling mode
Date: Thu, 17 Apr 2014 07:29:18 +0900
Message-ID: <002a01cf59c3$4eaf7490$ec0e5db0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33933 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPW3V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 18:29:21 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N45001Q7AGVXC10@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 07:29:19 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

xfstests generic/091 is failing when mounting ext4 with data=journal.
I think that this regression is same problem that occurred prior to collapse
range issue. So ZERO RANGE also need to call ext4_force_commit as
collapse range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f386dd6..a64242f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4742,6 +4742,13 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 
 	trace_ext4_zero_range(inode, offset, len, mode);
 
+	/* Call ext4_force_commit to flush all data in case of data=journal. */
+	if (ext4_should_journal_data(inode)) {
+		ret = ext4_force_commit(inode->i_sb);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
-- 
1.7.11-rc0


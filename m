From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 2/2] ext4: fix ZERO_RANGE test failure in data journalling
Date: Tue, 13 May 2014 09:10:55 +0900
Message-ID: <001401cf6e3f$cf49f7c0$6ddde740$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:39252 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaEMAK5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2014 20:10:57 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N5H0094AKI8V260@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 13 May 2014 09:10:56 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

xfstests generic/091 is failing when mounting ext4 with data=journal.
I think that this regression is same problem that occurred prior to collapse
range issue. So ZERO RANGE also need to call ext4_force_commit as
collapse range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1c5e877..02143d6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4743,6 +4743,15 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 
 	mutex_lock(&EXT4_I(inode)->i_write_mutex);
 
+	/* Call ext4_force_commit to flush all data in case of data=journal. */
+	if (ext4_should_journal_data(inode)) {
+		ret = ext4_force_commit(inode->i_sb);
+		if (ret) {
+			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
+			return ret;
+		}
+	}
+
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
-- 
1.7.11-rc0


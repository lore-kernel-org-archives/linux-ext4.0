From: akpm@linux-foundation.org
Subject: [patch 1/4] ext4: error proc entry creation when the fs/ext4 is not correctly created
Date: Sat, 12 Jul 2008 23:26:19 -0700
Message-ID: <200807130626.m6D6QKa3007907@imap1.linux-foundation.org>
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, shen@cn.fujitsu.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493AbYGMG0i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jul 2008 02:26:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shen Feng <shen@cn.fujitsu.com>

When the directory fs/ext4 is not correctly created under proc, the entry
under this directory should not be created.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ext4/mballoc.c~ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created
+++ a/fs/ext4/mballoc.c
@@ -2785,6 +2785,10 @@ static int ext4_mb_init_per_dev_proc(str
 	struct proc_dir_entry *proc;
 	char devname[64];
 
+	if (proc_root_ext4 == NULL) {
+		sbi->s_mb_proc = NULL;
+		return -EINVAL;
+	}
 	bdevname(sb->s_bdev, devname);
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
 
_

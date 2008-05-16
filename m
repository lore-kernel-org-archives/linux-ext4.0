From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: error proc entry creation when the fs/ext4 is not correctly
 created
Date: Fri, 16 May 2008 17:41:11 +0800
Message-ID: <482D56B7.1030607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYEPJnM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 05:43:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the directory fs/ext4 is not correctly created under proc,
the entry under this directory should not be created.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/mballoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b128bdc..3c616f2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2639,6 +2639,10 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	struct proc_dir_entry *proc;
 	char devname[64];

+	if (proc_root_ext4 == NULL) {
+		sbi->s_mb_proc = NULL;
+		return -EINVAL;
+	}
 	bdevname(sb->s_bdev, devname);
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);

-- 
1.5.4.1

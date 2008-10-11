From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] ext4/super: fix build failure without procfs
Date: Sun, 12 Oct 2008 01:52:16 +0400
Message-ID: <20081011215216.GB25563@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:29358 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYJKVwZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 17:52:25 -0400
Received: by fg-out-1718.google.com with SMTP id 19so742149fgg.17
        for <linux-ext4@vger.kernel.org>; Sat, 11 Oct 2008 14:52:23 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fs/ext4/super.c: In function 'ext4_fill_super':
fs/ext4/super.c:2226: error: 'ext4_ui_proc_fops' undeclared (first use
in this function)
fs/ext4/super.c:2226: error: (Each undeclared identifier is reported
only once
fs/ext4/super.c:2226: error: for each function it appears in.)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0e661c5..29823d4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2218,6 +2218,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
+#ifdef CONFIG_PROC_FS
 	if (ext4_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
 
@@ -2225,6 +2226,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		proc_create_data("inode_readahead_blks", 0644, sbi->s_proc,
 				 &ext4_ui_proc_fops,
 				 &sbi->s_inode_readahead_blks);
+#endif
 
 	bgl_lock_init(&sbi->s_blockgroup_lock);
 

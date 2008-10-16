From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] ext4: Remove compilation warnings in fs/ext4/mballoc.c
Date: Thu, 16 Oct 2008 15:33:02 +0530
Message-ID: <ea11fea30810160303w5a87b86bv88f181164fff9790@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Tso" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:34728 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYJPKDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 06:03:04 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1767087tic.23
        for <linux-ext4@vger.kernel.org>; Thu, 16 Oct 2008 03:03:02 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Below patch fixes the following compilation warnings
fs/ext4/mballoc.c:2717: warning: unused variable 'proc'
fs/ext4/mballoc.c:2715: warning: unused variable 'mode'

I think a cleaner fix would be to call these functions only when
CONFIG_PROC_FS is set and cleanup EXT4_PROC_HANDLER to be always
defined . Also since s_proc in sb only makes sense when procfs is
configured should that also be ifdef'd in the structure itself ??
Let me know if these cleanup can be done in a better way (or the way
you would prefer :-) . I can do this.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/mballoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b580714..c88b5ab 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2712,12 +2712,14 @@ ext4_mb_free_committed_blocks(struct super_block *sb)

 static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 {
+#ifdef CONFIG_PROC_FS
 	mode_t mode = S_IFREG | S_IRUGO | S_IWUSR;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct proc_dir_entry *proc;

 	if (sbi->s_proc == NULL)
 		return -EINVAL;
+#endif

 	EXT4_PROC_HANDLER(EXT4_MB_STATS_NAME, mb_stats);
 	EXT4_PROC_HANDLER(EXT4_MB_MAX_TO_SCAN_NAME, mb_max_to_scan);
@@ -2739,10 +2741,12 @@ err_out:

 static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 {
+#ifdef CONFIG_PROC_FS
 	struct ext4_sb_info *sbi = EXT4_SB(sb);

 	if (sbi->s_proc == NULL)
 		return -EINVAL;
+#endif

 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_proc);
-- 
1.5.4.3


Thanks -
Manish

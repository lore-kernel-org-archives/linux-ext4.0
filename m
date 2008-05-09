From: Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] Fix misuses of bdevname()
Date: Fri, 9 May 2008 13:20:14 +0200
Message-ID: <20080509132014.3379ae2f@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:40709 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYEILU0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 07:20:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bdevname() fills the buffer that it is given as a parameter, so
calling strcpy() or snprintf() on the returned value is redundant (and
probably not guaranteed to work - I don't think strcpy and snprintf
support overlapping buffers.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blktrace.c     |    2 +-
 block/compat_ioctl.c |    2 +-
 fs/ext4/mballoc.c    |    6 ++----
 fs/jbd2/journal.c    |    4 ++--
 4 files changed, 6 insertions(+), 8 deletions(-)

--- linux-2.6.26-rc1.orig/block/blktrace.c	2008-05-09 12:52:51.000000000 +0200
+++ linux-2.6.26-rc1/block/blktrace.c	2008-05-09 12:55:04.000000000 +0200
@@ -476,7 +476,7 @@ int blk_trace_ioctl(struct block_device 
 
 	switch (cmd) {
 	case BLKTRACESETUP:
-		strcpy(b, bdevname(bdev, b));
+		bdevname(bdev, b);
 		ret = blk_trace_setup(q, b, bdev->bd_dev, arg);
 		break;
 	case BLKTRACESTART:
--- linux-2.6.26-rc1.orig/block/compat_ioctl.c	2008-05-09 12:52:51.000000000 +0200
+++ linux-2.6.26-rc1/block/compat_ioctl.c	2008-05-09 12:55:04.000000000 +0200
@@ -555,7 +555,7 @@ static int compat_blk_trace_setup(struct
 	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
 		return -EFAULT;
 
-	strcpy(b, bdevname(bdev, b));
+	bdevname(bdev, b);
 
 	buts = (struct blk_user_trace_setup) {
 		.act_mask = cbuts.act_mask,
--- linux-2.6.26-rc1.orig/fs/ext4/mballoc.c	2008-05-09 12:52:51.000000000 +0200
+++ linux-2.6.26-rc1/fs/ext4/mballoc.c	2008-05-09 12:55:04.000000000 +0200
@@ -2639,8 +2639,7 @@ static int ext4_mb_init_per_dev_proc(str
 	struct proc_dir_entry *proc;
 	char devname[64];
 
-	snprintf(devname, sizeof(devname) - 1, "%s",
-		bdevname(sb->s_bdev, devname));
+	bdevname(sb->s_bdev, devname);
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
 
 	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
@@ -2674,8 +2673,7 @@ static int ext4_mb_destroy_per_dev_proc(
 	if (sbi->s_mb_proc == NULL)
 		return -EINVAL;
 
-	snprintf(devname, sizeof(devname) - 1, "%s",
-		bdevname(sb->s_bdev, devname));
+	bdevname(sb->s_bdev, devname);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
--- linux-2.6.26-rc1.orig/fs/jbd2/journal.c	2008-05-09 12:52:51.000000000 +0200
+++ linux-2.6.26-rc1/fs/jbd2/journal.c	2008-05-09 12:55:04.000000000 +0200
@@ -901,7 +901,7 @@ static void jbd2_stats_proc_init(journal
 {
 	char name[BDEVNAME_SIZE];
 
-	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
+	bdevname(journal->j_dev, name);
 	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
 		proc_create_data("history", S_IRUGO, journal->j_proc_entry,
@@ -915,7 +915,7 @@ static void jbd2_stats_proc_exit(journal
 {
 	char name[BDEVNAME_SIZE];
 
-	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
+	bdevname(journal->j_dev, name);
 	remove_proc_entry("info", journal->j_proc_entry);
 	remove_proc_entry("history", journal->j_proc_entry);
 	remove_proc_entry(name, proc_jbd2_stats);

-- 
Jean Delvare

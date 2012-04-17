From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 2/3] vfs: add security check for _NO_HIDE_STALE flag
Date: Wed, 18 Apr 2012 00:53:37 +0800
Message-ID: <1334681618-9452-3-git-send-email-wenqing.lz@taobao.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

A new variable is added to enable/disable _NO_HIDE_STALE flag becuase this
flag is possible to be abused.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/open.c              |   10 ++++++++++
 include/linux/sysctl.h |    1 +
 kernel/sysctl.c        |   10 ++++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 1d3117f..43fd39c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -213,6 +213,11 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
 #endif
 #endif /* BITS_PER_LONG == 32 */
 
+/*
+ * enable/disable FALLOC_FL_NO_HIDE_STALE flag
+ * 0: disable (default), 1: enable
+ */
+int sysctl_enable_falloc_no_hide_stale = 0;
 
 int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
@@ -249,6 +254,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (ret)
 		return ret;
 
+	/* Check for enabling _NO_HIDE_STALE flag */
+	if (mode & FALLOC_FL_NO_HIDE_STALE &&
+	    !sysctl_enable_falloc_no_hide_stale)
+		return -EPERM;
+
 	if (S_ISFIFO(inode->i_mode))
 		return -ESPIPE;
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index c34b4c8..484e5dc 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -820,6 +820,7 @@ enum
 	FS_AIO_NR=18,	/* current system-wide number of aio requests */
 	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
 	FS_INOTIFY=20,	/* inotify submenu */
+	FS_FALLOC_STALE=21,	/* enable fallocate _NO_HIDE_STALE flag */
 	FS_OCFS2=988,	/* ocfs2 */
 };
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..37de7c2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -108,6 +108,7 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
+extern int sysctl_enable_falloc_no_hide_stale;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
@@ -1517,6 +1518,15 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "falloc_no_hide_stale",
+		.data		= &sysctl_enable_falloc_no_hide_stale,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{ }
 };
 
-- 
1.7.4.1


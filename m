From: Abbas Raza <abbas_raza@mentor.com>
Subject: [PATCH 1/2] procfs: Add function to lookup a subdirectory name
Date: Sat, 21 Dec 2013 03:59:16 +0500
Message-ID: <1387580357-28440-1-git-send-email-abbas_raza@mentor.com>
Cc: Abbas Raza <Abbas_Raza@mentor.com>, Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:59750 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3LTW7i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Dec 2013 17:59:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Abbas Raza <Abbas_Raza@mentor.com>

Add function to lookup a subdirectory in a directory by given name

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Abbas Raza <Abbas_Raza@mentor.com>
---
 fs/proc/generic.c       | 18 ++++++++++++++++++
 include/linux/proc_fs.h |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b796da2..e4f2320 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -406,6 +406,24 @@ static const struct dentry_operations proc_dentry_operations =
 };
 
 /*
+ * Lookup if a subdirectory is present in the given directory by name
+ */
+int proc_lookup_subdir_by_name(struct proc_dir_entry *dir, const char *name)
+{
+	struct proc_dir_entry *tmp;
+	int ret = -ENOENT;
+
+	spin_lock(&proc_subdir_lock);
+	for (tmp = dir->subdir; tmp; tmp = tmp->next)
+		if (strcmp(tmp->name, name) == 0)
+			ret = 0;
+	spin_unlock(&proc_subdir_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(proc_lookup_subdir_by_name);
+
+/*
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
  */
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 32676b3..82acc6c 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -152,6 +152,8 @@ extern struct proc_dir_entry *proc_symlink(const char *,
 extern struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);
 extern struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
 			struct proc_dir_entry *parent);
+extern int proc_lookup_subdir_by_name(struct proc_dir_entry *,
+			const char *name);
 
 static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
 	struct proc_dir_entry *parent, const struct file_operations *proc_fops)
@@ -213,6 +215,8 @@ static inline struct proc_dir_entry *proc_mkdir(const char *name,
 	struct proc_dir_entry *parent) {return NULL;}
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
+static inline int proc_lookup_subdir_by_name(struct proc_dir_entry *,
+			const char *name) { return -ENOENT; }
 
 static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
 	umode_t mode, struct proc_dir_entry *base, 
-- 
1.8.3.2


From: akpm@linux-foundation.org
Subject: - jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:08:44 -0700
Message-ID: <200710190408.l9J48iMu014237@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, jack@suse.cz, jrs@us.ibm.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbXJSEJD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Oct 2007 00:09:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd-config_jbd_debug-cannot-create-proc-entry-fix
has been removed from the -mm tree.  Its filename was
     jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch

This patch was dropped because it was folded into jbd-config_jbd_debug-cannot-create-proc-entry.patch

------------------------------------------------------
Subject: jbd-config_jbd_debug-cannot-create-proc-entry-fix
From: Andrew Morton <akpm@linux-foundation.org>

- use `#ifdef foo' instead of `#if defined(foo)'

- CONFIG_JBD_DEBUG depends on CONFIG_DEBUG_FS so we don't need to duplicate
  that logic in the .c file ifdefs

- Make journal_enable_debug __read_mostly just for the heck of it

- Make jbd_debugfs_dir and jbd_debug static

- debugfs_remove(NULL) is legal: remove unneeded tests

- jbd_create_debugfs_entry is a better name than create_jbd_debugfs_entry

- ditto remove_jbd_debugfs_entry

- C functions are preferred over macros

- Avoid declaring multiple variables in a single line.

Cc: "Jose R. Santos" <jrs@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN fs/jbd/journal.c~jbd-config_jbd_debug-cannot-create-proc-entry-fix fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-config_jbd_debug-cannot-create-proc-entry-fix
+++ a/fs/jbd/journal.c
@@ -1858,16 +1858,15 @@ void journal_put_journal_head(struct jou
 /*
  * debugfs tunables
  */
-#if defined(CONFIG_JBD_DEBUG)
-u8 journal_enable_debug;
-EXPORT_SYMBOL(journal_enable_debug);
-#endif
+#ifdef CONFIG_JBD_DEBUG
 
-#if defined(CONFIG_JBD_DEBUG) && defined(CONFIG_DEBUG_FS)
+u8 journal_enable_debug __read_mostly;
+EXPORT_SYMBOL(journal_enable_debug);
 
-struct dentry  *jbd_debugfs_dir, *jbd_debug;
+static struct dentry *jbd_debugfs_dir;
+static struct dentry *jbd_debug;
 
-static void __init create_jbd_debugfs_entry(void)
+static void __init jbd_create_debugfs_entry(void)
 {
 	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
 	if (jbd_debugfs_dir)
@@ -1876,18 +1875,21 @@ static void __init create_jbd_debugfs_en
 					       &journal_enable_debug);
 }
 
-static void __exit remove_jbd_debugfs_entry(void)
+static void __exit jbd_remove_debugfs_entry(void)
 {
-	if (jbd_debug)
-		debugfs_remove(jbd_debug);
-	if (jbd_debugfs_dir)
-		debugfs_remove(jbd_debugfs_dir);
+	debugfs_remove(jbd_debug);
+	debugfs_remove(jbd_debugfs_dir);
 }
 
 #else
 
-#define create_jbd_debugfs_entry() do {} while (0)
-#define remove_jbd_debugfs_entry() do {} while (0)
+static inline void jbd_create_debugfs_entry(void)
+{
+}
+
+static inline void jbd_remove_debugfs_entry(void)
+{
+}
 
 #endif
 
@@ -1945,7 +1947,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		journal_destroy_caches();
-	create_jbd_debugfs_entry();
+	jbd_create_debugfs_entry();
 	return ret;
 }
 
@@ -1956,7 +1958,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
-	remove_jbd_debugfs_entry();
+	jbd_remove_debugfs_entry();
 	journal_destroy_caches();
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch

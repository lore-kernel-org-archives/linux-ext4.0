From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock
 to incorporate all users
Date: Tue, 11 Jun 2013 13:38:24 -0400
Message-ID: <20130611173824.GA29033@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370892723-30860-2-git-send-email-paul.gortmaker@windriver.com>
 <20130611021230.GA23966@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:41547 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3FKRhw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jun 2013 13:37:52 -0400
Content-Disposition: inline
In-Reply-To: <20130611021230.GA23966@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Re: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock to incorporate all users] On 10/06/2013 (Mon 22:12) Theodore Ts'o wrote:

> On Mon, Jun 10, 2013 at 03:32:00PM -0400, Paul Gortmaker wrote:
> > The state lock is taken after we are doing an assert on the state
> > value, not before.  It is also taken after the jbd_debug() call.
> > Noting that jbd_debug() is implemented with two separate printk()
> > calls, it can lead to corrupted and misleading debug output like
> > the following (see lines marked with "*"):
> 
> This is only a cosmetic fix, but instead of trying to fix it by moving
> a lock --- which would only fix this issue, but there are probably
> others cases where this might be an issue, I'd suggest fixing it with
> something like this:
> 
> /* in fs/jbd2/journal.c */
> void __jbd2_debug(int level, const char *func, unsigned int line, const char *fmt, ...)
> {
> 	struct va_format vaf;
> 	va_list args;
> 
> 	if (level < jbd2_journal_enable_debug)
> 		return;

I've changed "level <" for "level >" here....

> 	va_start(args, fmt);
> 	vaf.fmt = fmt;
> 	vaf.va = &args

...and added a ";" here.

> 	printk(KERN_DEBUG, "jbd2: (%s, %u): %pV\n", func, line, &vaf);

I'm so glad to see that I am not the only one who accidentally keeps
putting a comma after the KERN_<N> values.  :)

I'd thought about using pr_debug() but decided not to, since it is a
no-op without us actually defining DEBUG somewhere, and if we don't,
then people would wonder where their debug output went, I think.

> 	va_end(args);
> }
> 
> /* in jbd2.h */
> 
> #define jbd_debug(n, fmt, a...) __jbd2_debug((n), __func__, __LINE__, (fmt), ##a)
> 
> Could you give this approach a try?

Since both ext3 and ext4 will suffer the same problem, I've made
a combined solution.  It has passed a basic sanity test here, so
maybe if you have a spare moment, you could have a look to determine
if you are OK with the implementation, while I continue fixing up
the others and doing more testing?

Thanks,
Paul.
--

>From fbedf3102700b034395404dfdc7ac2dcae145af8 Mon Sep 17 00:00:00 2001
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 11 Jun 2013 11:46:10 -0400
Subject: [PATCH] jbd/jbd2: make common jbd_debug that won't split printk
 statements

Since the jbd_debug() is implemented with two separate printk()
calls, it can lead to corrupted and misleading debug output like
the following (see lines marked with "*"):

[  290.339362] (fs/jbd2/journal.c, 203): kjournald2: kjournald2 wakes
[  290.339365] (fs/jbd2/journal.c, 155): kjournald2: commit_sequence=42103, commit_request=42104
[  290.339369] (fs/jbd2/journal.c, 158): kjournald2: OK, requests differ
[* 290.339376] (fs/jbd2/journal.c, 648): jbd2_log_wait_commit:
[* 290.339379] (fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: want 42104, j_commit_sequence=42103
[* 290.339382] JBD2: starting commit of transaction 42104
[  290.339410] (fs/jbd2/revoke.c, 566): jbd2_journal_write_revoke_records: Wrote 0 revoke records
[  290.376555] (fs/jbd2/commit.c, 1088): jbd2_journal_commit_transaction: JBD2: commit 42104 complete, head 42079

i.e. the debug output from log_wait_commit and journal_commit_transaction
have become interleaved.  The output should have been:

(fs/jbd2/journal.c, 648): jbd2_log_wait_commit: JBD2: want 42104, j_commit_sequence=42103
(fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: starting commit of transaction 42104

It is expected that this is not easy to replicate -- I was only able
to cause it on preempt-rt kernels, and even then only under heavy
I/O load.  Ted suggested we make use of va_args to reduce it to a single
printk() call to fix it.

This was originally seen on ext4, but since ext3 should suffer the same
problem, I've taken the next step to make the jbd_debug a shared
implementation, so to fix ext3 and reduce duplication at the same time.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 6e5524f..ea88e8e 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -56,17 +56,9 @@
  */
 #define JBD_EXPENSIVE_CHECKING
 extern u8 journal_enable_debug;
-
-#define jbd_debug(n, f, a...)						\
-	do {								\
-		if ((n) <= journal_enable_debug) {			\
-			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __func__);	\
-			printk (f, ## a);				\
-		}							\
-	} while (0)
+#define JOURNAL_ENABLE_DEBUG journal_enable_debug
 #else
-#define jbd_debug(f, a...)	/**/
+#define JOURNAL_ENABLE_DEBUG INT_MAX
 #endif
 
 static inline void *jbd_alloc(size_t size, gfp_t flags)
@@ -245,6 +237,13 @@ typedef struct journal_superblock_s
 #include <linux/sched.h>
 #include <linux/jbd_common.h>
 
+#ifdef CONFIG_JBD_DEBUG
+#define jbd_debug(n, fmt, a...) \
+	__jbd_debug((n), __FILE__, __func__, __LINE__, (fmt), ##a)
+#else
+#define jbd_debug(n, fmt, a...)    /**/
+#endif
+
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
 #define J_ASSERT_BH(bh, expr)	J_ASSERT(expr)
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 9986ab8..c39a9ca 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -56,17 +56,9 @@
  */
 #define JBD2_EXPENSIVE_CHECKING
 extern ushort jbd2_journal_enable_debug;
-
-#define jbd_debug(n, f, a...)						\
-	do {								\
-		if ((n) <= jbd2_journal_enable_debug) {			\
-			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __func__);	\
-			printk (f, ## a);				\
-		}							\
-	} while (0)
+#define JOURNAL_ENABLE_DEBUG jbd2_journal_enable_debug
 #else
-#define jbd_debug(f, a...)	/**/
+#define JOURNAL_ENABLE_DEBUG INT_MAX
 #endif
 
 extern void *jbd2_alloc(size_t size, gfp_t flags);
@@ -303,6 +295,13 @@ typedef struct journal_superblock_s
 #include <linux/sched.h>
 #include <linux/jbd_common.h>
 
+#ifdef CONFIG_JBD2_DEBUG
+#define jbd_debug(n, fmt, a...) \
+	__jbd_debug((n), __FILE__, __func__, __LINE__, (fmt), ##a)
+#else
+#define jbd_debug(n, fmt, a...)    /**/
+#endif
+
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
 #define J_ASSERT_BH(bh, expr)	J_ASSERT(expr)
diff --git a/include/linux/jbd_common.h b/include/linux/jbd_common.h
index 949b5dd..c8e2fba 100644
--- a/include/linux/jbd_common.h
+++ b/include/linux/jbd_common.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_JBD_STATE_H
 #define _LINUX_JBD_STATE_H
 
+#include <linux/printk.h>
 #include <linux/bit_spinlock.h>
 
 enum jbd_state_bits {
@@ -29,6 +30,23 @@ TAS_BUFFER_FNS(RevokeValid, revokevalid)
 BUFFER_FNS(Freed, freed)
 BUFFER_FNS(Verified, verified)
 
+#if defined(CONFIG_JBD_DEBUG) || defined(CONFIG_JBD2_DEBUG)
+static inline void __jbd_debug(int level, const char *file, const char *func,
+			       unsigned int line, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	if (level > JOURNAL_ENABLE_DEBUG)
+		return;
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
+	va_end(args);
+}
+#endif
+
 static inline struct buffer_head *jh2bh(struct journal_head *jh)
 {
 	return jh->b_bh;
-- 
1.8.1.2

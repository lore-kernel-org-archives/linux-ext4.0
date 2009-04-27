From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH 1/2] have e2fsck/problem.c verify problem.h error codes
Date: Mon, 27 Apr 2009 16:59:24 -0600
Message-ID: <20090427225924.GG3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58198 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334AbZD0XAJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2009 19:00:09 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3RMxo4C006215
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2009 16:00:03 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIS00L007PCNS00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 27 Apr 2009 15:59:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've hit a number of cases where the error codes in problem.h have
been assigned duplicate values compared to problems in our own e2fsck
patches, and this can lead to confusing and difficult to find bugs
in e2fsck (e.g. wrong problem messages, incorrect repair action, etc).

Attached is a test case for the problem.c file to ensure that the
problem table is sorted and does not contain any duplicate values.
Having the problem table sorted allows the correctness checking to be
very simple, and if it ever became important for performance we could
use binary searching of the problem table for the specific problem code.

Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-1.41.5/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.41.5.orig/e2fsck/problem.c
+++ e2fsprogs-1.41.5/e2fsck/problem.c
@@ -240,15 +240,10 @@ static struct e2fsck_problem problem_tab
 	  N_("Clear @j"),
 	  PROMPT_NULL, PR_PREEN_NOMSG },
 
-	/* Ask if we should run the journal anyway */
-	{ PR_0_JOURNAL_RUN,
-	  N_("Run @j anyway"),
-	  PROMPT_NULL, 0 },
-
-	/* Run the journal by default */
-	{ PR_0_JOURNAL_RUN_DEFAULT,
-	  N_("Recovery flag not set in backup @S, so running @j anyway.\n"),
-	  PROMPT_NONE, 0 },
+	/* Filesystem revision is 0, but feature flags are set */
+	{ PR_0_FS_REV_LEVEL,
+	  N_("@f has feature flag(s) set, but is a revision 0 @f.  "),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	/* Clearing orphan inode */
 	{ PR_0_ORPHAN_CLEAR_INODE,
@@ -275,11 +270,6 @@ static struct e2fsck_problem problem_tab
 	  N_("@I @i %i in @o @i list.\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Filesystem revision is 0, but feature flags are set */
-	{ PR_0_FS_REV_LEVEL,
-	  N_("@f has feature flag(s) set, but is a revision 0 @f.  "),
-	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
-
 	/* Journal superblock has an unknown read-only feature flag set */
 	{ PR_0_JOURNAL_UNSUPP_ROCOMPAT,
 	  N_("@j @S has an unknown read-only feature flag set.\n"),
@@ -311,6 +301,16 @@ static struct e2fsck_problem problem_tab
 	     "Clearing fields beyond the V1 @j @S...\n\n"),
 	  PROMPT_NONE, 0 },
 
+	/* Ask if we should run the journal anyway */
+	{ PR_0_JOURNAL_RUN,
+	  N_("Run @j anyway"),
+	  PROMPT_NULL, 0 },
+
+	/* Run the journal by default */
+	{ PR_0_JOURNAL_RUN_DEFAULT,
+	  N_("Recovery flag not set in backup @S, so running @j anyway.\n"),
+	  PROMPT_NONE, 0 },
+
 	/* Backup journal inode blocks */
 	{ PR_0_BACKUP_JNL,
 	  N_("Backing up @j @i @b information.\n\n"),
@@ -793,11 +793,6 @@ static struct e2fsck_problem problem_tab
 	  N_("@a in @i %i has a namelen (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_value_size */
-	{ PR_1_ATTR_VALUE_SIZE,
-	  N_("@a in @i %i has a value size (%N) which is @n\n"),
-	  PROMPT_CLEAR, PR_PREEN_OK },
-
 	/* invalid ea entry->e_value_offs */
 	{ PR_1_ATTR_VALUE_OFFSET,
 	  N_("@a in @i %i has a value offset (%N) which is @n\n"),
@@ -808,6 +803,11 @@ static struct e2fsck_problem problem_tab
 	  N_("@a in @i %i has a value @b (%N) which is @n (must be 0)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* invalid ea entry->e_value_size */
+	{ PR_1_ATTR_VALUE_SIZE,
+	  N_("@a in @i %i has a value size (%N) which is @n\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* invalid ea entry->e_hash */
 	{ PR_1_ATTR_HASH,
 	  N_("@a in @i %i has a hash (%N) which is @n\n"),
@@ -1597,11 +1597,6 @@ static struct e2fsck_problem problem_tab
 	  " +(%i--%j)",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
 
-	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
-	{ PR_6_RECREATE_JOURNAL,
-	  N_("Recreate @j"),
-	  PROMPT_NULL, PR_PREEN_OK | PR_NO_OK },
-
 	/* Group N block(s) in use but group is marked BLOCK_UNINIT */
 	{ PR_5_BLOCK_UNINIT,
 	  N_("@g %g @b(s) in use but @g is marked BLOCK_UNINIT\n"),
@@ -1612,6 +1607,13 @@ static struct e2fsck_problem problem_tab
 	  N_("@g %g @i(s) in use but @g is marked INODE_UNINIT\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Post-Pass 5 errors */
+
+	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
+	{ PR_6_RECREATE_JOURNAL,
+	  N_("Recreate @j"),
+	  PROMPT_NULL, PR_PREEN_OK | PR_NO_OK },
+
 	{ 0 }
 };
 
@@ -1834,3 +1835,89 @@ int fix_problem(e2fsck_t ctx, problem_t 
 
 	return answer;
 }
+
+#ifdef UNITTEST
+
+#include <stdlib.h>
+#include <stdio.h>
+
+errcode_t
+profile_get_boolean(profile_t profile, const char *name, const char *subname,
+		    const char *subsubname, int def_val, int *ret_boolean)
+{
+	return 0;
+}
+
+void print_e2fsck_message(e2fsck_t ctx, const char *msg,
+			  struct problem_context *pctx, int first,
+			  int recurse)
+{
+	return;
+}
+
+void fatal_error(e2fsck_t ctx, const char *msg)
+{
+	return;
+}
+
+void preenhalt(e2fsck_t ctx)
+{
+	return;
+}
+
+errcode_t
+profile_get_string(profile_t profile, const char *name, const char *subname,
+		   const char *subsubname, const char *def_val,
+		   char **ret_string)
+{
+	return 0;
+}
+
+int ask (e2fsck_t ctx, const char * string, int def)
+{
+	return 0;
+}
+
+int verify_problem_table(e2fsck_t ctx)
+{
+	struct e2fsck_problem *curr, *prev = NULL;
+	int rc = 0;
+
+	for (prev = NULL, curr = problem_table; curr->e2p_code; prev = curr++) {
+		if (prev == NULL)
+			continue;
+
+		if (curr->e2p_code > prev->e2p_code)
+			continue;
+
+		if (curr->e2p_code == prev->e2p_code)
+			fprintf(stderr, "*** Duplicate in problem table:\n");
+		else
+			fprintf(stderr, "*** Unordered problem table:\n");
+
+		fprintf(stderr, "curr code = 0x%08x: %s\n",
+			curr->e2p_code, curr->e2p_description);
+		fprintf(stderr, "*** prev code = 0x%08x: %s\n",
+			prev->e2p_code, prev->e2p_description);
+
+		fprintf(stderr, "*** This is a %sprogramming error in e2fsck\n",
+			(curr->e2p_code == prev->e2p_code) ? "fatal " : "");
+
+		rc = 1;
+	}
+
+	return rc;
+}
+
+int main(int argc, char *argv[])
+{
+	e2fsck_t ctx;
+	int rc;
+
+	rc = verify_problem_table(ctx);
+	if (rc == 0)
+		printf("e2fsck problem table verified\n");
+
+	return rc;
+}
+#endif /* UNITTEST */
Index: e2fsprogs-1.41.5/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.41.5.orig/e2fsck/problem.h
+++ e2fsprogs-1.41.5/e2fsck/problem.h
@@ -529,10 +529,10 @@ struct problem_context {
 #define PR_1B_ALLOCATE_IBITMAP_ERROR 0x011005
 
 /* Error while iterating over blocks */
-#define PR_1B_BLOCK_ITERATE	0x0110006
+#define PR_1B_BLOCK_ITERATE	0x011006
 
 /* Error adjusting EA refcount */
-#define PR_1B_ADJ_EA_REFCOUNT	0x0110007
+#define PR_1B_ADJ_EA_REFCOUNT	0x011007
 
 
 /* Pass 1C: Scan directories for inodes with dup blocks. */
Index: e2fsprogs-1.41.5/e2fsck/Makefile.in
===================================================================
--- e2fsprogs-1.41.5.orig/e2fsck/Makefile.in
+++ e2fsprogs-1.41.5/e2fsck/Makefile.in
@@ -134,6 +134,10 @@ crc32table.h: gen_crc32table
 	@echo "	GEN32TABLE $@"
 	@./gen_crc32table > crc32table.h
 
+tst_problem: $(srcdir)/problem.c $(srcdir)/problem.h $(LIBEXT2FS)
+	@$(CC) $(BUILD_LDFLAGS) $(ALL_CFLAGS) -o tst_problem \
+		$(srcdir)/problem.c -DUNITTEST $(LIBEXT2FS) $(LIBCOM_ERR)
+
 tst_crc32: $(srcdir)/crc32.c $(LIBEXT2FS)
 	@$(CC) $(BUILD_LDFLAGS) $(ALL_CFLAGS) -o tst_crc32 $(srcdir)/crc32.c \
 		-DUNITTEST $(LIBEXT2FS) $(LIBCOM_ERR)
@@ -148,10 +152,11 @@ tst_region: region.c
 	@$(CC) -o tst_region $(srcdir)/region.c \
 		$(ALL_CFLAGS) -DTEST_PROGRAM $(LIBCOM_ERR)
 
-check:: tst_refcount tst_region tst_crc32
+check:: tst_refcount tst_region tst_crc32 tst_problem
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_refcount
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_region
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_crc32
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_problem
 
 extend: extend.o
 	@echo "	LD $@"
@@ -261,7 +266,7 @@ uninstall:
 clean:
 	$(RM) -f $(PROGS) \#* *\# *.s *.o *.a *~ core e2fsck.static \
 		e2fsck.shared e2fsck.profiled flushb e2fsck.8 \
-		tst_crc32 tst_region tst_refcount gen_crc32table \
+		tst_problem tst_crc32 tst_region tst_refcount gen_crc32table \
 		crc32table.h e2fsck.conf.5 prof_err.c prof_err.h \
 		test_profile
 	$(RM) -rf profiled

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


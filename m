From: Allison Henderson <achender@vnet.ibm.com>
Subject: [PATCH 1/3 v5] XFS TESTS: Add Punch Hole to FSX
Date: Mon, 06 Jun 2011 16:33:37 -0700
Message-ID: <4DED63D1.5010600@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50511 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1FFXdj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 19:33:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds punch hole tests to the fsx stress test. 

Signed-off-by: Allison Henderson <achender@us.ibm.com>

v1 -> v2:
Corrections to the Makefile have been backed out.
This patch needs to be applied on top of
the "xfstests: clean up fallocate configuration tests"
patch

The punch hole tests can be disabled with the
-H flag, and will also be disabled if it is
detected that the filesystem does not support
punch hole

v2 -> v4
Punch hole tests and functionality tests have been moved
into their own functions.  Existing dofallocate routine
has been renamed to do_preallocate.

v4 -> v5
The code to test fallocate functionality changed slightly,
so the patch has been updated to apply with out err
---
:100644 100644 0eebc70... 0683853... M	ltp/fsx.c
 ltp/fsx.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 124 insertions(+), 19 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 0eebc70..0683853 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -69,6 +69,7 @@ int			logcount = 0;	/* total ops */
 #define OP_MAPWRITE	6
 #define OP_SKIPPED	7
 #define OP_FALLOCATE	8
+#define OP_PUNCH_HOLE	9
 
 #undef PAGE_SIZE
 #define PAGE_SIZE       getpagesize()
@@ -110,6 +111,7 @@ int	randomoplen = 1;		/* -O flag disables it */
 int	seed = 1;			/* -S flag */
 int     mapped_writes = 1;              /* -W flag disables */
 int     fallocate_calls = 1;            /* -F flag disables */
+int     punch_hole_calls = 1;           /* -H flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -279,6 +281,14 @@ logdump(void)
 			    badoff < lp->args[0] + lp->args[1])
 				prt("\t******FFFF");
 			break;
+		case OP_PUNCH_HOLE:
+			prt("PUNCH HOLE\t0x%x thru 0x%x\t(0x%x bytes)",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1]);
+			if (badoff >= lp->args[0] && badoff <
+						     lp->args[0] + lp->args[1])
+				prt("\t******PPPP");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -784,10 +794,67 @@ dotruncate(unsigned size)
 	}
 }
 
+#ifdef FALLOC_FL_PUNCH_HOLE
+void
+do_punch_hole(unsigned offset, unsigned length)
+{
+	unsigned end_offset;
+	int max_offset = 0;
+	int max_len = 0;
+	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length punch hole\n");
+			log4(OP_SKIPPED, OP_PUNCH_HOLE, offset, length);
+		return;
+	}
+
+	if (file_size <= (loff_t)offset) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping hole punch off the end of the file\n");
+			log4(OP_SKIPPED, OP_PUNCH_HOLE, offset, length);
+		return;
+	}
+
+	end_offset = offset + length;
+
+	log4(OP_PUNCH_HOLE, offset, length, 0);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		      end_offset <= monitorend))) {
+		prt("%lu punch\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+			offset, offset+length, length);
+	}
+	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
+		prt("%punch hole: %x to %x\n", offset, length);
+		prterr("do_punch_hole: fallocate");
+		report_failure(161);
+	}
+
+
+	max_offset = offset < file_size ? offset : file_size;
+	max_len = max_offset + length <= file_size ? length :
+			file_size - max_offset;
+	memset(good_buf + max_offset, '\0', max_len);
+}
+
+#else
+void
+do_punch_hole(unsigned offset, unsigned length)
+{
+	return;
+}
+#endif
+
 #ifdef FALLOCATE
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
-dofallocate(unsigned offset, unsigned length)
+do_preallocate(unsigned offset, unsigned length)
 {
 	unsigned end_offset;
 	int keep_size;
@@ -831,13 +898,13 @@ dofallocate(unsigned offset, unsigned length)
 		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, offset, length);
 	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
 	        prt("fallocate: %x to %x\n", offset, length);
-		prterr("dofallocate: fallocate");
+		prterr("do_preallocate: fallocate");
 		report_failure(161);
 	}
 }
 #else
 void
-dofallocate(unsigned offset, unsigned length)
+do_preallocate(unsigned offset, unsigned length)
 {
 	return;
 }
@@ -895,8 +962,7 @@ test(void)
 	unsigned long	offset;
 	unsigned long	size = maxoplen;
 	unsigned long	rv = random();
-	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls);
-
+	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls + punch_hole_calls);
         /* turn off the map read if necessary */
 
         if (op == 2 && !mapped_reads)
@@ -924,6 +990,7 @@ test(void)
 	 * TRUNCATE:	op = -     3
 	 * MAPWRITE:    op = 3     4
 	 * FALLOCATE:   op = -     5
+	 * PUNCH HOLE:  op = -     6
 	 */
 	if (lite ? 0 : op == 3 && (style & 1) == 0) /* vanilla truncate? */
 		dotruncate(random() % maxfilelen);
@@ -941,7 +1008,12 @@ test(void)
 				offset %= maxfilelen;
 				if (offset + size > maxfilelen)
 					size = maxfilelen - offset;
-				dofallocate(offset, size);
+				do_preallocate(offset, size);
+			} else if (op == 6) {
+				offset %= maxfilelen;
+				if (offset + size > maxfilelen)
+					size = maxfilelen - offset;
+				do_punch_hole(offset, size);
 			} else if (op == 1 || op == (lite ? 3 : 4)) {
 				/* write / mapwrite */
 				offset %= maxfilelen;
@@ -1013,6 +1085,9 @@ usage(void)
 #ifdef FALLOCATE
 "	-F: Do not use fallocate (preallocation) calls\n"
 #endif
+#ifdef FALLOC_FL_PUNCH_HOLE
+"       -H: Do not use punch hole calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -1161,6 +1236,43 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 
 #endif
 
+void
+test_fallocate()
+{
+#ifdef FALLOCATE
+	if (!lite && fallocate_calls) {
+		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
+			if(!quiet)
+				prt("fsx: main: filesystem does not support fallocate, disabling\n");
+			fallocate_calls = 0;
+		} else {
+			ftruncate(fd, 0);
+		}
+	}
+#else /* ! FALLOCATE */
+	fallocate_calls = 0;
+#endif
+
+}
+
+void
+test_punch_hole()
+{
+#ifdef FALLOC_FL_PUNCH_HOLE
+	if (!lite && punch_hole_calls) {
+		if (fallocate(fd, 0, 0,
+			FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE) &&
+			errno == EOPNOTSUPP) {
+
+			warn("main: filesystem does not support fallocate punch hole, disabling");
+			punch_hole_calls = 0;
+		}
+	}
+#else /* ! PUNCH HOLE */
+	punch_hole_calls = 0;
+#endif
+}
+
 int
 main(int argc, char **argv)
 {
@@ -1179,7 +1291,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHLN:OP:RS:WZ"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1276,6 +1388,9 @@ main(int argc, char **argv)
 		case 'F':
 			fallocate_calls = 0;
 			break;
+		case 'H':
+			punch_hole_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			break;
@@ -1421,18 +1536,8 @@ main(int argc, char **argv)
 	} else 
 		check_trunc_hack();
 
-#ifdef FALLOCATE
-	if (!lite && fallocate_calls) {
-		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
-			if(!quiet)
-				prt("fsx: main: filesystem does not support fallocate, disabling\n");
-			fallocate_calls = 0;
-		} else
-			ftruncate(fd, 0);
-	}
-#else /* ! FALLOCATE */
-	fallocate_calls = 0;
-#endif
+	test_fallocate();
+	test_punch_hole();
 
 	while (numops == -1 || numops--)
 		test();
-- 
1.7.1


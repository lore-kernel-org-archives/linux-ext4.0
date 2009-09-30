From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Updated fsx.c program (fixed fallocate)
Date: Tue, 29 Sep 2009 22:34:28 -0500
Message-ID: <4AC2D1C4.5080205@redhat.com>
References: <20090826052505.GA22238@webber.adilger.int> <20090929213859.GB13825@webber.adilger.int> <20090929223938.GD3384@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
	Subrata Modak <subrata@linux.vnet.ibm.com>,
	Dave Jones <davej@redhat.com>, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090929223938.GD3384@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> I've done some work to merge some of the existing fsx.c mods into a
> single version.  Over & above the version that is in the LTP, I've
> included AKPM's O_DIRECT fixes (with a twist), the BSD mmap page and
> segfault handling, and per-write fsync.
>
> The twist for the O_DIRECT feature is that it will randomly open file
> descriptors with O_DIRECT, and if you use the Lustre-inspired multi-fd
> support (by specifying multiple pathnames for the output file) fsx will
> be testing buffered and O_DIRECT and mmap IO on the same file.
>
> Updated patch to have proper fallocate() handling in case glibc doesn't
> have this, for non-x86 architectures from MingMing Cao, based on code
> used by DB2.
>
> Signed-off-by: Andreas Dilger <adilger@sun.com>
>   
And here's a patch on top of that to implement random fallocate
calls during the runs rather than just one at the beginning.

This was a fairly quick patch merge from one I did for xfstests'
version of fsx, but it seems to run properly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

--- fsx.c.orig	2009-09-29 21:40:31.045330451 -0500
+++ fsx.c	2009-09-29 22:30:25.670330430 -0500
@@ -37,11 +37,12 @@
  *
  *	Add multi-file testing feature -- Zach Brown <zab@clusterfs.com>
  *
+ *	Add random preallocation calls - Eric Sandeen <sandeen@redhat.com>
+ *
  * $FreeBSD: src/tools/regression/fsx/fsx.c,v 1.2 2003/04/23 23:42:23 jkh Exp $
  * $DragonFly: src/test/stress/fsx/fsx.c,v 1.2 2005/05/02 19:31:56 dillon Exp $
  *
  */
-
 #include <sys/types.h>
 #include <sys/stat.h>
 #if defined(_UWIN) || defined(__linux__)
@@ -95,6 +96,7 @@
 #define OP_MAPREAD	5
 #define OP_MAPWRITE	6
 #define OP_SKIPPED	7
+#define OP_FALLOCATE	8
 
 int page_size;
 int page_mask;
@@ -127,6 +129,7 @@
 int	writebdy = 1;			/* -w flag */
 long	monitorstart = -1;		/* -m flag */
 long	monitorend = -1;		/* -m flag */
+int     fallocate_calls = 1;            /* -F flag disables */
 int	lite = 0;			/* -L flag */
 long	numops = -1;			/* -N flag */
 int	randomoplen = 1;		/* -O flag disables it */
@@ -219,6 +222,7 @@
 {
 	int	i, count, down;
 	struct log_entry	*lp;
+	char *falloc_type[3] = {"PAST_EOF", "EXTENDING", "INTERIOR"};
 
 	prt("LOG DUMP (%d total operations):\n", logcount);
 	if (logcount < LOGSIZE) {
@@ -290,6 +294,14 @@
 			prt("CLOSE/OPEN%s",
 			    lp->operation & O_DIRECT ? "_OD" : "   ");
 			break;
+		case OP_FALLOCATE:
+			/* 0: offset 1: length 2: where alloced */
+			prt("FALLOCATE %s\tfrom 0x%x to 0x%x",
+			    falloc_type[lp->args[2]], lp->args[0], lp->args[0] + lp->args[1]);
+			if (badoff >= lp->args[0] &&
+			    badoff < lp->args[0] + lp->args[1])
+				prt("\t******FFFF");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -687,6 +699,7 @@
 		[OP_MAPWRITE] = "mapwrite",
 		[OP_READ + O_DIRECT] = "read_OD",
 		[OP_WRITE + O_DIRECT] = "write_OD",
+		[OP_FALLOCATE] = "fallocate",
 	};
 
 	if (fd_policy != FD_SINGLE)
@@ -1068,6 +1081,59 @@
 	output_debug(size, 0, "truncate done");
 }
 
+/* fallocate is basically a no-op unless extending, then a lot like a truncate */
+void
+dofallocate(unsigned offset, unsigned length)
+{
+	struct timeval t;
+	unsigned end_offset;
+	int keep_size;
+	struct test_file *tf = get_tf();
+	int fd = tf->fd;
+
+	gettimeofday(&t, NULL);
+        if (length == 0) {
+                if (!quiet && testcalls > simulatedopcount)
+                        prt("skipping zero length fallocate\n");
+                log4(OP_SKIPPED, OP_FALLOCATE, offset, length, &t);
+                return;
+        }
+
+	keep_size = random() % 2;
+
+	end_offset = keep_size ? 0 : offset + length;
+
+	if (end_offset > biggest) {
+		biggest = end_offset;
+		if (!quiet && testcalls > simulatedopcount)
+			prt("fallocating to largest ever: 0x%x\n", end_offset);
+	}
+
+	/*
+	 * last arg:
+	 * 	1: allocate past EOF
+	 * 	2: extending prealloc
+	 * 	3: interior prealloc
+	 */
+	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 1 : 2) : 3, &t);
+
+	if (end_offset > file_size) {
+		memset(good_buf + file_size, '\0', end_offset - file_size);
+		file_size = end_offset;
+	}
+
+	if (testcalls <= simulatedopcount)
+		return;
+	
+	output_line(tf, OP_FALLOCATE, offset, length, &t);
+
+	if (do_fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
+	        prt("fallocate: %x to %x\n", offset, length);
+		prterr("dofallocate: fallocate");
+		report_failure(161);
+	}
+	output_debug(offset, length, "fallocate done");
+}
 
 void
 writefileimage()
@@ -1141,7 +1207,7 @@
 	unsigned long	offset;
 	unsigned long	size = maxoplen;
 	unsigned long	rv = random();
-	unsigned long	op = rv % (3 + !lite + mapped_writes);
+	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls);
 
         /* turn off the map read if necessary */
 
@@ -1160,22 +1226,32 @@
 		prt("%lu...\n", testcalls);
 
 	/*
-	 * READ:	op = 0
-	 * WRITE:	op = 1
-	 * MAPREAD:     op = 2
-	 * TRUNCATE:	op = 3
-	 * MAPWRITE:    op = 3 or 4
+	 *                 lite  !lite
+	 * READ:	op = 0	   0
+	 * WRITE:	op = 1     1
+	 * MAPREAD:     op = 2     2
+	 * TRUNCATE:	op = -     3
+	 * MAPWRITE:    op = 3     4
+	 * FALLOCATE:   op = -     5
 	 */
 	if (lite ? 0 : op == 3 && (style & 1) == 0) /* vanilla truncate? */
 		dotruncate(random() % maxfilelen);
 	else {
 		if (randomoplen)
 			size = random() % (maxoplen+1);
+		/* truncate */
 		if (lite ? 0 : op == 3)
 			dotruncate(size);
 		else {
 			offset = random();
-			if (op == 1 || op == (lite ? 3 : 4)) {
+			/* fallocate */
+			if (op == 5) {
+				offset %= maxfilelen;
+				if (offset + size > maxfilelen)
+					size = maxfilelen - offset;
+				dofallocate(offset, size);
+			/* write / mapwrite */
+			} else if (op == 1 || op == (lite ? 3 : 4)) {
 				offset %= maxfilelen;
 				if (offset + size > maxfilelen)
 					size = maxfilelen - offset;
@@ -1183,6 +1259,7 @@
 					domapwrite(offset, size);
 				else
 					dowrite(offset, size);
+			/* read / mapread */
 			} else {
 				if (file_size)
 					offset %= file_size;
@@ -1227,7 +1304,7 @@
 void
 usage(void)
 {
-	fprintf(stdout, "usage: fsx [-dfnqLOW] [-b opnum] [-c Prob] [-l flen]\n"
+	fprintf(stdout, "usage: fsx [-dfnqFLOW] [-b opnum] [-c Prob] [-l flen]\n"
 "\t\t[-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style]\n"
 "\t\t[-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath]\n"
 "\t\t[-S seed] [-Z [prob]] [ -I random|rotate ] fname [more paths to fname..]\n"
@@ -1266,6 +1343,7 @@
 "	    each operation uses a different path.  Iterate through them in\n"
 "	    order with 'rotate' or chose then at 'random'.  (defaults random)\n"
 /* OSX: -I: start interactive mode since operation opnum\n" */
+"	-F: Do not use fallocate (preallocation) calls\n"
 "	-L: fsxLite - no file creations & no file size changes\n"
 /* OSX: -M: slow motion mode, wait 1 second before each op\n" */
 "	-N numops: total # operations to do (default infinity)\n"
@@ -1332,7 +1410,7 @@
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt(argc, argv,
-			    "b:c:dfl:m:no:p:qr:s:t:w:x::D:I:LN:OP:RS:WZ::"))
+			    "b:c:dfl:m:no:p:qr:s:t:w:x::D:FI:LN:OP:RS:WZ::"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1421,6 +1499,9 @@
 			if (debugstart < 1)
 				usage();
 			break;
+		case 'F':
+			fallocate_calls = 0;
+			break;
 		case 'I':
 			assign_fd_policy(optarg);
 			break;
@@ -1557,6 +1638,15 @@
 		check_trunc_hack();
 	}
 
+	if (!lite && fallocate_calls) {
+		int fd = get_fd();
+		if (do_fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
+			warn("main: filesystem does not support fallocate, disabling");
+			fallocate_calls = 0;
+		} else
+			ftruncate(fd, 0);
+	}
+
 	while (numops == -1 || numops--)
 		test();
 


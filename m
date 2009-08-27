From: Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [PATCH] Updated fsx.c program
Date: Thu, 27 Aug 2009 15:46:46 +0530
Message-ID: <20090827101646.12497.73776.sendpatchset@subratamodak.linux.ibm.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	LTP List <ltp-list@lists.sourceforge.net>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45442 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZH0KQw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2009 06:16:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7RAGXVC032436
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2009 06:16:33 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7RAGsRr252816
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2009 06:16:54 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7RAGqxf012049
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2009 06:16:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

>On Tue, 2009-08-25 at 23:25 -0600, Andreas Dilger wrote:
>I've done some work to merge some of the existing fsx.c mods into a
> single version.  Over & above the version that is in the LTP, I've
> included AKPM's O_DIRECT fixes (with a twist), the BSD mmap page and
> segfault handling, and per-write fsync.
> 
> The twist for the O_DIRECT feature is that it will randomly open file
> descriptors with O_DIRECT, and if you use the Lustre-inspired multi-fd
> support fsx will be testing concurrent buffered and O_DIRECT and mmap
> IO on the same file.

The following patch will integrate your new fsx.c program in LTP, by replacing
(http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/kernel/fs/fsx-linux/fsx-linux.c)
the existing one. Would you mind providing a Sign-off for the below Patch ?

Patch-prepared-for-ltp-by: Subrata Modak <subrata@linux.vnet.ibm.com>
---

--- ltp-intermediate-20090822/testcases/kernel/fs/fsx-linux/fsx-linux.c.orig	2009-08-27 15:36:30.000000000 +0530
+++ ltp-intermediate-20090822/testcases/kernel/fs/fsx-linux/fsx-linux.c	2009-08-27 15:36:41.000000000 +0530
@@ -1,5 +1,4 @@
 /*
- * Copyright (C) 1991, NeXT Computer, Inc.  All Rights Reserverd.
  * Copyright (c) 1998-2001 Apple Computer, Inc. All rights reserved.
  *
  * @APPLE_LICENSE_HEADER_START@
@@ -32,9 +31,14 @@
  *	Small changes to work under Linux -- davej@suse.de
  *
  *	Sundry porting patches from Guy Harris 12/2001
- * $FreeBSD: src/tools/regression/fsx/fsx.c,v 1.1 2001/12/20 04:15:57 jkh Exp $
+ *
+ *	Checks for mmap last-page zero fill.
  *
  *	Add multi-file testing feature -- Zach Brown <zab@clusterfs.com>
+ *
+ * $FreeBSD: src/tools/regression/fsx/fsx.c,v 1.2 2003/04/23 23:42:23 jkh Exp $
+ * $DragonFly: src/test/stress/fsx/fsx.c,v 1.2 2005/05/02 19:31:56 dillon Exp $
+ *
  */
 
 #include <sys/types.h>
@@ -59,6 +63,7 @@
 #include <unistd.h>
 #include <stdarg.h>
 #include <errno.h>
+#include <setjmp.h>
 
 /*
  *	A log entry is an operation and a bunch of arguments.
@@ -66,15 +71,17 @@
 
 struct log_entry {
 	int	operation;
-	struct timeval tv;
 	int	args[3];
+	struct timeval tv;
 };
 
-#define	LOGSIZE	1000
+#define	LOGSIZE	100000
 
 struct log_entry	oplog[LOGSIZE];	/* the log */
 int			logptr = 0;	/* current position in log */
 int			logcount = 0;	/* total ops */
+int			jmpbuf_good;
+jmp_buf			jmpbuf;
 
 /*
  *	Define operations
@@ -107,6 +114,7 @@ unsigned long	simulatedopcount = 0;	/* -
 int	closeprob = 0;			/* -c flag */
 int	debug = 0;			/* -d flag */
 unsigned long	debugstart = 0;		/* -D flag */
+int	do_fsync = 0;			/* -f flag */
 unsigned long	maxfilelen = 256 * 1024;	/* -l flag */
 int	sizechecks = 1;			/* -n flag disables them */
 int	maxoplen = 64 * 1024;		/* -o flag */
@@ -122,11 +130,13 @@ int	lite = 0;			/* -L flag */
 long	numops = -1;			/* -N flag */
 int	randomoplen = 1;		/* -O flag disables it */
 int	seed = 1;			/* -S flag */
-int     mapped_writes = 1;              /* -W flag disables */
-int 	mapped_reads = 1;		/* -R flag disables it */
+int     mapped_writes = 1;		/* -W flag disables */
+int	mapped_reads = 1;		/* -R flag disables it */
+int	prealloc = 0;			/* -x [0|1|2] run with prealloc */
+int	o_direct = 0;			/* -Z flag */
 int	fsxgoodfd = 0;
-FILE *	fsxlogf = NULL;
-int badoff = -1;
+FILE	*fsxlogf = NULL;
+int	badoff = -1;
 
 
 void
@@ -153,6 +163,13 @@ warn(const char * fmt, ...)
 	va_end(ap);
 }
 
+static void *round_up(void *ptr, unsigned long align)
+{
+	unsigned long ret = (unsigned long)ptr;
+
+	ret = ((ret + align - 1) & ~(align - 1));
+	return (void *)ret;
+}
 
 void
 __attribute__((format(printf, 1, 2)))
@@ -223,20 +240,22 @@ logdump(void)
 			prt("MAPREAD  0x%x thru 0x%x (0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (badoff >= lp->args[0] &&
+			    badoff < lp->args[0] + lp->args[1])
 				prt("\t***RRRR***");
 			break;
 		case OP_MAPWRITE:
 			prt("MAPWRITE 0x%x thru 0x%x (0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (badoff >= lp->args[0] &&
+			    badoff < lp->args[0] + lp->args[1])
 				prt("\t******WWWW");
 			break;
 		case OP_READ:
-			prt("READ     0x%x thru 0x%x (0x%x bytes)",
+		case OP_READ + O_DIRECT:
+			prt("READ%s  0x%x thru 0x%x (0x%x bytes)",
+			    lp->operation & O_DIRECT ? "_OD" : "   ",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
 			if (badoff >= lp->args[0] &&
@@ -244,7 +263,9 @@ logdump(void)
 				prt("\t***RRRR***");
 			break;
 		case OP_WRITE:
-			prt("WRITE    0x%x thru 0x%x (0x%x bytes)",
+		case OP_WRITE + O_DIRECT:
+			prt("WRITE%s 0x%x thru 0x%x (0x%x bytes)",
+			    lp->operation & O_DIRECT ? "_OD" : "   ",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
 			if (lp->args[0] > lp->args[2])
@@ -264,7 +285,9 @@ logdump(void)
 				prt("\t******WWWW");
 			break;
 		case OP_CLOSEOPEN:
-			prt("CLOSE/OPEN");
+		case OP_CLOSEOPEN + O_DIRECT:
+			prt("CLOSE/OPEN%s",
+			    lp->operation & O_DIRECT ? "_OD" : "   ");
 			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
@@ -392,6 +415,7 @@ check_buffers(unsigned offset, unsigned 
 struct test_file {
 	char *path;
 	int fd;
+	int o_direct;
 } *test_files = NULL;
 
 int num_test_files = 0;
@@ -446,6 +470,33 @@ get_fd(void)
 	return tf->fd;
 }
 
+static const char *my_basename(const char *path)
+{
+	char *c = strrchr(path, '/');
+
+	return c ? c++ : path;
+}
+
+int do_fallocate(int fd, int flags, loff_t offset, loff_t maxlen)
+{
+#ifdef FALLOC_FL_KEEP_SIZE
+	return fallocate(fd, flags, offset, maxlen);
+#else
+#define FALLOC_FL_KEEP_SIZE 0x01
+#ifdef __i386__
+#define __NR_fallocate		324
+	return syscall(__NR_fallocate, fd, flags, offset, maxlen);
+#elif defined (__powerpc__)
+#define __NR_fallocate          309
+	return syscall(__NR_fallocate, fd, flags, offset >> 32,
+		       offset & 0xffffffff, maxlen >> 32, maxlen & 0xffffffff);
+#else  /* !__i386__ && !__powerpc__ */
+	errno = ENOSYS;
+	return -1;
+#endif /* __i386__ */
+#endif /* FALLOC_FL_KEEP_SIZE */
+}
+
 void
 open_test_files(char **argv, int argc)
 {
@@ -463,14 +514,32 @@ open_test_files(char **argv, int argc)
 	}
 
 	for (i = 0, tf = test_files; i < num_test_files; i++, tf++) {
-
 		tf->path = argv[i];
-		tf->fd = open(tf->path, O_RDWR|(lite ? 0 : O_CREAT|O_TRUNC),
+		tf->o_direct = (o_direct && (random() % o_direct == 0)) ?
+			O_DIRECT : 0;
+		tf->fd = open(tf->path, O_RDWR | (lite ? 0 : O_CREAT|O_TRUNC) |
+			                tf->o_direct,
 				0666);
 		if (tf->fd < 0) {
 			prterr(tf->path);
 			exit(91);
 		}
+
+		if (prealloc == 1) {
+			if (do_fallocate(tf->fd, 0, 0, maxfilelen) < 0) {
+				(void)ftruncate(tf->fd, maxfilelen);
+				prt("%s: fallocate(0, %lu): %s\n",
+				    tf->path, maxfilelen, strerror(errno));
+				//exit(89);
+			}
+		} else if (prealloc == 2) {
+			if (do_fallocate(tf->fd, FALLOC_FL_KEEP_SIZE, 0,
+					 maxfilelen) < 0){
+				prt("%s: fallocate(KEEP_SIZE, 0, %lu): %s\n",
+				    tf->path, maxfilelen, strerror(errno));
+				//exit(89);
+			}
+		}
 	}
 
 	if (quiet || fd_policy == FD_SINGLE)
@@ -581,7 +650,7 @@ fill_tf_buf(struct test_file *tf)
 
 void
 output_line(struct test_file *tf, int op, unsigned offset,
-		unsigned size, struct timeval *tv)
+	    unsigned size, struct timeval *tv)
 {
 	char *tf_num = "";
 
@@ -591,8 +660,13 @@ output_line(struct test_file *tf, int op
 		[OP_TRUNCATE] = "trunc from",
 		[OP_MAPREAD] = "mapread",
 		[OP_MAPWRITE] = "mapwrite",
+		[OP_READ + O_DIRECT] = "read_OD",
+		[OP_WRITE + O_DIRECT] = "write_OD",
 	};
 
+	if (fd_policy != FD_SINGLE)
+		tf_num = fill_tf_buf(tf);
+
 	/* W. */
 	if (!(!quiet && ((progressinterval &&
 			testcalls % progressinterval == 0) ||
@@ -602,9 +676,6 @@ output_line(struct test_file *tf, int op
 			  (monitorend == -1 || offset <= monitorend)))))))
 		return;
 
-	if (fd_policy != FD_SINGLE)
-		tf_num = fill_tf_buf(tf);
-
 	prt("%06lu %lu.%06lu %.*s%-10s %#08x %s %#08x\t(0x%x bytes)\n",
 		testcalls, tv->tv_sec, tv->tv_usec, max_tf_len,
 		tf_num, ops[op],
@@ -612,6 +683,19 @@ output_line(struct test_file *tf, int op
 		offset + size - 1, size);
 }
 
+void output_debug(unsigned offset, unsigned size, const char *what)
+{
+	if (!quiet && (debug > 1 &&
+		        (monitorstart == -1 ||
+			 (offset + size >= monitorstart &&
+			  (monitorend == -1 || offset <= monitorend))))) {
+		struct timeval t;
+
+		gettimeofday(&t, NULL);
+		prt("       %lu.%06lu %s\n", t.tv_sec, t.tv_usec, what);
+	}
+}
+
 void
 doread(unsigned offset, unsigned size)
 {
@@ -621,10 +705,15 @@ doread(unsigned offset, unsigned size)
 	struct test_file *tf = get_tf();
 	int fd = tf->fd;
 
-	offset -= offset % readbdy;
+	if (tf->o_direct) {
+		offset -= offset % (readbdy == 1 ? page_size : readbdy);
+		size += page_size - size % (readbdy == 1 ? page_size : readbdy);
+	} else {
+		offset -= offset % readbdy;
+	}
 	gettimeofday(&t, NULL);
 	if (size == 0) {
-		if (!quiet && testcalls > simulatedopcount)
+		if (!quiet && testcalls > simulatedopcount && !tf->o_direct)
 			prt("skipping zero size read\n");
 		log4(OP_SKIPPED, OP_READ, offset, size, &t);
 		return;
@@ -636,12 +725,12 @@ doread(unsigned offset, unsigned size)
 		return;
 	}
 
-	log4(OP_READ, offset, size, 0, &t);
+	log4(OP_READ + tf->o_direct, offset, size, 0, &t);
 
 	if (testcalls <= simulatedopcount)
 		return;
 
-	output_line(tf, OP_READ, offset, size, &t);
+	output_line(tf, OP_READ + tf->o_direct, offset, size, &t);
 
 	ret = lseek(fd, (off_t)offset, SEEK_SET);
 	if (ret == (off_t)-1) {
@@ -649,13 +738,7 @@ doread(unsigned offset, unsigned size)
 		report_failure(140);
 	}
 	iret = read(fd, temp_buf, size);
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu read done\n", t.tv_sec, t.tv_usec);
-	}
+	output_debug(offset, size, "read done");
 	if (iret != size) {
 		if (iret == -1)
 			prterr("doread: read");
@@ -669,6 +752,33 @@ doread(unsigned offset, unsigned size)
 
 
 void
+check_eofpage(char *s, unsigned offset, char *p, int size)
+{
+	long last_page, should_be_zero;
+
+	if (offset + size <= (file_size & ~page_mask))
+		return;
+	/*
+	 * we landed in the last page of the file
+	 * test to make sure the VM system provided 0's
+	 * beyond the true end of the file mapping
+	 * (as required by mmap def in 1996 posix 1003.1)
+	 */
+	last_page = ((long)p + (offset & page_mask) + size) & ~page_mask;
+
+	for (should_be_zero = last_page + (file_size & page_mask);
+	     should_be_zero < last_page + page_size;
+	     should_be_zero++)
+		if (*(char *)should_be_zero) {
+			prt("non-zero mmap past EOF %#llx page @ %#lx is %#x\n",
+			    (long long)file_size -1, should_be_zero & page_mask,
+			    short_at(should_be_zero));
+			report_failure(205);
+		}
+}
+
+
+void
 domapread(unsigned offset, unsigned size)
 {
 	struct timeval t;
@@ -678,6 +788,11 @@ domapread(unsigned offset, unsigned size
 	struct test_file *tf = get_tf();
 	int fd = tf->fd;
 
+	if (tf->o_direct) {
+		doread(offset, size);
+		return;
+	}
+
 	offset -= offset % readbdy;
 	gettimeofday(&t, NULL);
 	if (size == 0) {
@@ -708,32 +823,21 @@ domapread(unsigned offset, unsigned size
 	        prterr("domapread: mmap");
 		report_failure(190);
 	}
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu mmap done\n", t.tv_sec, t.tv_usec);
-	}
-	memcpy(temp_buf, p + pg_offset, size);
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu memcpy done\n", t.tv_sec, t.tv_usec);
+	output_debug(offset, size, "mmap done");
+	if (setjmp(jmpbuf) == 0) {
+		jmpbuf_good = 1;
+		memcpy(temp_buf, p + pg_offset, size);
+		check_eofpage("Read", offset, p, size);
+		jmpbuf_good = 0;
+	} else {
+		report_failure(1901);
 	}
+	output_debug(offset, size, "memcpy done");
 	if (munmap(p, map_size) != 0) {
 		prterr("domapread: munmap");
 		report_failure(191);
 	}
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu munmap done\n", t.tv_sec, t.tv_usec);
-	}
+	output_debug(offset, size, "munmap done");
 
 	check_buffers(offset, size);
 }
@@ -760,16 +864,21 @@ dowrite(unsigned offset, unsigned size)
 	struct test_file *tf = get_tf();
 	int fd = tf->fd;
 
-	offset -= offset % writebdy;
+	if (tf->o_direct) {
+		offset -= offset % (writebdy == 1 ? page_size : writebdy);
+		size += page_size - (size % (writebdy == 1 ? page_size : writebdy));
+	} else {
+		offset -= offset % writebdy;
+	}
 	gettimeofday(&t, NULL);
 	if (size == 0) {
-		if (!quiet && testcalls > simulatedopcount)
+		if (!quiet && testcalls > simulatedopcount && !tf->o_direct)
 			prt("skipping zero size write\n");
 		log4(OP_SKIPPED, OP_WRITE, offset, size, &t);
 		return;
 	}
 
-	log4(OP_WRITE, offset, size, file_size, &t);
+	log4(OP_WRITE + tf->o_direct, offset, size, file_size, &t);
 
 	gendata(original_buf, good_buf, offset, size);
 	if (file_size < offset + size) {
@@ -785,7 +894,7 @@ dowrite(unsigned offset, unsigned size)
 	if (testcalls <= simulatedopcount)
 		return;
 
-	output_line(tf, OP_WRITE, offset, size, &t);
+	output_line(tf, OP_WRITE + tf->o_direct, offset, size, &t);
 
 	ret = lseek(fd, (off_t)offset, SEEK_SET);
 	if (ret == (off_t)-1) {
@@ -793,13 +902,7 @@ dowrite(unsigned offset, unsigned size)
 		report_failure(150);
 	}
 	iret = write(fd, good_buf + offset, size);
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu write done\n", t.tv_sec, t.tv_usec);
-	}
+	output_debug(offset, size, "write done");
 	if (iret != size) {
 		if (iret == -1)
 			prterr("dowrite: write");
@@ -808,6 +911,13 @@ dowrite(unsigned offset, unsigned size)
 			    iret, size);
 		report_failure(151);
 	}
+	if (do_fsync) {
+		if (fsync(fd)) {
+			prt("fsync() failed: %s\n", strerror(errno));
+			report_failure(152);
+		}
+		output_debug(offset, size, "fsync done");
+	}
 }
 
 
@@ -822,6 +932,11 @@ domapwrite(unsigned offset, unsigned siz
 	struct test_file *tf = get_tf();
 	int fd = tf->fd;
 
+	if (tf->o_direct) {
+		dowrite(offset, size);
+		return;
+	}
+
 	offset -= offset % writebdy;
 	gettimeofday(&t, NULL);
 	if (size == 0) {
@@ -855,13 +970,7 @@ domapwrite(unsigned offset, unsigned siz
 		        prterr("domapwrite: ftruncate");
 			exit(201);
 		}
-		if (!quiet && (debug > 1 &&
-			       (monitorstart == -1 ||
-				(offset + size > monitorstart &&
-				 (monitorend == -1 || offset <= monitorend))))) {
-			gettimeofday(&t, NULL);
-			prt("       %lu.%06lu truncate done\n", t.tv_sec, t.tv_usec);
-	}
+		output_debug(offset, size, "truncate done");
 	}
 	pg_offset = offset & page_mask;
 	map_size  = pg_offset + size;
@@ -871,43 +980,31 @@ domapwrite(unsigned offset, unsigned siz
 	        prterr("domapwrite: mmap");
 		report_failure(202);
 	}
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu mmap done\n", t.tv_sec, t.tv_usec);
-	}
-	memcpy(p + pg_offset, good_buf + offset, size);
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu memcpy done\n", t.tv_sec, t.tv_usec);
+	output_debug(offset, map_size, "mmap done");
+	if (setjmp(jmpbuf) == 0) {
+		jmpbuf_good = 1;
+		memcpy(p + pg_offset, good_buf + offset, size);
+		if (msync(p, map_size, 0) != 0) {
+			prterr("domapwrite: msync");
+			report_failure(203);
+		}
+		check_eofpage("Write", offset, p, size);
+		jmpbuf_good = 0;
+	} else {
+		report_failure(2021);
 	}
+
+	output_debug(offset, size, "memcpy done");
 	if (msync(p, map_size, 0) != 0) {
 		prterr("domapwrite: msync");
 		report_failure(203);
 	}
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu msync done\n", t.tv_sec, t.tv_usec);
-	}
+	output_debug(offset, map_size, "msync done");
 	if (munmap(p, map_size) != 0) {
 		prterr("domapwrite: munmap");
 		report_failure(204);
 	}
-	if (!quiet && (debug > 1 &&
-		        (monitorstart == -1 ||
-			 (offset + size > monitorstart &&
-			  (monitorend == -1 || offset <= monitorend))))) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu munmap done\n", t.tv_sec, t.tv_usec);
-	}
+	output_debug(offset, map_size, "munmap done");
 }
 
 
@@ -943,10 +1040,7 @@ dotruncate(unsigned size)
 		prterr("dotruncate: ftruncate");
 		report_failure(160);
 	}
-	if (!quiet && debug > 1) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu trunc done\n", t.tv_sec, t.tv_usec);
-	}
+	output_debug(size, 0, "truncate done");
 }
 
 
@@ -983,33 +1077,36 @@ docloseopen(void)
 {
 	struct timeval t;
 	struct test_file *tf = get_tf();
+	int direct = (o_direct && (random() % o_direct == 0)) ? O_DIRECT : 0;
+	char *tf_num = "";
 
 	if (testcalls <= simulatedopcount)
 		return;
 
 	gettimeofday(&t, NULL);
-	log4(OP_CLOSEOPEN, file_size, (unsigned)file_size, 0, &t);
+	log4(OP_CLOSEOPEN + direct, file_size, (unsigned)file_size, 0, &t);
+
+	if (fd_policy != FD_SINGLE)
+		tf_num = fill_tf_buf(tf);
 
 	if (debug)
-		prt("%06lu %lu.%06lu close/open\n", testcalls, t.tv_sec,
-		    t.tv_usec);
+		prt("%06lu %lu.%06lu %sclose/open%s\n", testcalls, t.tv_sec,
+		    t.tv_usec, tf_num, direct ? "(O_DIRECT)" : "");
 	if (close(tf->fd)) {
-		prterr("docloseopen: close");
+		prterr(tf->o_direct ?
+		       "docloseopen: close(O_DIRECT)" : "docloseopen: close");
 		report_failure(180);
 	}
-	if (!quiet && debug > 1) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu close done\n", t.tv_sec, t.tv_usec);
-	}
-	tf->fd = open(tf->path, O_RDWR, 0);
+	output_debug(monitorstart, 0, "close done");
+	tf->o_direct = direct;
+	tf->fd = open(tf->path, O_RDWR | tf->o_direct, 0);
 	if (tf->fd < 0) {
-		prterr("docloseopen: open");
+		prterr(tf->o_direct ?
+		       "docloseopen: open(O_DIRECT)" : "docloseopen: open");
 		report_failure(181);
 	}
-	if (!quiet && debug > 1) {
-		gettimeofday(&t, NULL);
-		prt("       %lu.%06lu open done\n", t.tv_sec, t.tv_usec);
-	}
+	output_debug(monitorstart, 0,
+		     tf->o_direct ? "open done" : "open(O_DIRECT) done");
 }
 
 
@@ -1081,6 +1178,15 @@ test(void)
 		docloseopen();
 }
 
+void
+segv(int sig)
+{
+	if (jmpbuf_good) {
+	    jmpbuf_good = 0;
+	    longjmp(jmpbuf, 1);
+	}
+	report_failure(9999);
+}
 
 void
 cleanup(sig)
@@ -1096,36 +1202,57 @@ cleanup(sig)
 void
 usage(void)
 {
-	fprintf(stdout, "usage: %s",
-		"fsx [-dnqLOW] [-b opnum] [-c Prob] [-l flen] [-m "
-"start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t "
-"truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] "
-"[ -I random|rotate ] fname [additional paths to fname..]\n"
+	fprintf(stdout, "usage: fsx [-dfnqLOW] [-b opnum] [-c Prob] [-l flen]\n"
+"\t\t[-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style]\n"
+"\t\t[-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath]\n"
+"\t\t[-S seed] [-Z [prob]] [ -I random|rotate ] fname [more paths to fname..]\n"
 "	-b opnum: beginning operation number (default 1)\n"
 "	-c P: 1 in P chance of file close+open at each op (default infinity)\n"
 "	-d: debug output for all operations [-d -d = more debugging]\n"
+/* OSX: -d duration: number of hours for the tool to run\n" */
+/* OSX: -e: tests using an extended attribute rather than a file\n" */
+"	-f: fsync after every write operation\n"
+/* OSX: -f forkname: test the named fork of fname\n" */
+/* OSX: -g logpath: path for .fsxlog file\n" */
+/* OSX: -h: write 0s instead of creating holes (i.e. sparse file)\n" */
+/* OSX: -i: interactive mode, hit return before performing each operation\n" */
 "	-l flen: the upper bound on file size (default 262144)\n"
-"	-m start:end: monitor (print debug) specified byte range (default 0:infinity)\n"
+/* OSX: -l logpath: path for XILog file\n" */
+"	-m startop:endop: monitor (print debug output) specified byte rang"
+"(default 0:infinity)\n"
 "	-n: no verifications of file size\n"
 "	-o oplen: the upper bound on operation size (default 65536)\n"
 "	-p progressinterval: debug output at specified operation interval\n"
 "	-q: quieter operation\n"
-"	-r readbdy: 4096 would make reads page aligned (default 1)\n"
+"	-r readbdy: %u would make reads page aligned (default 1)\n"
 "	-s style: 1 gives smaller truncates (default 0)\n"
-"	-t truncbdy: 4096 would make truncates page aligned (default 1)\n"
-"	-w writebdy: 4096 would make writes page aligned (default 1)\n"
+"	-t truncbdy: %u would make truncates page aligned (default 1)\n"
+/* OSX: -v: debug output for all operations\n" */
+"	-w writebdy: %u would make writes page aligned (default 1)\n"
+"	-x[1|2]: preallocate file space (2 does no size update)\n"
+/* OSX: -x: write output in XML (XILOG)\n" */
+/* OSX: -y: call fsync before closing the file\n" */
+/* AKPM:-A: Use the AIO system calls\n" */
+/* OSX: -C mix cached and un-cached read/write ops\n" */
 "	-D startingop: debug output starting at specified operation\n"
+/* OSX: -F flen: the upper bound on file size (default 262144)\n" */
+/* OSX: -G logsize: #entries in oplog (default 1024)\n" */
+"	-I {rotate|random}: When multiple paths to the file are given,\n"
+"	    each operation uses a different path.  Iterate through them in\n"
+"	    order with 'rotate' or chose then at 'random'.  (defaults random)\n"
+/* OSX: -I: start interactive mode since operation opnum\n" */
 "	-L: fsxLite - no file creations & no file size changes\n"
+/* OSX: -M: slow motion mode, wait 1 second before each op\n" */
 "	-N numops: total # operations to do (default infinity)\n"
 "	-O: use oplen (see -o flag) for every op (default random)\n"
 "	-P: save .fsxlog and .fsxgood files in dirpath (default ./)\n"
+"	-R: read() system calls only (mapped reads disabled)\n"
 "	-S seed: for random # generator (default 1) 0 gets timestamp\n"
+/* OSX: -T datasize: size of atomic data element writes [1,2,4] (default 4)\n" */
 "	-W: mapped write operations DISabled\n"
-"	-R: read() system calls only (mapped reads disabled)\n"
-"	-I: When multiple paths to the file are given each operation uses\n"
-"	    a different path.  Iterate through them in order with 'rotate'\n"
-"	    or chose then at 'random'.  (defaults to random)\n"
-"	fname: this filename is REQUIRED (no default)\n");
+"	-Z[P]: O_DIRECT file IO [1 in P chance for each open] (default off)\n"
+"	fname: this filename is REQUIRED (no default)\n",
+	page_size, page_size, page_size);
 	exit(90);
 }
 
@@ -1167,6 +1294,7 @@ int
 main(int argc, char **argv)
 {
 	int	i, style, ch;
+	char    *orig_good_buf, *orig_temp_buf;
 	char	*endp;
 	int  dirpath = 0;
 
@@ -1179,14 +1307,13 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt(argc, argv,
-				"b:c:dl:m:no:p:qr:s:t:w:D:I:LN:OP:RS:W"))
+			    "b:c:dfl:m:no:p:qr:s:t:w:x::D:I:LN:OP:RS:WZ::"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
 			simulatedopcount = getnum(optarg, &endp);
 			if (!quiet)
-				fprintf(stdout, "Will begin at operation"
-					"%ld\n",
+				fprintf(stdout, "Will begin at operation %ld\n",
 					simulatedopcount);
 			if (simulatedopcount == 0)
 				usage();
@@ -1204,6 +1331,9 @@ main(int argc, char **argv)
 		case 'd':
 			debug++;
 			break;
+		case 'f':
+			do_fsync = 1;
+			break;
 		case 'l':
 			maxfilelen = getnum(optarg, &endp);
 			if (maxfilelen <= 0)
@@ -1257,6 +1387,10 @@ main(int argc, char **argv)
 			if (writebdy <= 0)
 				usage();
 			break;
+		case 'x':
+			if (optarg == NULL || (prealloc = getnum(optarg, &endp)) <= 0)
+				prealloc = 1;
+			break;
 		case 'D':
 			debugstart = getnum(optarg, &endp);
 			if (debugstart < 1)
@@ -1300,7 +1434,10 @@ main(int argc, char **argv)
 			if (!quiet)
 				fprintf(stdout, "mapped writes DISABLED\n");
 			break;
-
+		case 'Z':
+			if (optarg == NULL || (o_direct = getnum(optarg, &endp)) == 0)
+				o_direct = 1;
+			break;
 		default:
 			usage();
 			/* NOTREACHED */
@@ -1321,20 +1458,21 @@ main(int argc, char **argv)
 	signal(SIGVTALRM,	cleanup);
 	signal(SIGUSR1,	cleanup);
 	signal(SIGUSR2,	cleanup);
+	signal(SIGSEGV,	segv);
 
 	initstate(seed, state, 256);
 	setstate(state);
 
 	open_test_files(argv, argc);
 
-	strncat(goodfile, dirpath ? basename(fname) : fname, 256);
+	strncat(goodfile, dirpath ? my_basename(fname) : fname, 256);
 	strcat (goodfile, ".fsxgood");
 	fsxgoodfd = open(goodfile, O_RDWR|O_CREAT|O_TRUNC, 0666);
 	if (fsxgoodfd < 0) {
 		prterr(goodfile);
 		exit(92);
 	}
-	strncat(logfile, dirpath ? basename(fname) : fname, 256);
+	strncat(logfile, dirpath ? my_basename(fname) : fname, 256);
 	strcat (logfile, ".fsxlog");
 	fsxlogf = fopen(logfile, "w");
 	if (fsxlogf == NULL) {
@@ -1363,14 +1501,16 @@ main(int argc, char **argv)
 	for (i = 0; i < maxfilelen; i++)
 		original_buf[i] = random() % 256;
 
-	good_buf = (char *) malloc(maxfilelen);
-	if (good_buf == NULL)
+	orig_good_buf = malloc(maxfilelen + page_size);
+	if (orig_good_buf == NULL)
 		exit(97);
+	good_buf = round_up(orig_good_buf, page_size);
 	memset(good_buf, '\0', maxfilelen);
 
-	temp_buf = (char *) malloc(maxoplen);
-	if (temp_buf == NULL)
+	orig_temp_buf = malloc(maxoplen + page_size);
+	if (orig_temp_buf == NULL)
 		exit(99);
+	temp_buf = round_up(orig_temp_buf, page_size);
 	memset(temp_buf, '\0', maxoplen);
 
 	if (lite) {	/* zero entire existing file */
@@ -1388,8 +1528,9 @@ main(int argc, char **argv)
 				     (unsigned)written, maxfilelen);
 			exit(98);
 		}
-	} else
+	} else {
 		check_trunc_hack();
+	}
 
 	while (numops == -1 || numops--)
 		test();
@@ -1401,10 +1542,8 @@ main(int argc, char **argv)
 		free(tf_buf);
 
 	free(original_buf);
-	free(good_buf);
-	free(temp_buf);
+	free(orig_good_buf);
+	free(orig_temp_buf);
 
 	return 0;
 }

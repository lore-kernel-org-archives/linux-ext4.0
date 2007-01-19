From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: patch for fsx-linux
Date: Fri, 19 Jan 2007 14:47:29 +0530
Message-ID: <20070119091729.GC28912@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42537 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbXASJRc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jan 2007 04:17:32 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0J9I5hw017265
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 04:18:05 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0J9HTGB303060
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 04:17:29 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0J9HSNn014318
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 04:17:28 -0500
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20070117094658.GA17390@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 17, 2007 at 03:16:58PM +0530, Amit K. Arora wrote:
> The patches for e2fsprogs and fsx-linux are available with me. I can
> post them if anyone is interested to try/test the preallocation patches.
> Also, I have a small test program/tool written which can be used for
> unit testing.

Here is the test patch for fsx-linux in LTP testsuite
(version ltp-full-20061121). This makes fsx call doprealloc (which does
preallocation ioctl) instead of dotruncate. Again, this is just for
testing (of persistent preallocation patches) purpose.

---
 testcases/kernel/fs/fsx-linux/fsx-linux.c |   90 ++++++++++++++++++++++++++++--
 1 files changed, 84 insertions(+), 6 deletions(-)

Index: ltp-full-20061121/testcases/kernel/fs/fsx-linux/fsx-linux.c
===================================================================
--- ltp-full-20061121.orig/testcases/kernel/fs/fsx-linux/fsx-linux.c
+++ ltp-full-20061121/testcases/kernel/fs/fsx-linux/fsx-linux.c
@@ -94,6 +94,7 @@ char	*good_buf;			/* a pointer to the co
 char	*temp_buf;			/* a pointer to the current data */
 char	*fname;				/* name of our test file */
 int	fd;				/* fd for our test file */
+int	block_size;			/* block size*/
 
 off_t		file_size = 0;
 off_t		biggest = 0;
@@ -115,6 +116,8 @@ int	truncbdy = 1;			/* -t flag */
 int	writebdy = 1;			/* -w flag */
 long	monitorstart = -1;		/* -m flag */
 long	monitorend = -1;		/* -m flag */
+int	prealloc = 0;			/* -x flag */
+int	ext4 = 0;			/* -x flag */
 int	lite = 0;			/* -L flag */
 long	numops = -1;			/* -N flag */
 int	randomoplen = 1;		/* -O flag disables it */
@@ -355,6 +358,19 @@ check_buffers(unsigned offset, unsigned 
 	}
 }
 
+int
+get_block_size(void)
+{
+	struct stat 	statbuf;
+
+	if (fstat(fd, &statbuf)) {
+		prterr("get_block_size: fstat");
+		report_failure(115);
+	}
+
+	return statbuf.st_blksize;
+}
+	
 
 void
 check_size(void)
@@ -628,6 +644,47 @@ domapwrite(unsigned offset, unsigned siz
 	}
 }
 
+#define EXT4_IOC_FALLOCATE    0x40106609
+void
+doprealloc(unsigned size)
+{
+	int ret;
+	struct ext4_falloc_input {
+		unsigned long long offset;
+		unsigned long long len;
+	} input;
+
+	if (!size) {
+		prt("skipping zero size preallocation\n");
+		return;
+	}
+
+	if (!ext4) {
+		prt("doprealloc: Preallocation currently supported "
+			"on ext4 _only_\n");
+		return;
+	}
+
+	input.offset = 0;
+	input.len = (unsigned long long)size;
+
+	if (testcalls <= simulatedopcount)
+		return;
+	
+	if (progressinterval && testcalls % progressinterval == 0 ||
+	    debug && (monitorstart == -1 || monitorend == -1 ||
+		      size <= monitorend))
+		prt("%lu trunc\tfrom 0x0 to 0x%x\n", testcalls, size);
+
+	ret = ioctl(fd, EXT4_IOC_FALLOCATE, &input);
+	if (ret < 0) {
+		prt("ioctl: %x\n", size);
+		prterr("doprealloc: ioctl");
+		report_failure(160);
+	} else
+		if (size > file_size)
+			file_size = (size + block_size - 1) & (~(block_size - 1));
+}
 
 void
 dotruncate(unsigned size)
@@ -679,7 +736,7 @@ writefileimage()
 			prt("short write: 0x%x bytes instead of 0x%qx\n",
 			    iret, (unsigned long long)file_size);
 		report_failure(172);
-	}
+	}	
 	if (lite ? 0 : ftruncate(fd, file_size) == -1) {
 	        prt("ftruncate2: %qx\n", (unsigned long long)file_size);
 		prterr("writefileimage: ftruncate");
@@ -742,13 +799,15 @@ test(void)
 	 * TRUNCATE:	op = 3
 	 * MAPWRITE:    op = 3 or 4
 	 */
-	if (lite ? 0 : op == 3 && (style & 1) == 0) /* vanilla truncate? */
-		dotruncate(random() % maxfilelen);
+	if (lite ? 0 : op == 3 && (style & 1) == 0) { /* vanilla truncate? */
+		size = random() % maxfilelen;
+		(prealloc) ? doprealloc(size) : dotruncate(size);
+	}
 	else {
 		if (randomoplen)
 			size = random() % (maxoplen+1);
 		if (lite ? 0 : op == 3)
-			dotruncate(size);
+			(prealloc) ? doprealloc(size) : dotruncate(size);
 		else {
 			offset = random();
 			if (op == 1 || op == (lite ? 3 : 4)) {
@@ -777,6 +836,7 @@ test(void)
 		check_size();
 	if (closeopen)
 		docloseopen();
+
 }
 
 
@@ -795,7 +855,7 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dnqLOW] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dnqLOW] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-x xfs/ext4] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
@@ -809,6 +869,7 @@ usage(void)
 	-s style: 1 gives smaller truncates (default 0)\n\
 	-t truncbdy: 4096 would make truncates page aligned (default 1)\n\
 	-w writebdy: 4096 would make writes page aligned (default 1)\n\
+	-x ext4/xfs: Do preallocate. filesystem can be either xfs, or ext4\n\
 	-D startingop: debug output starting at specified operation\n\
 	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
@@ -869,7 +930,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dl:m:no:p:qr:s:t:w:D:LN:OP:RS:W"))
+	while ((ch = getopt(argc, argv, "b:c:dl:m:no:p:qr:s:t:w:x:D:LN:OP:RS:W"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -946,6 +1007,17 @@ main(int argc, char **argv)
 			if (writebdy <= 0)
 				usage();
 			break;
+		case 'x':
+			prealloc = 1;
+			if (!strcmp(optarg, "ext4"))
+				ext4 = 1;
+			printf("ext4 = %u\n", ext4);
+			if (!ext4 && strcmp(optarg, "xfs"))
+				usage();
+			/* If we are here, ext4==1 signifies ext4 filesystem,
+			   else it signifies xfs filesystem */
+			
+			break;
 		case 'D':
 			debugstart = getnum(optarg, &endp);
 			if (debugstart < 1)
@@ -1015,6 +1087,12 @@ main(int argc, char **argv)
 		prterr(fname);
 		exit(91);
 	}
+
+	block_size = get_block_size();
+
+	if (prealloc)
+		doprealloc(maxfilelen);
+
 	strncat(goodfile, fname, 256);
 	strcat (goodfile, ".fsxgood");
 	fsxgoodfd = open(goodfile, O_RDWR|O_CREAT|O_TRUNC, 0666);
 
--
Regards,
Amit Arora

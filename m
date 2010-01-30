From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Date: Sat, 30 Jan 2010 05:55:01 -0500
Message-ID: <20100130105501.GA22909@infradead.org>
References: <4B633F9A.8000404@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0A3KzC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 05:55:02 -0500
Content-Disposition: inline
In-Reply-To: <4B633F9A.8000404@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 29, 2010 at 02:05:46PM -0600, Eric Sandeen wrote:
> Testcase from Giel de Nijs <giel@vectorwise.com>
> on linux-ext4 list, ""Possible ext4 data corruption
> with large files and async I/O," on 29 Jan 2010
> 
> ext4 put byte offsets in a block offset u32 container
> in the endio struct, so 4g wrapped to 0 leading to
> data corruption when the unwritten extent did not
> get converted.

There's various type messups in the test program that make it fail for
me on a 32-bit machine.  The patch below fixes it up, but it seems like
we should rather add a variant of that code as aio_read/write commands
to xfs_io instead of adding a new test program.

Index: xfstests-dev/src/aio-write.c
===================================================================
--- xfstests-dev.orig/src/aio-write.c	2010-01-30 10:42:24.000000000 +0000
+++ xfstests-dev/src/aio-write.c	2010-01-30 10:45:30.000000000 +0000
@@ -42,7 +42,7 @@ void usage(void)
 /*
  * Scale value by kilo, mega, or giga.
  */
-loff_t scale_by_kmg(long long value, char scale)
+long long scale_by_kmg(long long value, char scale)
 {
 switch (scale) {
 	case 'g':
@@ -69,7 +69,7 @@ switch (scale) {
 int main(int argc, char ** argv)
 {
 	char filename[PATH_MAX];
-	loff_t offset = 0;
+	long long offset = 0;
 	size_t length = 0;
 	int seed = 0xFF;
 	int queue_depth = 8;
@@ -95,12 +95,12 @@ int main(int argc, char ** argv)
 			seed = (int)strtol(optarg, &endp, 0);
 			break;
 		case 'o':
-			offset = strtol(optarg, &endp, 0);
-			offset = scale_by_kmg((long long)offset, *endp);
+			offset = strtoll(optarg, &endp, 0);
+			offset = scale_by_kmg(offset, *endp);
 			break;
 		case 'l':
 			length = strtol(optarg, &endp, 0);
-			length = scale_by_kmg((long long)length, *endp);
+			length = scale_by_kmg(length, *endp);
 			break;
 		case 'v':
 			verbose++;
@@ -141,7 +141,8 @@ int main(int argc, char ** argv)
 	io_prep_pwrite(&iocb, fd, buf, length, offset);
 	iocblist[0] = &iocb;
 	if (verbose)
-		printf("submitting write of %zd bytes at offset %zd\n", length, offset);
+		printf("submitting write of %zd bytes at offset %lld\n",
+			length, offset);
 	err = io_submit(io_ctx, 1, iocblist);
 	if (err < 0) {
 		printf("error submitting I/O requests: %s\n", strerror(-err));

From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/2] add manual for tool 'mksparse'
Date: Mon, 28 Feb 2011 10:35:14 +0800
Message-ID: <1298860514-615-2-git-send-email-hao.bigrat@gmail.com>
References: <1298860514-615-1-git-send-email-hao.bigrat@gmail.com>
Cc: tytso@mit.edu, Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1B1Cf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 21:35:27 -0500
Received: by mail-iy0-f174.google.com with SMTP id 26so2507379iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Feb 2011 18:35:26 -0800 (PST)
In-Reply-To: <1298860514-615-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

add manual for tool 'mksparse'.

Reviewed-by: Coly Li <bosong.ly@taobao.com>
Signed-off-by: Robing Dong <sanbai@taobao.com>
---
 misc/Makefile.in   |    5 +++
 misc/mksparse.8.in |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 0 deletions(-)
 create mode 100644 misc/mksparse.8.in

diff --git a/misc/Makefile.in b/misc/Makefile.in
index fcd316e..acea909 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -18,6 +18,7 @@ INSTALL = @INSTALL@
 @IMAGER_CMT@E2IMAGE_MAN= e2image.8
 
 @IMAGER_CMT@MKSPARSE_PROG= mksparse
+@IMAGER_CMT@MKSPARSE_MAN= mksparse.8
 
 @UUIDD_CMT@UUIDD_PROG= uuidd
 @UUIDD_CMT@UUIDD_MAN= uuidd.8
@@ -365,6 +366,10 @@ e2image.8: $(DEP_SUBSTITUTE) $(srcdir)/e2image.8.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2image.8.in e2image.8
 
+mksparse.8: $(DEP_SUBSTITUTE) $(srcdir)/mksparse.8.in
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/mksparse.8.in mksparse.8
+
 e4defrag.8: $(DEP_SUBSTITUTE) $(srcdir)/e4defrag.8.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e4defrag.8.in e4defrag.8
diff --git a/misc/mksparse.8.in b/misc/mksparse.8.in
new file mode 100644
index 0000000..8bc9955
--- /dev/null
+++ b/misc/mksparse.8.in
@@ -0,0 +1,86 @@
+.\" -*- nroff -*-
+.\" Copyright 2011 by Taobao.  All Rights Reserved.
+.\" This file may be copied under the terms of the GNU Public License.
+.\"
+.TH MKSPARSE 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+mksparse \- Make sparse file from an input file or the standard input
+.SH SYNOPSIS
+.B mksparse
+[
+.B \-s
+buffer-size
+]
+[
+.B \-i
+input-file
+]
+.I sparse-file
+.SH DESCRIPTION
+The
+.B mksparse
+makes sparse file from an input file or the standard input. Currently popular
+compressing tools like bzip2 or gunzip supports compressing a sparse file,
+but in decompressing they fill zero bytes into output other than make a sparse
+hole, which usually results a much larger file. If user downloads a
+compressed raw file system image built by
+.BR e2image (8)
+on a very large file system, it is almost impossible to decompress it on a
+desktop machine.
+.PP
+.B mksparse
+can read the decompressed stream from standard input and make a sparse file
+which takes less bytes on storage media. Here is the example,
+.PP
+.br
+\      \fBe2image \-r /dev/hda1 \- | bzip2 > hda1.bz2\fR
+.PP
+\      \fBbunzip2 \-c hda1.bz2 | mksparse hda1_sparse.img\fR
+.PP
+.SH OPTIONS
+.TP
+.I "sparse-file"
+The name specified to output file.
+.TP
+.BI \-i " input-file"
+Other than from standard input,
+.B mksparse
+is also able to make a sparse file named by 
+.I sparse-file
+from a regular file or device file which is specified by
+.I input-file
+.TP
+.BI \-s " buffer-size"
+By default
+.B mksparse
+reads 4KB bytes from input into its read buffer. If bytes in the buffer are
+all zero,
+.B mksparse
+makes a sparse hole to
+.I sparse-file
+by seeking
+.I buffer-size
+bytes from current possion of
+.I sparse-file
+, otherwise it writes the buffer to
+.I sparse-file
+. After a hole is made or the buffer is written,
+.B mksparse
+continues to read next
+.I buffer-size
+bytes from input file into its read buffer until the end of input. A larger
+.I buffer-size
+means better I/O performance but less chance to make more sparse space in
+.I sparse-file
+. In most cases, the default 4KB
+.I buffer-size
+works quite well.
+.SH AUTHOR
+.B mksparse
+is written by Robin Dong <sanbai@taobao.com>.
+.SH AVAILABILITY
+.B mksparse
+is part of the e2fsprogs package.
+.SH SEE ALSO
+.BR e2image (8)
+
-- 
1.7.3.5


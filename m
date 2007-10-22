From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 01/14] Reorder some of the $(SRCS) in alphabetical order.
Date: Sun, 21 Oct 2007 21:03:14 -0500
Message-ID: <20071022020314.23849.35338.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34657 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbXJVCGk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:06:40 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M26dFZ019952
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:06:39 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M26ds4083088
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:39 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M26dks016563
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:39 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M26daX016552
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:39 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Reorder some of the $(SRCS) in alphabetical order.

All files under $(OBJS) and $(SRCS) should be in alphabetical order
but this is not always the case.  Let fix some some of these before
applying new files to the list of $(SRCS).

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/Makefile.in |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 03ce131..ca65427 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -123,16 +123,16 @@ SRCS= ext2_err.c \
 	$(srcdir)/swapfs.c \
 	$(srcdir)/tdb.c \
 	$(srcdir)/test_io.c \
-	$(srcdir)/unix_io.c \
-	$(srcdir)/unlink.c \
-	$(srcdir)/valid_blk.c \
-	$(srcdir)/version.c \
-	$(srcdir)/write_bb_file.c \
 	$(srcdir)/tst_badblocks.c \
 	$(srcdir)/tst_bitops.c \
 	$(srcdir)/tst_byteswap.c \
 	$(srcdir)/tst_getsize.c \
-	$(srcdir)/tst_iscan.c
+	$(srcdir)/tst_iscan.c \
+	$(srcdir)/unix_io.c \
+	$(srcdir)/unlink.c \
+	$(srcdir)/valid_blk.c \
+	$(srcdir)/version.c \
+	$(srcdir)/write_bb_file.c
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
 	tdb.h

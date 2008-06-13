From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH]e2fsprogs: Fix broken "make check"
Date: Fri, 13 Jun 2008 14:04:01 -0500
Message-ID: <20080613140401.208b6f86@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:55266 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYFMTEJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2008 15:04:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5DJ43S6002852
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 15:04:03 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5DJ43lQ160034
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:04:03 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5DJ421A015494
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:04:02 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit: 51d12cebb61ca00f5455fe6e25938cd79fea15ab in pu fails to build
"make check".

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---

 e2fsck/Makefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 32743bc..0186112 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -143,12 +143,12 @@ tst_crc32: $(srcdir)/crc32.c $(LIBEXT2FS)
 tst_refcount: ea_refcount.c
 	@echo "	LD $@"
 	@$(CC) -o tst_refcount $(srcdir)/ea_refcount.c \
-		$(ALL_CFLAGS) -DTEST_PROGRAM -lcom_err
+		$(ALL_CFLAGS) -DTEST_PROGRAM -L$(LIB) -lcom_err
 
 tst_region: region.c
 	@echo "	LD $@"
 	@$(CC) -o tst_region $(srcdir)/region.c \
-		$(ALL_CFLAGS) -DTEST_PROGRAM -lcom_err
+		$(ALL_CFLAGS) -DTEST_PROGRAM -L$(LIB) -lcom_err
 
 check:: tst_refcount tst_region tst_crc32
 	./tst_refcount

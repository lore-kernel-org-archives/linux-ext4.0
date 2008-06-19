From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]e2fsprogs: Fix broken "make check"
Date: Thu, 19 Jun 2008 10:28:43 -0400
Message-ID: <20080619142843.GF11516@mit.edu>
References: <20080613140401.208b6f86@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39892 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbYFSO3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 10:29:14 -0400
Content-Disposition: inline
In-Reply-To: <20080613140401.208b6f86@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2008 at 02:04:01PM -0500, Jose R. Santos wrote:
> Commit: 51d12cebb61ca00f5455fe6e25938cd79fea15ab in pu fails to build
> "make check".
> 
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

Thanks for reporting this, although the cleaner and better way to fix
this is as follows:

					- Ted

>From 6f2ca692ecb993c23aabfcf3bb44376a03394cc0 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 19 Jun 2008 10:09:08 -0400
Subject: [PATCH] Fix "make check" in e2fsck subdirectory to use the in-tree com_err library

Thanks to Jose Santos for pointing this out

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/Makefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 32743bc..9b32a61 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -143,12 +143,12 @@ tst_crc32: $(srcdir)/crc32.c $(LIBEXT2FS)
 tst_refcount: ea_refcount.c
 	@echo "	LD $@"
 	@$(CC) -o tst_refcount $(srcdir)/ea_refcount.c \
-		$(ALL_CFLAGS) -DTEST_PROGRAM -lcom_err
+		$(ALL_CFLAGS) -DTEST_PROGRAM $(LIBCOM_ERR)
 
 tst_region: region.c
 	@echo "	LD $@"
 	@$(CC) -o tst_region $(srcdir)/region.c \
-		$(ALL_CFLAGS) -DTEST_PROGRAM -lcom_err
+		$(ALL_CFLAGS) -DTEST_PROGRAM $(LIBCOM_ERR)
 
 check:: tst_refcount tst_region tst_crc32
 	./tst_refcount
-- 
1.5.6.rc3.1.g36b7.dirty


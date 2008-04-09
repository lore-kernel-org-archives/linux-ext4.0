From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [E2FSPROGS, PATCH] Fix non-POSIX ">&" in the Makefile for lib/ss's "make check" rule
Date: Wed,  9 Apr 2008 15:58:37 -0400
Message-ID: <1207771117-15187-1-git-send-email-tytso@mit.edu>
References: <ea11fea30804091139x54b53d6al352a61e7a996bf80@mail.gmail.com>
Cc: Manish Katiyar <mkatiyar@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50609 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbYDIT6o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 15:58:44 -0400
In-Reply-To: <ea11fea30804091139x54b53d6al352a61e7a996bf80@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ss/Makefile.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index 23b5f60..8973fc9 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -170,7 +170,7 @@ test_ss: test_ss.o test_cmd.o $(LIBSS) $(LIBCOM_ERR)
 
 check:: all test_ss
 	@echo "	RUN TEST test_ss"
-	@(LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./test_ss -f $(srcdir)/test_script >& test_out; exit 0)
+	@(LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./test_ss -f $(srcdir)/test_script > test_out 2>&1; exit 0)
 	@if ! diff test_out $(srcdir)/test_script_expected > test.diff; then \
 		echo "Regression test for ss library failed!"; exit 1 ; fi
 
-- 
1.5.4.1.144.gdfee-dirty


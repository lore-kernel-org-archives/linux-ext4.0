From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] config: silence printf format warnings
Date: Fri, 4 Jan 2013 15:27:12 -0500
Message-ID: <20130104202711.GA22365@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:49391 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3ADU1S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 15:27:18 -0500
Received: by mail-vc0-f182.google.com with SMTP id fy27so16929657vcb.41
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jan 2013 12:27:17 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The printfs in the asm_types.c code contained within parse-types.sh
expect sizeof to return an int.  Fix this for architectures where
this isn't true (x86_64, etc.) so we don't see warning messages while
running the configure script.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 config/parse-types.sh |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/config/parse-types.sh b/config/parse-types.sh
index d7cb9cc..c02d8cb 100755
--- a/config/parse-types.sh
+++ b/config/parse-types.sh
@@ -31,7 +31,7 @@ main(int argc, char **argv)
 #ifdef __U8_TYPEDEF
 	if (sizeof(__U8_TYPEDEF) != 1) {
 		printf("Sizeof(__U8__TYPEDEF) is %d should be 1\n", 
-		       sizeof(__U8_TYPEDEF));
+		       (int) sizeof(__U8_TYPEDEF));
 		exit(1);
 	}
 #else
@@ -40,7 +40,7 @@ main(int argc, char **argv)
 #ifdef __S8_TYPEDEF
 	if (sizeof(__S8_TYPEDEF) != 1) {
 		printf("Sizeof(_S8__TYPEDEF) is %d should be 1\n", 
-		       sizeof(__S8_TYPEDEF));
+		       (int) sizeof(__S8_TYPEDEF));
 		exit(1);
 	}
 #else
@@ -49,7 +49,7 @@ main(int argc, char **argv)
 #ifdef __U16_TYPEDEF
 	if (sizeof(__U16_TYPEDEF) != 2) {
 		printf("Sizeof(__U16__TYPEDEF) is %d should be 2\n", 
-		       sizeof(__U16_TYPEDEF));
+		       (int) sizeof(__U16_TYPEDEF));
 		exit(1);
 	}
 #else
@@ -58,7 +58,7 @@ main(int argc, char **argv)
 #ifdef __S16_TYPEDEF
 	if (sizeof(__S16_TYPEDEF) != 2) {
 		printf("Sizeof(__S16__TYPEDEF) is %d should be 2\n", 
-		       sizeof(__S16_TYPEDEF));
+		       (int) sizeof(__S16_TYPEDEF));
 		exit(1);
 	}
 #else
@@ -68,7 +68,7 @@ main(int argc, char **argv)
 #ifdef __U32_TYPEDEF
 	if (sizeof(__U32_TYPEDEF) != 4) {
 		printf("Sizeof(__U32__TYPEDEF) is %d should be 4\n", 
-		       sizeof(__U32_TYPEDEF));
+		       (int) sizeof(__U32_TYPEDEF));
 		exit(1);
 	}
 #else
@@ -77,7 +77,7 @@ main(int argc, char **argv)
 #ifdef __S32_TYPEDEF
 	if (sizeof(__S32_TYPEDEF) != 4) {
 		printf("Sizeof(__S32__TYPEDEF) is %d should be 4\n", 
-		       sizeof(__S32_TYPEDEF));
+		       (int) sizeof(__S32_TYPEDEF));
 		exit(1);
 	}
 #else
@@ -87,7 +87,7 @@ main(int argc, char **argv)
 #ifdef __U64_TYPEDEF
 	if (sizeof(__U64_TYPEDEF) != 8) {
 		printf("Sizeof(__U64__TYPEDEF) is %d should be 8\n", 
-		       sizeof(__U64_TYPEDEF));
+		       (int) sizeof(__U64_TYPEDEF));
 		exit(1);
 	}
 #else
@@ -96,7 +96,7 @@ main(int argc, char **argv)
 #ifdef __S64_TYPEDEF
 	if (sizeof(__S64_TYPEDEF) != 8) {
 		printf("Sizeof(__S64__TYPEDEF) is %d should be 8\n", 
-		       sizeof(__S64_TYPEDEF));
+		       (int) sizeof(__S64_TYPEDEF));
 		exit(1);
 	}
 #else
-- 
1.7.10.4


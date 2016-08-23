From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] e4defrag: add error checking to nftw64() calls
Date: Tue, 23 Aug 2016 18:10:36 +0800
Message-ID: <b9218b362233c3748208f6c5fd47f65b3a8ccbe0.1471946731.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34504 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757852AbcHWKLY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Aug 2016 06:11:24 -0400
Received: by mail-pf0-f196.google.com with SMTP id g202so8041865pfb.1
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2016 03:11:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

nftw64() may go wrong sometimes, so add error checking to its calls.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 misc/e4defrag.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 1d1b4f4..edf54c9 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1856,7 +1856,12 @@ int main(int argc, char *argv[])
 							   PATH_MAX));
 			}
 
-			nftw64(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);
+			if (nftw64(dir_name, calc_entry_counts,
+						FTW_OPEN_FD, flags)) {
+				perror("nftw64 error");
+				PRINT_FILE_NAME(argv[i]);
+				continue;
+			}
 
 			if (mode_flag & STATISTIC) {
 				if (mode_flag & DETAIL)
@@ -1870,8 +1875,12 @@ int main(int argc, char *argv[])
 					continue;
 				}
 
-				nftw64(dir_name, file_statistic,
-							FTW_OPEN_FD, flags);
+				if (nftw64(dir_name, file_statistic,
+							FTW_OPEN_FD, flags)) {
+					perror("nftw64 error");
+					PRINT_FILE_NAME(argv[i]);
+					continue;
+				}
 
 				if (succeed_cnt != 0 &&
 					current_uid == ROOT_UID) {
@@ -1908,7 +1917,11 @@ int main(int argc, char *argv[])
 				break;
 			}
 			/* File tree walk */
-			nftw64(dir_name, file_defrag, FTW_OPEN_FD, flags);
+			if (nftw64(dir_name, file_defrag, FTW_OPEN_FD, flags)) {
+				perror("nftw64 error");
+				PRINT_FILE_NAME(argv[i]);
+				continue;
+			}
 			printf("\n\tSuccess:\t\t\t[ %u/%u ]\n", succeed_cnt,
 				total_count);
 			printf("\tFailure:\t\t\t[ %u/%u ]\n",
-- 
2.7.4


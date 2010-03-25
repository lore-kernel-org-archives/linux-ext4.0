From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] e2fsprogs: e4defrag must open the file to be defragged in
	read/write mode
Date: Thu, 25 Mar 2010 12:32:17 -0700
Message-ID: <20100325193216.GS29604@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45086 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab0CYTcV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Mar 2010 15:32:21 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2PJKupW006750
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 15:20:56 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2PJWIF8166622
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 15:32:18 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2PJWIGO003228
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 15:32:18 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira Fujita merged a patch into 2.6.33 that adds a requirement that a file
being defragged must be opened with read and write access, so e2fsprogs needs
to satisfy that.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1605,7 +1605,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		return 0;
 	}
 
-	fd = open64(file, O_RDONLY);
+	fd = open64(file, O_RDWR);
 	if (fd < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);

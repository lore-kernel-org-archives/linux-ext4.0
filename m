From: Jim Meyering <jim@meyering.net>
Subject: close /dev/urandom fd (e2fsprogs 1.40-WIP (7-Apr-2007))
Date: Fri, 15 Jun 2007 22:28:40 +0200
Message-ID: <878xalc687.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from postfix1-g20.free.fr ([212.27.60.42]:52159 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174AbXFOU3n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2007 16:29:43 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 347E31299B51
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2007 22:29:41 +0200 (CEST)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp3-g19.free.fr (Postfix) with ESMTP id 8ACE886F7
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2007 22:28:40 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The file descriptor opened on /dev/urandom can be closed sooner:

diff -r 11b6e3e021f0 -r 777972a573b3 lib/uuid/ChangeLog
--- a/lib/uuid/ChangeLog	Thu May 31 12:39:02 2007 -0400
+++ b/lib/uuid/ChangeLog	Fri Jun 15 18:05:09 2007 +0200
@@ -1,3 +1,8 @@ 2006-10-22  Theodore Tso  <tytso@mit.edu
+2007-06-15  Jim Meyering  <jim@meyering.net>
+
+	* gen_uuid.c (get_random_bytes): Don't leave /dev/urandom open.
+	(uuid_generate): Likewise.
+
 2006-10-22  Theodore Tso  <tytso@mit.edu>
 
 	* gen_uuid.c (get_random_bytes): Add in randomness based on
diff -r 11b6e3e021f0 -r 777972a573b3 lib/uuid/gen_uuid.c
--- a/lib/uuid/gen_uuid.c	Thu May 31 12:39:02 2007 -0400
+++ b/lib/uuid/gen_uuid.c	Fri Jun 15 18:05:09 2007 +0200
@@ -139,6 +139,7 @@ static void get_random_bytes(void *buf, 
 			cp += i;
 			lose_counter = 0;
 		}
+		close(fd);
 	}
 	
 	/*
@@ -337,8 +338,10 @@ void uuid_generate_random(uuid_t out)
  */
 void uuid_generate(uuid_t out)
 {
-	if (get_random_fd() >= 0)
+	int fd;
+	if ((fd = get_random_fd()) >= 0) {
+		close(fd);
 		uuid_generate_random(out);
-	else
+	} else
 		uuid_generate_time(out);
 }

Signed-off-by: Jim Meyering <jim@meyering.net>

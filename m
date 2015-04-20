From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: use $DUMPE2FS in resize_test script
Date: Mon, 20 Apr 2015 12:59:11 -0500
Message-ID: <55353E6F.7020406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbbDTR7N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 13:59:13 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t3KHxDjf032415
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2015 13:59:13 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t3KHxCxr003409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2015 13:59:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use $DUMPE2FS in resize tests to be sure it's testing
the in-tree dumpe2fs, not the system dumpe2fs (which may
not even be there...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(somehow I thought I had sent this, or something similar, before ...
can't find it, oh well!)

diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
index 0633e0c..dfd45ac 100755
--- a/tests/scripts/resize_test
+++ b/tests/scripts/resize_test
@@ -67,7 +67,7 @@ fi
 echo $FSCK -fy $TMPFILE >> $LOG 2>&1
 if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
-	dumpe2fs $TMPFILE >> $LOG
+	$DUMPE2FS $TMPFILE >> $LOG
 	return 1
 fi
 
@@ -97,7 +97,7 @@ fi
 echo $FSCK -fy $TMPFILE >> $LOG 2>&1
 if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
-	dumpe2fs $TMPFILE >> $LOG
+	$DUMPE2FS $TMPFILE >> $LOG
 	return 1
 fi
 
@@ -122,7 +122,7 @@ fi
 echo $FSCK -fy $TMPFILE >> $LOG 2>&1
 if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
-	dumpe2fs $TMPFILE >> $LOG
+	$DUMPE2FS $TMPFILE >> $LOG
 	return 1
 fi
 
@@ -147,7 +147,7 @@ fi
 echo $FSCK -fy $TMPFILE >> $LOG 2>&1
 if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
-	dumpe2fs $TMPFILE >> $LOG
+	$DUMPE2FS $TMPFILE >> $LOG
 	return 1
 fi
 


From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests 299-305: remove fio config files after finished test
Date: Tue, 19 Mar 2013 17:30:50 +0800
Message-ID: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:41541 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3CSJP1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 05:15:27 -0400
Received: by mail-da0-f50.google.com with SMTP id t1so194337dae.9
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 02:15:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After finished test, temporarily fio config file should be removed.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 299 | 2 +-
 300 | 2 +-
 301 | 2 +-
 302 | 2 +-
 303 | 2 +-
 304 | 2 +-
 305 | 1 +
 7 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/299 b/299
index 4305ead..9d0c32f 100644
--- a/299
+++ b/299
@@ -32,7 +32,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/300 b/300
index 73c9ea7..413f9eb 100644
--- a/300
+++ b/300
@@ -32,7 +32,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/301 b/301
index fe2e59f..6ac8ecf 100644
--- a/301
+++ b/301
@@ -30,7 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/302 b/302
index e3dceb8..62398c9 100644
--- a/302
+++ b/302
@@ -31,7 +31,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/303 b/303
index 4141442..d198ebb 100644
--- a/303
+++ b/303
@@ -31,7 +31,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/304 b/304
index 5c414bd..fb94fe6 100644
--- a/304
+++ b/304
@@ -32,7 +32,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/305 b/305
index 6393461..9d89321 100644
--- a/305
+++ b/305
@@ -80,6 +80,7 @@ _cleanup()
 {
     poweron_scratch_dev
     disallow_fail_make_request
+    rm -f $tmp-$seq.fio
 }
 trap "_cleanup; exit \$status" 1 2 3 15
 
-- 
1.7.12.rc2.18.g61b472e


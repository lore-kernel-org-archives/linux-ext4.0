From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfstests: add --largefs check option
Date: Mon, 21 Nov 2011 22:31:21 +1100
Message-ID: <1321875088-30801-2-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2168 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755631Ab1KULgq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 06:36:46 -0500
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dave Chinner <dchinner@redhat.com>

Make it easier to check large filesystems quickly by adding a
--large-fs option to check to turn on shortcuts for large scratch
device filesystem testing.

Also, reject invalid command line options with a usage message.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common |   63 +++++++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/common b/common
index 0723224..7d13078 100644
--- a/common
+++ b/common
@@ -27,6 +27,35 @@ _setenvironment()
     export MSGVERB
 }
 
+usage()
+{
+    echo "Usage: $0 [options] [testlist]"'
+
+common options
+    -v			verbose
+
+check options
+    -xfs                test XFS (default)
+    -udf                test UDF
+    -nfs                test NFS
+    -l			line mode diff
+    -xdiff		graphical mode diff
+    -udiff		show unified diff (default)
+    -n			show me, do not run tests
+    -q			quick [deprecated]
+    -T			output timestamps
+    -r			randomize test order
+    --large-fs		optimise scratch device for large filesystems
+
+testlist options
+    -g group[,group...]	include tests from these groups
+    -x group[,group...]	exclude tests from these groups
+    NNN			include test NNN
+    NNN-NNN		include test range (eg. 012-021)
+'
+	    exit 0
+}
+
 here=`pwd`
 rm -f $here/$iam.out
 _setenvironment
@@ -117,30 +146,7 @@ s/ .*//p
     in
 
 	-\? | -h | --help)	# usage
-	    echo "Usage: $0 [options] [testlist]"'
-
-common options
-    -v			verbose
-
-check options
-    -xfs                test XFS (default)
-    -udf                test UDF
-    -nfs                test NFS
-    -l			line mode diff
-    -xdiff		graphical mode diff
-    -udiff		show unified diff (default)
-    -n			show me, do not run tests
-    -q			quick [deprecated]
-    -T			output timestamps
-    -r 			randomize test order
-    
-testlist options
-    -g group[,group...]	include tests from these groups
-    -x group[,group...]	exclude tests from these groups
-    NNN			include test NNN
-    NNN-NNN		include test range (eg. 012-021)
-'
-	    exit 0
+	    usage
 	    ;;
 
 	-udf)	# -udf ... set FSTYP to udf
@@ -232,6 +238,15 @@ testlist options
 	    fi
 	    ;;
 
+	--large-fs)
+	    export USE_BIG_LOOPFS=yes
+	    xpand=false
+	    ;;
+
+	-*)
+	    usage
+	    ;;
+
 	*)
 	    start=$r
 	    end=$r
-- 
1.7.5.4


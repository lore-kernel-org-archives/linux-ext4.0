From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/2 v6] XFS TESTS: ENOSPC Punch Hole: Move su routines in 123 to common.rc
Date: Mon, 27 Jun 2011 22:32:42 -0700
Message-ID: <1309239163-3975-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch moves the su routines in test 123 to common.rc
so that they can also be used in the new test 255

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100755 100755 27c1e66... ee1194d... M	123
:100644 100644 680631d... 9d68574... M	common.rc
 123       |   24 ------------------------
 common.rc |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/123 b/123
index 27c1e66..ee1194d 100755
--- a/123
+++ b/123
@@ -42,30 +42,6 @@ _cleanup()
     _cleanup_testdir
 }
 
-
-_filter_user_do()
-{
-        perl -ne "
-s,.*Permission\sdenied.*,Permission denied,;
-s,.*no\saccess\sto\stty.*,,;
-s,.*no\sjob\scontrol\sin\sthis\sshell.*,,;
-s,^\s*$,,;
-        print;"
-}
-
-
-
-
-_user_do()
-{
-    if [ "$HOSTOS" == "IRIX" ]
-	then
-	echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
-    else
-	echo $1 | su $qa_user 2>&1 | _filter_user_do
-    fi
-}
-
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
diff --git a/common.rc b/common.rc
index 680631d..9d68574 100644
--- a/common.rc
+++ b/common.rc
@@ -867,6 +867,26 @@ _require_user()
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
 }
 
+_filter_user_do()
+{
+        perl -ne "
+s,.*Permission\sdenied.*,Permission denied,;
+s,.*no\saccess\sto\stty.*,,;
+s,.*no\sjob\scontrol\sin\sthis\sshell.*,,;
+s,^\s*$,,;
+        print;"
+}
+
+_user_do()
+{
+    if [ "$HOSTOS" == "IRIX" ]
+	then
+	echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
+    else
+	echo $1 | su $qa_user 2>&1 | _filter_user_do
+    fi  
+}
+
 # check that xfs_io, glibc, kernel, and filesystem all (!) support
 # fallocate
 #
-- 
1.7.1


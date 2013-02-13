From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/8] xfstests: Move run_check to common.rc
Date: Wed, 13 Feb 2013 12:50:00 +0400
Message-ID: <1360745403-6373-6-git-send-email-dmonakhov@openvz.org>
References: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dchinner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 276       |    6 ------
 common.rc |    8 +++++++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/276 b/276
index 082f943..c1ce8ac 100755
--- a/276
+++ b/276
@@ -165,12 +165,6 @@ _btrfs_inspect_check()
 	return $ret
 }
 
-run_check()
-{
-	echo "# $@" >> $seq.full 2>&1
-	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
-}
-
 workout()
 {
 	fsz=$1
diff --git a/common.rc b/common.rc
index ea5c477..5c3dda1 100644
--- a/common.rc
+++ b/common.rc
@@ -1806,7 +1806,13 @@ _scale_fsstress_args()
     done
     echo $args                                                                                            
 }
-  
+
+run_check()
+{
+	echo "# $@" >> $seq.full 2>&1
+	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
+}
+
 ################################################################################
 
 if [ "$iam" != new -a "$iam" != bench ]
-- 
1.7.1


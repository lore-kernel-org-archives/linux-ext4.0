From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 06/10] xfstest: move run_check to common.rc
Date: Wed, 20 Feb 2013 14:42:11 +0400
Message-ID: <1361356935-29153-7-git-send-email-dmonakhov@openvz.org>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dchinner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:36330 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab3BTKmd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2013 05:42:33 -0500
In-Reply-To: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


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
index 3635a45..e7ae9bf 100644
--- a/common.rc
+++ b/common.rc
@@ -1854,7 +1854,13 @@ _scale_fsstress_args()
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


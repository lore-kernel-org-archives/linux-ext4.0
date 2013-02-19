From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/11] xfstest: move run_check to common.rc
Date: Tue, 19 Feb 2013 15:37:19 +0400
Message-ID: <1361273843-16094-7-git-send-email-dmonakhov@openvz.org>
References: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

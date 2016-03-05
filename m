From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/12] xfs/23[3-6]: don't source common/xfs, it doesn't exist
Date: Fri, 04 Mar 2016 16:37:43 -0800
Message-ID: <20160305003743.28738.8245.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Don't source common/xfs, since it doesn't (yet) exist.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/233 |    1 -
 tests/xfs/234 |    1 -
 tests/xfs/235 |    1 -
 tests/xfs/236 |    1 -
 4 files changed, 4 deletions(-)


diff --git a/tests/xfs/233 b/tests/xfs/233
index f10af2b..8fcf766 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -39,7 +39,6 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
diff --git a/tests/xfs/234 b/tests/xfs/234
index 649cb7e..2bbf295 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -41,7 +41,6 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
diff --git a/tests/xfs/235 b/tests/xfs/235
index 5af72a6..370131b 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -41,7 +41,6 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 . ./common/attr
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
diff --git a/tests/xfs/236 b/tests/xfs/236
index 99e9a75..c7b3a19 100755
--- a/tests/xfs/236
+++ b/tests/xfs/236
@@ -41,7 +41,6 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux


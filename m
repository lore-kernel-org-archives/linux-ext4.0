From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/12] xfs/122: define _GNU_SOURCE when compiling test
 program
Date: Fri, 04 Mar 2016 16:38:09 -0800
Message-ID: <20160305003809.28738.85961.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This makes it so we don't get warnings about off64_t not being
defined when compiling the test program.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 758cb50..dc28c56 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -73,6 +73,7 @@ oprog=$tmp.get_structs
 progout=$tmp.output
 
 cat >$cprog <<EOF
+#define _GNU_SOURCE
 #include <stdio.h>
 EOF
 for hdr in /usr/include/xfs/xfs*.h; do

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] generic/458: document the fix commit
Date: Thu, 23 Nov 2017 08:43:42 +0200
Message-ID: <1511419423-7905-1-git-send-email-amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/458 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/458 b/tests/generic/458
index 7b408cb..730561f 100755
--- a/tests/generic/458
+++ b/tests/generic/458
@@ -4,6 +4,9 @@
 # Regression test for xfs leftover CoW extents after truncate
 # and umount
 #
+# Fixed by commit 3af423b03435 ("xfs: evict CoW fork extents when performing
+# finsert/fcollapse")
+#
 #-----------------------------------------------------------------------
 # Copyright (C) 2017 CTERA Networks. All Rights Reserved.
 # Author: Amir Goldstein <amir73il@gmail.com>
-- 
2.7.4

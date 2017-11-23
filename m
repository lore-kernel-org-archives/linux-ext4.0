From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] generic/456: document the fix commit
Date: Thu, 23 Nov 2017 08:43:43 +0200
Message-ID: <1511419423-7905-2-git-send-email-amir73il@gmail.com>
References: <1511419423-7905-1-git-send-email-amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1511419423-7905-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add a link to Ted's post with more details about the bug
and the fix.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

It may be better to include a digest of the refered post embedded
in the test. For now, I just added the link to mailing list archive.
Maybe Ted can add the digest later.

Thanks,
Amir.

 tests/generic/456 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/generic/456 b/tests/generic/456
index 8debd3f..ed3cacc 100755
--- a/tests/generic/456
+++ b/tests/generic/456
@@ -4,6 +4,9 @@
 # This test is motivated by a bug found in ext4 during random crash
 # consistency tests.
 #
+# Fixed by commit 51e3ae81ec58 ("ext4: fix interaction between i_size,
+# fallocate, and delalloc after a crash")
+#
 #-----------------------------------------------------------------------
 # Copyright (C) 2017 CTERA Networks. All Rights Reserved.
 # Author: Amir Goldstein <amir73il@gmail.com>
@@ -58,6 +61,8 @@ _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
 
+# See this post for reverse engineering of this auto generated test:
+# https://marc.info/?l=linux-ext4&m=151137380830381&w=2
 fsxops=$tmp.fsxops
 cat <<EOF > $fsxops
 write 0x137dd 0xdc69 0x0
-- 
2.7.4

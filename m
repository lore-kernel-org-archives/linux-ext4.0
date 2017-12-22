From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: use a slightly bigger file system in ext4/021
Date: Fri, 22 Dec 2017 13:26:07 -0500
Message-ID: <20171222182607.7745-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

An 8 MB file system may not be big enough for certain file system
configurations --- in particular, if the inode size is 2048 bytes.
Make the test file system 10MB instead.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/ext4/021 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/ext4/021 b/tests/ext4/021
index 8a780873..e46b43be 100755
--- a/tests/ext4/021
+++ b/tests/ext4/021
@@ -50,7 +50,7 @@ _require_scratch
 _require_dumpe2fs
 
 # 8M in bytes
-fssize=$((8 * 1024 * 1024))
+fssize=$((10 * 1024 * 1024))
 _scratch_mkfs_sized $fssize >> $seqres.full 2>&1
 _require_metadata_journaling $SCRATCH_DEV
 
-- 
2.11.0.rc0.7.gbe5a750

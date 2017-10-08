From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4/026: skip test if kernel does not support the ea_inode feature
Date: Sun,  8 Oct 2017 15:23:24 -0400
Message-ID: <20171008192324.20477-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/ext4/026 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/ext4/026 b/tests/ext4/026
index 94a737ce..ba77f36e 100755
--- a/tests/ext4/026
+++ b/tests/ext4/026
@@ -53,7 +53,8 @@ _require_attrs
 _require_ext4_mkfs_feature ea_inode
 
 _scratch_mkfs_ext4 -O ea_inode >/dev/null 2>&1
-_scratch_mount
+_scratch_mount >/dev/null 2>&1 \
+	|| _notrun "kernel doesn't support ea_inode feature on $FSTYP"
 
 # Sets an extended attribute on a file.
 attr_set()
-- 
2.11.0.rc0.7.gbe5a750

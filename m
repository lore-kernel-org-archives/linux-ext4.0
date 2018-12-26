Return-Path: <SRS0=Oy82=PD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr710129.outbound.protection.outlook.com ([40.107.71.129]:21856
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725921AbeLZQI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Dec 2018 11:08:26 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: <linux-fstests@mit.edu>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Liu Bo <obuil.liubo@gmail.com>
Subject: [PATCH] ext4/034: adjust commit which fixes the problem tested by ext4/034
Date: Wed, 26 Dec 2018 11:08:05 -0500
Message-ID: <20181226160805.8987-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also add a requirment that fallocate and fiemap is supported.
(Fallocate isn't the case when we are emulating ext3, for example.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Liu Bo <obuil.liubo@gmail.com>
---
 tests/ext4/034 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/ext4/034 b/tests/ext4/034
index 5c34d0d9..f9e4bfaf 100755
--- a/tests/ext4/034
+++ b/tests/ext4/034
@@ -8,7 +8,7 @@
 # "-o dioread_nolock,nodelalloc" is used.
 #
 # The bug was fixed by commit
-# "Ext4: fix ENOSPC when both quota and dioread_nolock are enabled"
+# "ext4: make sure enough credits are reserved for dioread_nolock writes"
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -41,6 +41,8 @@ _supported_os Linux
 _require_scratch
 _require_quota
 _require_nobody
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
 _require_xfs_io_command "syncfs"
 
 echo "Format and mount"
-- 
2.19.1

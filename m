From: Marius Bakke <mbakke@fastmail.com>
Subject: [PATCH e2fsprogs] tests: Fixup for new r_move_itable tests.
Date: Sat, 11 Nov 2017 08:55:40 +0100
Message-ID: <20171111075540.21722-1-mbakke@fastmail.com>
Cc: Marius Bakke <mbakke@fastmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35075 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751616AbdKKHzs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 11 Nov 2017 02:55:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commits 257f009d1034737096f197dc875931207bcdfc75 and
2b50c18a8a12781c26b71873f4368fe61711d9f9 missed one pass in expected
output.

Signed-off-by: Marius Bakke <mbakke@fastmail.com>
---
 tests/r_move_itable_nostride/expect | 2 ++
 tests/r_move_itable_realloc/expect  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tests/r_move_itable_nostride/expect b/tests/r_move_itable_nostride/expect
index 098cbfc5..4976e65e 100644
--- a/tests/r_move_itable_nostride/expect
+++ b/tests/r_move_itable_nostride/expect
@@ -1,6 +1,8 @@
 mke2fs -q -F -o Linux -b 1024 -i 1024 -E stride=8192 -t ext4 test.img 1024000
 resize2fs -p test.img 10240000
 Resizing the filesystem on test.img to 100000000 (1k) blocks.
+Begin pass 1 (max = 12082)
+Extending the inode table     ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 Begin pass 2 (max = 2062)
 Relocating blocks             ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 Begin pass 3 (max = 125)
diff --git a/tests/r_move_itable_realloc/expect b/tests/r_move_itable_realloc/expect
index 73b2fef0..1312d954 100644
--- a/tests/r_move_itable_realloc/expect
+++ b/tests/r_move_itable_realloc/expect
@@ -1,6 +1,8 @@
 mke2fs -q -F -o Linux -b 1024 -i 1024 -O ^resize_inode -t ext4 test.img 1024000
 resize2fs -p test.img 10240000
 Resizing the filesystem on test.img to 100000000 (1k) blocks.
+Begin pass 1 (max = 12082)
+Extending the inode table     ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 Begin pass 2 (max = 2061)
 Relocating blocks             ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 Begin pass 3 (max = 125)
-- 
2.15.0

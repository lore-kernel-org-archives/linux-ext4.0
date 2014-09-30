From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] shared/272: fail quickly on mkfs errors and improve logging
Date: Tue, 30 Sep 2014 15:50:04 -0400
Message-ID: <20140930195004.GB5803@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:37762 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaI3TuQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2014 15:50:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

272 will log diagnostic information if it fails to make its scratch file
system, but the test itself won't fail immediately.  If the scratch
device had previously contained a valid filesystem, and the attempt to
make a small scratch file system on it fails, 272 will mount and run on
the pre-existing file system (as seen during ext4 inline data testing).
Since 272 tests to ENOSPC, it can take a long time to learn mkfs failed.
This behavior can also lead to invalid positive test results unless
272.full is examined separately.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/shared/272 | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/shared/272 b/tests/shared/272
index 4417535..9695e59 100755
--- a/tests/shared/272
+++ b/tests/shared/272
@@ -87,8 +87,11 @@ _supported_os Linux
 _need_to_be_root
 _require_scratch
 
-_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1
-_scratch_mount
+rm -f $seqres.full
+
+_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1 \
+	|| _fail "mkfs failed"
+_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
 
 if ! _workout; then
 	echo "workout failed"
-- 
1.9.1


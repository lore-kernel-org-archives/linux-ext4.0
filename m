From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: require fallocate support to run ext4/307
Date: Mon,  8 Sep 2014 00:05:48 -0400
Message-ID: <1410149148-26533-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42907 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbaIHEF6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Sep 2014 00:05:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some file system configurations don't support fallocate, which is
required for e4defrag to run.  So add a _require_xfs_io_command to
prevent a test failure if fallocate isn't supported in (for example)
ext3 compatibility mode.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/307 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/ext4/307 b/tests/ext4/307
index 081f819..673b9ce 100755
--- a/tests/ext4/307
+++ b/tests/ext4/307
@@ -64,6 +64,7 @@ _supported_os Linux
 _need_to_be_root
 _require_scratch
 _require_defrag
+_require_xfs_io_command "falloc"
 
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
-- 
2.1.0


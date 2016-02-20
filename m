From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld: add exclude file for ext3 tests
Date: Sat, 20 Feb 2016 10:51:57 -0500
Message-ID: <20160220155157.GA19420@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35848 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbcBTPvl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Feb 2016 10:51:41 -0500
Received: by mail-qk0-f179.google.com with SMTP id s68so41797279qkh.3
        for <linux-ext4@vger.kernel.org>; Sat, 20 Feb 2016 07:51:41 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add an exclude file for the ext3 test case to prevent failure reports
from tests that exercise unsupported online defrag functionality.

Two online defrag tests - ext4/307 and /308 - are not included because
they contain explicit requirements for fallocate support that prevents
them from running on an emulated ext3 file system.

It may be possible to modify the excluded tests at a future date so they
will not run unless the test file system is extent mapped.  For now, this
patch is an expedient measure to reduce testing noise.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/conf/ext3.exclude | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 kvm-xfstests/test-appliance/files/root/conf/ext3.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/conf/ext3.exclude b/kvm-xfstests/test-appliance/files/root/conf/ext3.exclude
new file mode 100644
index 0000000..c46c79b
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/conf/ext3.exclude
@@ -0,0 +1,6 @@
+# ext4's ext3 emulation does not support on-line
+# defrag, which requires extent-based files
+ext4/301
+ext4/302
+ext4/303
+ext4/304
-- 
2.1.4


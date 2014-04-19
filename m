From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix check for zero range support in ext4/001
Date: Sat, 19 Apr 2014 15:08:15 -0400
Message-ID: <20140419190815.GB2116@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:45945 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbaDSTIT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Apr 2014 15:08:19 -0400
Received: by mail-qa0-f42.google.com with SMTP id k15so2634938qaq.29
        for <linux-ext4@vger.kernel.org>; Sat, 19 Apr 2014 12:08:18 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4/001 fails when run on a file system that does not support byte range
zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
on a pre-3.15 extent-mapped file system.  The code in the test intended
to prevent this contains an apparent typo that results in a check for
fallocate() rather than zero range support.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/001 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/ext4/001 b/tests/ext4/001
index d575d9a..827d806 100755
--- a/tests/ext4/001
+++ b/tests/ext4/001
@@ -45,7 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs ext4
 _supported_os Linux
-_require_xfs_io_falloc "fzero"
+_require_xfs_io_command "fzero"
 
 testfile=$TEST_DIR/001.$$
 
-- 
1.8.3.2


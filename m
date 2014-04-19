From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic: fix check for zero range support in generic/009
Date: Sat, 19 Apr 2014 15:05:24 -0400
Message-ID: <20140419190524.GA2116@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:46535 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbaDSTF2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Apr 2014 15:05:28 -0400
Received: by mail-qc0-f179.google.com with SMTP id m20so2803498qcx.10
        for <linux-ext4@vger.kernel.org>; Sat, 19 Apr 2014 12:05:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic/001 fails when run on a file system that does not support byte range
zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
on a pre-3.15 extent-mapped file system.  The code in the test intended
to prevent this contains an apparent typo that results in a check for
fallocate() rather than zero range support.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/009 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/009 b/tests/generic/009
index b7b0b3f..65abe3c 100644
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -44,7 +44,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_os Linux
-_require_xfs_io_falloc "fzero"
+_require_xfs_io_command "fzero"
 
 testfile=$TEST_DIR/009.$$
 
-- 
1.8.3.2


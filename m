From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH v3 3/3] generic: fix check for zero range support in
 generic/009
Date: Mon, 21 Apr 2014 16:44:54 -0400
Message-ID: <20140421204454.GD960@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:34476 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaDUUo6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2014 16:44:58 -0400
Received: by mail-yh0-f54.google.com with SMTP id f73so4022108yha.27
        for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2014 13:44:57 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic/001 fails when run on a file system that does not support byte range
zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
on a pre-3.15 extent-mapped file system.  The code in the test intended
to prevent this contains an apparent typo that results in a check for
fallocate() rather than zero range support.

v2: Use new helper function for the check.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/009 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/009 b/tests/generic/009
index b7b0b3f..b4d3e4b 100644
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -44,7 +44,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_os Linux
-_require_xfs_io_falloc "fzero"
+_require_xfs_io_falloc_zero
 
 testfile=$TEST_DIR/009.$$
 
-- 
1.8.3.2


From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH][RESEND]  xfstests: only run generic/300 on filesystems
 supporting
Date: Fri, 6 Sep 2013 15:42:43 -0400
Message-ID: <20130906194243.GA19286@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:58810 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3IFTms (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Sep 2013 15:42:48 -0400
Received: by mail-qa0-f44.google.com with SMTP id w8so707356qac.3
        for <linux-ext4@vger.kernel.org>; Fri, 06 Sep 2013 12:42:47 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic/300 fails when run on a test filesystem that does not support
fallocate(), as in the case of an ext4 filesystem created without the
extent feature.  It uses fio's falloc ioengine to generate part of its
I/O load.

Verify that the test filesystem supports fallocate() before proceeding
with the test.  Also, delete any pre-existing test output to avoid
confusion with old results.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/300 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..1ac763b 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -43,6 +43,9 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_xfs_io_falloc
+
+rm -f $seqres.full
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-- 
1.7.10.4


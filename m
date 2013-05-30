From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3 v2] 285: Fix test for ext4 in some configurations
Date: Thu, 30 May 2013 23:21:43 +0200
Message-ID: <1369948905-6693-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757718Ab3E3VVt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 17:21:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In some configurations (e.g. 1 KB block size), ext4 can decide it is
better to zero out several blocks rather than splitting unwritten
extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
test fails. Fix the problem by disabling the feature for this test.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/generic/285 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/generic/285 b/tests/generic/285
index b700a15..8078b1c 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -46,6 +46,12 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
 [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
 
+# Disable extent zeroing for ext4 as that change where holes are created
+if [ "$FSTYP" = "ext4" ]; then
+	DEV=`basename $TEST_DEV`
+	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
+fi
+
 _cleanup()
 {
 	eval "rm -f $BASE_TEST_FILE.*"
-- 
1.8.1.4


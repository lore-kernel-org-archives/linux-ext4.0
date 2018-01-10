From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] common/rc: ext4 doesn't support O_DIRECT with data journaling
Date: Wed, 10 Jan 2018 16:19:05 -0500
Message-ID: <20180110211905.4ulqeqnwbs2bh66o@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:46219 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbeAJVTJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jan 2018 16:19:09 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Modify _require_odirect() to skip O_DIRECT tests if the ext4 mount
option data=journal has been applied.  Because ext4 disables its
O_DIRECT support when in data journaling mode, no significant value is
obtained by running these tests and they consume a significant amount
of run time.  Additionally, this change eliminates the need to triage
false negative O_DIRECT test results caused by test problems, as has
occurred from time to time.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 9216efdb..86cc9665 100644
--- a/common/rc
+++ b/common/rc
@@ -2150,6 +2150,8 @@ _require_odirect()
 	if [ $FSTYP = "ext4" ] ; then
 		if echo "$MOUNT_OPTIONS" | grep -q "test_dummy_encryption"; then
 			_notrun "ext4 encryption doesn't support O_DIRECT"
+		elif echo "$MOUNT_OPTIONS" | grep -q "data=journal"; then
+			_notrun "ext4 data journaling doesn't support O_DIRECT"
 		fi
 	fi
 	testfile=$TEST_DIR/$$.direct
-- 
2.11.0

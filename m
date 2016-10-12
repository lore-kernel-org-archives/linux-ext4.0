From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld: fix check script argument ordering bug
Date: Wed, 12 Oct 2016 17:38:12 -0400
Message-ID: <20161012213812.GA8131@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34218 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbcJLVkN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Oct 2016 17:40:13 -0400
Received: by mail-qk0-f180.google.com with SMTP id f128so54235376qkb.1
        for <linux-ext4@vger.kernel.org>; Wed, 12 Oct 2016 14:39:37 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The check script called by runtests.sh in the test appliance to control
xfstest execution requires that all optional arguments precede any test
names on its command line.  Violation of this requirement results in an
error message ("Arguments before tests, please!") and an immediate exit
without test execution.

runtests.sh violates this requirement when it runs a specific test in a
configuration that defines TEST_SET_EXCLUDE (contains -x argument).

To reproduce the bug, run "kvm-xfstests -c bigalloc generic/375".

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/runtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm-xfstests/test-appliance/files/root/runtests.sh b/kvm-xfstests/test-appliance/files/root/runtests.sh
index a9338dc..5e6c1f7 100755
--- a/kvm-xfstests/test-appliance/files/root/runtests.sh
+++ b/kvm-xfstests/test-appliance/files/root/runtests.sh
@@ -374,7 +374,7 @@ do
 	gce_run_hooks fs-config-begin $i
 	for j in $(seq 1 $RPT_COUNT) ; do
 	    gce_run_hooks pre-xfstests $i $j
-	    bash ./check -T $AEX $FSTESTSET $TEST_SET_EXCLUDE
+	    bash ./check -T $AEX $TEST_SET_EXCLUDE $FSTESTSET
 	    gce_run_hooks post-xfstests $i $j
 	    umount "$TEST_DEV" >& /dev/null
 	    check_filesystem "$TEST_DEV" >& $RESULT_BASE/fsck.out
-- 
2.1.4


From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] xfstests-bld: test-apliance add costomization options
Date: Wed, 22 Oct 2014 19:37:40 +0400
Message-ID: <1413992260-21707-2-git-send-email-dmonakhov@openvz.org>
References: <1413992260-21707-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:47359 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbaJVPhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 11:37:54 -0400
In-Reply-To: <1413992260-21707-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a possibility to customize variables similar to kvm-xfstests/config.custom
One can add local mirrors to speedup image generation

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 kvm-xfstests/test-appliance/gen-root-image |    3 +++
 kvm-xfstests/test-appliance/gen-test-image |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/kvm-xfstests/test-appliance/gen-root-image b/kvm-xfstests/test-appliance/gen-root-image
index 977c4c2..516b7b5 100644
--- a/kvm-xfstests/test-appliance/gen-root-image
+++ b/kvm-xfstests/test-appliance/gen-root-image
@@ -12,6 +12,9 @@ RAW_ROOT_FS=$DIR/root_fs.raw
 ROOT_FS=$DIR/root_fs.img
 COMPAT="-o compat=0.10"
 
+if test -f $DIR/config.custom ; then
+   . $DIR/config.custom
+fi
 
 if test $(df -k /tmp | tail -1 | awk '{print $4}') -gt 350000
 then
diff --git a/kvm-xfstests/test-appliance/gen-test-image b/kvm-xfstests/test-appliance/gen-test-image
index ab02592..fde1798 100755
--- a/kvm-xfstests/test-appliance/gen-test-image
+++ b/kvm-xfstests/test-appliance/gen-test-image
@@ -8,6 +8,9 @@ TEST_FS=$DIR/test_fs.img
 TESTDIR=$DIR/testdir
 COMPAT="-o compat=0.10"
 
+if test -f $DIR/config.custom ; then
+   . $DIR/config.custom
+fi
 
 if test $(df -k /tmp | tail -1 | awk '{print $4}') -gt 350000
 then
-- 
1.7.10.4


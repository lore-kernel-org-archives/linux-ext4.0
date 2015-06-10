From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld: exclude ext4 defrag tests from unsupported
 configurations
Date: Wed, 10 Jun 2015 14:13:19 -0400
Message-ID: <20150610181319.GA23530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vn0-f50.google.com ([209.85.216.50]:41551 "EHLO
	mail-vn0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbbFJS2h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2015 14:28:37 -0400
Received: by vnbg190 with SMTP id g190so9553103vnb.8
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2015 11:28:37 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Online defrag is not currently implemented for journaled data and
bigalloc ext4 file systems.  The xfstests that exercise online defrag
do not verify that the test file system supports that feature before
executing, resulting in spurious test failures.  (In the case of
ext4/307, the test reports success but actually fails because the
e4compact test component is ignoring failures.)

For the time being, simply exclude these tests to eliminate the test
failure noise.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/conf/bigalloc.exclude     | 6 ++++++
 kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k.exclude  | 6 ++++++
 kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude | 6 ++++++
 3 files changed, 18 insertions(+)
 create mode 100644 kvm-xfstests/test-appliance/files/root/conf/bigalloc.exclude
 create mode 100644 kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/conf/bigalloc.exclude b/kvm-xfstests/test-appliance/files/root/conf/bigalloc.exclude
new file mode 100644
index 0000000..b925016
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/conf/bigalloc.exclude
@@ -0,0 +1,6 @@
+ext4/301
+ext4/302
+ext4/303
+ext4/304
+ext4/307
+ext4/308
diff --git a/kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k.exclude b/kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k.exclude
new file mode 100644
index 0000000..b925016
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k.exclude
@@ -0,0 +1,6 @@
+ext4/301
+ext4/302
+ext4/303
+ext4/304
+ext4/307
+ext4/308
diff --git a/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude b/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
index e2bcac3..5d3dcae 100644
--- a/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
+++ b/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
@@ -1 +1,7 @@
+ext4/301
+ext4/302
+ext4/303
+ext4/304
+ext4/307
+ext4/308
 generic/068
-- 
2.1.4


From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld: delete exclude files containing ext4 defrag
 tests
Date: Mon, 15 Aug 2016 13:24:59 -0400
Message-ID: <20160815172459.GA2185@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36720 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbcHORVZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Aug 2016 13:21:25 -0400
Received: by mail-qt0-f194.google.com with SMTP id u25so2316456qtb.3
        for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2016 10:21:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The _require_defrag function in xfstests can now correctly determine
whether an ext4 test file system supports the online defrag feature.
The exclude files that were added to prevent test failure noise when
running online defrag tests on journaled data and bigalloc file systems
are no longer necessary.  These tests include ext4/301-304 and
ext4/307-308.

ext4/304 remains in the master exclude file for an unrelated problem.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 .../test-appliance/files/root/fs/ext4/cfg/bigalloc.exclude         | 7 -------
 .../test-appliance/files/root/fs/ext4/cfg/bigalloc_1k.exclude      | 7 -------
 .../test-appliance/files/root/fs/ext4/cfg/data_journal.exclude     | 7 -------
 .../files/root/fs/ext4/cfg/data_journal_noleak.exclude             | 7 -------
 4 files changed, 28 deletions(-)
 delete mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc.exclude
 delete mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc_1k.exclude
 delete mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal.exclude
 delete mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal_noleak.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc.exclude
deleted file mode 100644
index bd779be..0000000
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc.exclude
+++ /dev/null
@@ -1,7 +0,0 @@
-# bigalloc does not support on-line defrag
-ext4/301
-ext4/302
-ext4/303
-ext4/304
-ext4/307
-ext4/308
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc_1k.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc_1k.exclude
deleted file mode 100644
index bd779be..0000000
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/bigalloc_1k.exclude
+++ /dev/null
@@ -1,7 +0,0 @@
-# bigalloc does not support on-line defrag
-ext4/301
-ext4/302
-ext4/303
-ext4/304
-ext4/307
-ext4/308
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal.exclude
deleted file mode 100644
index 7190c8c..0000000
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal.exclude
+++ /dev/null
@@ -1,7 +0,0 @@
-# data_journal does not support on-line defrag
-ext4/301
-ext4/302
-ext4/303
-ext4/304
-ext4/307
-ext4/308
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal_noleak.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal_noleak.exclude
deleted file mode 100644
index 7190c8c..0000000
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/data_journal_noleak.exclude
+++ /dev/null
@@ -1,7 +0,0 @@
-# data_journal does not support on-line defrag
-ext4/301
-ext4/302
-ext4/303
-ext4/304
-ext4/307
-ext4/308
-- 
2.1.4


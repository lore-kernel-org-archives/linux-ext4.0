From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld: add exclude file for data_journal_noleak tests
Date: Tue, 12 Jan 2016 14:52:48 -0500
Message-ID: <20160112195248.GA1941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34325 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbcALTxM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 14:53:12 -0500
Received: by mail-qg0-f45.google.com with SMTP id 6so359102639qgy.1
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 11:53:12 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Duplicate the contents of the data_journal exclude file for the
data_journal_noleak test case.  This will prevent failure reports from
tests already known to exercise unsupported online defrag functionality.
Add an explanatory comment to both exclude files for future reference.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude   | 1 +
 .../test-appliance/files/root/conf/data_journal_noleak.exclude     | 7 +++++++
 2 files changed, 8 insertions(+)
 create mode 100644 kvm-xfstests/test-appliance/files/root/conf/data_journal_noleak.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude b/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
index b925016..7190c8c 100644
--- a/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
+++ b/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
@@ -1,3 +1,4 @@
+# data_journal does not support on-line defrag
 ext4/301
 ext4/302
 ext4/303
diff --git a/kvm-xfstests/test-appliance/files/root/conf/data_journal_noleak.exclude b/kvm-xfstests/test-appliance/files/root/conf/data_journal_noleak.exclude
new file mode 100644
index 0000000..7190c8c
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/conf/data_journal_noleak.exclude
@@ -0,0 +1,7 @@
+# data_journal does not support on-line defrag
+ext4/301
+ext4/302
+ext4/303
+ext4/304
+ext4/307
+ext4/308
-- 
2.1.4


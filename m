From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld: remove nojournal.exclude
Date: Wed, 10 Jun 2015 14:16:02 -0400
Message-ID: <20150610181602.GB23530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vn0-f65.google.com ([209.85.216.65]:34707 "EHLO
	mail-vn0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbbFJS2c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2015 14:28:32 -0400
Received: by vnbf7 with SMTP id f7so5005482vnb.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2015 11:28:31 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The xfstests listed in the nojournal.exclude file have all been modified
so they will only run on a test file system that journals metadata.
This prevents the spurious test failures previously seen when running
these tests (including generic/034, generic/311, generic/321,
generic/322, and generic/325) in the nojournal test configuration.

Remove nojournal.exclude since it's no longer needed to suppress test
failure noise.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/conf/nojournal.exclude | 5 -----
 1 file changed, 5 deletions(-)
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/nojournal.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/conf/nojournal.exclude b/kvm-xfstests/test-appliance/files/root/conf/nojournal.exclude
deleted file mode 100644
index 33780bb..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/nojournal.exclude
+++ /dev/null
@@ -1,5 +0,0 @@
-generic/034
-generic/311
-generic/321
-generic/322
-generic/325
-- 
2.1.4


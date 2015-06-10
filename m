From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld:  remove inline.exclude
Date: Wed, 10 Jun 2015 14:18:04 -0400
Message-ID: <20150610181804.GC23530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:38195 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbbFJSgU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2015 14:36:20 -0400
Received: by vnbf190 with SMTP id f190so9591978vnb.5
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2015 11:36:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Once upon a time, xfstest generic/027 would fail consistently when run
in the inline test configuration, and an inline.exclude file was
created containing it to suppress the resulting failure messages.
However, generic/027 has been running and completing successfully in
weekly -rc regression runs for more than six months on test systems
not using the exclude file.  We should be able to stop excluding it now.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/conf/inline.exclude | 1 -
 1 file changed, 1 deletion(-)
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/inline.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/conf/inline.exclude b/kvm-xfstests/test-appliance/files/root/conf/inline.exclude
deleted file mode 100644
index 9a059f8..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/inline.exclude
+++ /dev/null
@@ -1 +0,0 @@
-generic/027
-- 
2.1.4


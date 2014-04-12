From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 1/2] xfstests-bld: get-results: add -a option for grep, to process binary files as text
Date: Sat, 12 Apr 2014 14:07:22 +0400
Message-ID: <1397297243-12130-1-git-send-email-a3at.mail@gmail.com>
Cc: Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63882 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaDLKH5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Apr 2014 06:07:57 -0400
Received: by mail-lb0-f171.google.com with SMTP id w7so4288868lbi.16
        for <linux-ext4@vger.kernel.org>; Sat, 12 Apr 2014 03:07:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since logs can have some _non ASCII_ symbols and grep think that this is
a binary file.

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 kvm-xfstests/get-results | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm-xfstests/get-results b/kvm-xfstests/get-results
index be4a729..4151e36 100755
--- a/kvm-xfstests/get-results
+++ b/kvm-xfstests/get-results
@@ -1,2 +1,2 @@
 #!/bin/sh
-egrep "(^BEGIN)|(^END)|(^Ran: )|(^Failures: )|(^Passed)|(inconsistent)" $*
+egrep -a "(^BEGIN)|(^END)|(^Ran: )|(^Failures: )|(^Passed)|(inconsistent)" $*
-- 
1.9.0


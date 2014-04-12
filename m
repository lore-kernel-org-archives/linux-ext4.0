From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [RFC PATCH 2/2] xfstests-bld: fstab: drop usbfs (we don't need them for fs tests)
Date: Sat, 12 Apr 2014 14:08:53 +0400
Message-ID: <1397297333-12620-1-git-send-email-a3at.mail@gmail.com>
Cc: Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55241 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaDLKI6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Apr 2014 06:08:58 -0400
Received: by mail-lb0-f175.google.com with SMTP id w7so4226679lbi.6
        for <linux-ext4@vger.kernel.org>; Sat, 12 Apr 2014 03:08:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 kvm-xfstests/test-appliance/files/etc/fstab | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kvm-xfstests/test-appliance/files/etc/fstab b/kvm-xfstests/test-appliance/files/etc/fstab
index e4a169f..20859fc 100644
--- a/kvm-xfstests/test-appliance/files/etc/fstab
+++ b/kvm-xfstests/test-appliance/files/etc/fstab
@@ -4,7 +4,6 @@
 proc            /proc           proc    defaults        0       0
 tmpfs		/tmp		tmpfs	mode=1777	0	0
 debugfs		/sys/kernel/debug debugfs defaults	0	0
-usbfs		/proc/bus/usb	  usbfs defaults	0	0
 /dev/rootfs	/	ext4    noatime 0 1
 /dev/vdb	/vdb	ext4	defaults,noauto	0	0
 /dev/vdc	/vdc ext4	defaults,noauto,usrquota,grpquota	0	0
-- 
1.9.0


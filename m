From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: possible ext4 race situation freezing linux
Date: Wed, 25 Feb 2009 01:22:22 +1300
Message-ID: <1235478142.11758.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:62671 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620AbZBXMWb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 07:22:31 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2159475tib.23
        for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 04:22:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kernel version: 2.26.28.7
efs2progs version: 1.41.4
arch: x86_64 (amd)

I made this test four times and the results  were the same: linux
freezes and becomes unresponsive. Only solution is to reset the box. I
do not know if the problem is with the USB devices sub-subsystem or a
possible ext4 race condition.

That's the scenario:
1. a vg group (VGSTORE) using usb mass storage devices
2. a non-lvm controlled usb mass storage device named ANDREAS
3. a cpio operation running from the ANDREAS device to a VGSTORE.LV
filesystem  (LV1)
4. a cpio operation from a VGSTORE.LV filesystem (LV2) to LV1
5. a rm operation on LV1

Nothing is recorded in /var/log/messages

I know that this is not too much information but I'm keen to repeat the
tests and turn on any debug options necessary to track the problem.

-- Berendsen



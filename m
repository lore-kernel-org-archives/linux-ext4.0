From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: "data=writeback" and TRIM don't get along
Date: Thu, 08 Apr 2010 02:50:35 +0200
Message-ID: <4BBD285B.9000603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33423 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109Ab0DHAuj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 20:50:39 -0400
Received: by bwz1 with SMTP id 1so1367915bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 07 Apr 2010 17:50:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.

TRIM command issued to SSD doesn't work with this mount options:

============================
rootfs / rootfs rw 0 0
/dev/root / ext4
rw,noatime,commit=100,barrier=0,nobh,stripe=128,data=writeback,discard 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
rc-svcdir /lib64/rc/init.d tmpfs
rw,nosuid,nodev,noexec,relatime,size=1024k,mode=755 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
udev /dev tmpfs rw,nosuid,relatime,size=10240k,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
shm /dev/shm tmpfs rw,nosuid,nodev,noexec,relatime 0 0
============================

Removing "data=writeback" option from /etc/fstab and from rootflags in
kernel boot options results in TRIM working just like it should.

So, the question is:

Is this "data=writeback" and TRIM incompatibility a bug or a feature? :)

Thank you.
Nebojsa Trpkovic

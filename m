From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Wed, 01 Jun 2016 16:02:31 +0000
Message-ID: <bug-118401-13602-gLP7XoyreQ@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbcFAQCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2016 12:02:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6E16C203C3
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 16:02:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B10AD203C1
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 16:02:31 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D118401

--- Comment #11 from Navin <navinp1912@gmail.com> ---
There are 2 things.
1) You don't need to compile a kernel with debug symbols as of now or c=
hange
any configuration. This doesn't seem something related to kernel config=
uration.

2) The images you posted in the bug report like drop.jpg

  Begin: Waiting for root file system ... Begin: Running
  /scripts/local-block ... done.
  Begin: Running /scripts/local-block ... done.
  Begin: Running /scripts/local-block ... done.
  [=E2=80=A6]
  done.
  Gave up waiting for root device.=20

and drops me into an (initramfs) shell

When you drop into (initramfs) shell, if you could get the /sbin/blkid =
output
it would be great.

It is strange that the keyboard doesn't work . I hope you have compiled=
 the
kernel after make config/menuconfig .=20
a) make
b) make modules_install
c) make install

Step (b) is missed sometimes by many. It installs the necessary drivers=
 in
/lib/modules/`uname -r` and them puts them in initramfs. So one possibl=
e reason
is missing make modules_install.

The size of initrd.x.y.img should easily tell you that.
lsinitramfs  /boot/initrd.img-4.6.0 should have the necessary modules l=
ike
usbkbd.ko.
In my case.
lsinitramfs  /boot/initrd.img-4.6.0+ | grep usbkbd
lib/modules/4.6.0+/kernel/drivers/hid/usbhid/usbkbd.ko

I guess it would be helpful to have these as well . I'm guess blkid is =
not
returning anything could also mean your block layer disk is not being d=
etected
or something wrong.=20

echo "KBU"
cat /proc/partitions
/sbin/blkid
cat /proc/cmdline
dmesg | grep -i blocks
echo "/KBU"

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

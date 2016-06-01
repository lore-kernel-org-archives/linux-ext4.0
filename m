From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Wed, 01 Jun 2016 15:26:21 +0000
Message-ID: <bug-118401-13602-WHKkuMLJHF@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33110 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161662AbcFAP0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2016 11:26:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ED592203EB
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 15:26:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 04440203C3
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 15:26:23 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D118401

--- Comment #10 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Sorry for the late reply =E2=80=93 I still haven't been able to get key=
board working in
initramfs, so not much more useful information :(


I did try running blkid from an initramfs script:


$ cat /etc/initramfs-tools/scripts/init-premount/kbu-blkid
#!/bin/sh
PREREQ=3D""
prereqs()
{
     echo "$PREREQ"
}
case $1 in
prereqs)
     prereqs
     exit 0
     ;;
esac
echo "KBU"
blkid
echo "/KBU"
$ sudo  update-initramfs -u
update-initramfs: Generating /boot/initrd.img-4.6.0-040600rc6-generic


but that just shows

   running /scripts/init-premount ... KBU
   /KBU

as if the "blkid" command had no output. Is there something more useful=
 I could
put in there?=20

Would it be useful at all to compile a kernel with debug symbols as in
https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel#Debug_Symbols or if I=
 change
some other configuration options? (I don't really know what I should ch=
ange
though, since CONFIG_EXT4_USE_FOR_EXT2 is already tested as per the con=
fig
diff).

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

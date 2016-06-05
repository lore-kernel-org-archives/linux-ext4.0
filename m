From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sun, 05 Jun 2016 11:14:47 +0000
Message-ID: <bug-118401-13602-KJWmzOpa5s@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbcFELOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jun 2016 07:14:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EB8892017D
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 11:14:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 926542017E
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 11:14:48 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D118401

--- Comment #27 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 219081
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D219081&action=3De=
dit
phone-image initramfs "grep ahci /proc/modules" 4.6 withOut ahci in etc=
 modules

As 219071, but without ahci\nlibahci in /etc/initramfs-tools/modules =E2=
=80=93 here the
first grep gives no ahci, but after a modprobe it is in /proc/modules.

("lsinitramfs /boot/initrd.img-4.6.0-040600rc6-generic |grep -i ahci"
is identical whether ahci is in /etc/initramfs-tools/modules)

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

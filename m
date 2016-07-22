From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Fri, 22 Jul 2016 14:05:07 +0000
Message-ID: <bug-61601-13602-LCCV9kMMkY@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60558 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbcGVOFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jul 2016 10:05:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ACAB720555
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jul 2016 14:05:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AD0E520546
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jul 2016 14:05:07 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D61601

J=C3=A1nos T=C3=B3th F. <janos666@mailbox.hu> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |janos666@mailbox.hu

--- Comment #18 from J=C3=A1nos T=C3=B3th F. <janos666@mailbox.hu> ---
I ran into this problem recently with kernel 4.5.5 when I tried copy-pa=
sting
all my mount options of / from fstab to the kernel cmdline as rootflags=
 after I
learned the space_cache=3DV2 mount option of Btrfs does not activate th=
e new
cache properly during the fstab-based RW remount of / when the kernel m=
ounted
it RO with default options including space_cache V1 (at least based on =
the
kernel log messages but this should probably be investigated further if=
 RO/RW
has anything to do with this, or if it's enough to do the initial mount=
 with
this cache V2 option for a single time when the old space cache v1 shou=
ld be
invalidated and a new v2 type cache must be created or these have to st=
ay for
consecutive reboots).

This might be Gentoo-specific but I also noticed localmount won't re-mo=
unt my /
with the fstab options when I have this cache rootflag in my kernel cmd=
line.
Thus, I have to manually re-mount / with noatime if I wish to have that=
 option
together with cache V2.

I also realized this bug would pretty much be the only reason for me to=
 keep a
/ entry in my fstab (to apply noatime). But more precisely, my current =
fstab
entry is useless anyway (noatime isn't applied anyway when I specify RW=
 and
rootflags in the kernel cmdline).

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

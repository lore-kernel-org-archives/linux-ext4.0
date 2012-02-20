From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Mon, 20 Feb 2012 12:12:23 GMT
Message-ID: <201202201212.q1KCCNfx010492@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:43592 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BTMMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 07:12:24 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1KCCN76010493
	for <linux-ext4@vger.kernel.org>; Mon, 20 Feb 2012 12:12:23 GMT
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D42723


Pekka Pietik=C3=A4inen <pp@ee.oulu.fi> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |pp@ee.oulu.fi




--- Comment #2 from Pekka Pietik=C3=A4inen <pp@ee.oulu.fi>  2012-02-20 =
12:12:22 ---
I've potentially seen this with 3.2.1/3.2.5 (Fedora 16)

messages-20120219:Feb 16 18:11:40 laptop kernel: [688848.718886] EXT4-f=
s error
(device dm-1): mb_free_blocks:1348: group 28, block 924740:freeing alre=
ady
freed block (bit 7236)
messages-20120219:Feb 16 18:11:40 laptop kernel: [688848.718890] EXT4-f=
s error
(device dm-1): mb_free_blocks:1348: group 28, block 924741:freeing alre=
ady
freed block (bit 7237)
=2E..
messages:Feb 19 04:46:02 laptop kernel: [106683.790999] EXT4-fs error (=
device
dm-1): ext4_mb_generate_buddy:739: group 311, 15861 clusters in bitmap,=
 9309 in
gd
messages:Feb 19 04:46:02 laptop kernel: [106683.874849] EXT4-fs error (=
device
dm-1): ext4_mb_generate_buddy:739: group 321, 30343 clusters in bitmap,=
 30295
in gd

but... the laptop in question is a quite dodgy hardware-wise (wiggle th=
e case a
bit and the Thinklight blinks etc.). Typical light laptop use with root=
/home on
LVM the way Fedora puts them by default.

So far it's getting ext4 errors every few days, reboot & fsck and it's =
fine for
a while, running 3.2.6 now.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

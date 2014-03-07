From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] New: Unreasonable performance degradation in ext4 with
 full data journaling
Date: Fri, 07 Mar 2014 11:39:40 +0000
Message-ID: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35062 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaCGLjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2014 06:39:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3C33A201ED
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 11:39:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 799E5202B8
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 11:39:40 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D71641

            Bug ID: 71641
           Summary: Unreasonable performance degradation in ext4 with f=
ull
                    data journaling
           Product: File System
           Version: 2.5
    Kernel Version: 3.4.6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: fredchang.tc@gmail.com
        Regression: No

JFS provides three modes, journal, ordered and writeback.
The first mode is denoted as =E2=80=98journal mode=E2=80=99in the follo=
wing context.
In the journal mode, data should be written twice, one for the journal =
area and
the other for the client file system. If the journal area and the clien=
t file
system are both located in the disk, it has at least 50% performance
degradation compared to ordered mode.
But what if we put the journal area in a ramdisk?
I did the following tests. It shows the ext4 with full data journaling =
has
unreasonable performance degradation even the journal area is located i=
n the
ramdisk.

Test environment-- =20
CPU: Intel(R) Xeon(R) CPU E3-1225 v3 @ 3.20GHz
RAM:8GB
=46ilesystem:Ext4
Linux version:3.4.6
RAID are composed of 6 x 1TB HD
Command: time dd if=3D/dev/zero of=3D Write_File bs=3D1M count=3D51200

Volume_type ordered_mode Journal_mode degradation
Single_disk    173MB/s    144MB/s    17%
RAID0        937MB/s    375MB/s    60%
RAID5       732MB/s    132MB/s    82%

Does anyone know where the bottleneck may be?

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] serious performance regression in "umount" on ext4 over
 LVM
Date: Tue, 4 May 2010 21:11:04 GMT
Message-ID: <201005042111.o44LB43B017406@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33836 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720Ab0EDVLG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 17:11:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o44LB5sg017408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 21:11:05 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #5 from Kees Cook <kees@outflux.net>  2010-05-04 21:11:03 ---
Hm, this was really a reduced test-case, as my initial situations where I
noticed this was umounting LVM snapshots, then later umounting aufs unions (in
an effort to get away from 3x slow-down of snapshot IO).

Doing this is just as slow as loopback for me:

VG=systemvg
lvcreate -n testlv -L1G $VG
mkfs.ext4 -F /dev/$VG/testlv
mkdir -p /mnt/test
mount -o loop /dev/$VG/testlv /mnt/test
seq 65536 | (cd /mnt/test; xargs touch)
time umount /mnt/test


Should 68db1961bbf4e16c220ccec4a780e966bc1fece3 be expected to fix it too?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

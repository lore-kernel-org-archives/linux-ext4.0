From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] kernel BUG at fs/ext4/inode.c:1852!
Date: Wed, 10 Feb 2010 03:26:36 GMT
Message-ID: <201002100326.o1A3QaFs015242@demeter.kernel.org>
References: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36773 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJD0i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 22:26:38 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1A3QbLd015250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2010 03:26:37 GMT
In-Reply-To: <bug-15231-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231





--- Comment #10 from Franco Broi <franco@fugro-fsi.com.au>  2010-02-10 03:26:04 ---

I've applied the patch to 2.6.32.7 - strangely the patch program segfaulted but
applied the patch correctly.

[root@echo2 linux-2.6.32.7]# patch -p1 < patch
patching file fs/ext4/inode.c
Segmentation fault

Feb 10 02:11:57 echo2 kernel: patch[18919]: segfault at 0 ip 0000003a0c07ee70
sp 00007fff85523278 error 4 in libc-2.10.1.so[3a0c000000+164000]

Also, before booting the new kernel I did a df, /data6 had a negative used
block count. I guess this could be related to the current problem if the ref
counting has gone a bit skew-whiff although this is with the system running
2.6.32.2.

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vgdata--3-data5
                     13458176552   2072548 13456104004   1% /data5
/dev/mapper/vgdata--3-data6
                     13458176552  -3576068 13461752620   0% /data6
/dev/mapper/vgdata--4-data7
                     13458176552  40839788 13417336764   1% /data7
/dev/mapper/vgdata--4-data8
                     13458176552   1933764 13456242788   1% /data8

I unmounted and ran fsck, it said it was clean and when I remounted it appeared
to fix itself.

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vgdata--3-data5
                     13458176552   2072548 13456104004   1% /data5
/dev/mapper/vgdata--3-data6
                     13458176552   1920236 13456256316   1% /data6
/dev/mapper/vgdata--4-data7
                     13458176552  40974956 13417201596   1% /data7
/dev/mapper/vgdata--4-data8
                     13458176552   1933764 13456242788   1% /data8

The patched kernel is running on 3 servers - watch this space..

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

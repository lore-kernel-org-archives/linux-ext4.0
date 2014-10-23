From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Thu, 23 Oct 2014 16:36:01 +0000
Message-ID: <bug-86471-13602-ApLc0iLpJM@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39954 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaJWQgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2014 12:36:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 168B320256
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 16:36:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 497D02024F
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 16:36:02 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D86471

--- Comment #6 from Markus K=C3=B6nigshaus <m.koenigshaus@wut.de> ---

I think I have found the error. The kernel calls apparently for the sam=
e page
dec_zone_page_state on (page, NR_FILE_DIRTY) twice, which means that th=
e dirty
page counter underflows (is getting negative):=20

cat /proc/meminfo=20
MemTotal:         511492 kB
MemFree:          406972 kB
MemAvailable:     450536 kB
Buffers:            1840 kB
Cached:            52140 kB
SwapCached:            0 kB
Active:            54348 kB
Inactive:          34456 kB
Active(anon):      34904 kB
Inactive(anon):     5440 kB
Active(file):      19444 kB
Inactive(file):    29016 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:             0 kB
HighFree:              0 kB
LowTotal:         511492 kB
LowFree:          406972 kB
SwapTotal:             0 kB
SwapFree:              0 kB
>> Dirty:          4294967148 kB
Writeback:             0 kB
AnonPages:         34844 kB
Mapped:            13992 kB
Shmem:              5520 kB
Slab:               9196 kB
SReclaimable:       4976 kB
SUnreclaim:         4220 kB
KernelStack:         696 kB
PageTables:         1024 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      255744 kB
Committed_AS:     365452 kB
VmallocTotal:     499712 kB
VmallocUsed:        3512 kB
VmallocChunk:     495964 kB

The writeback - mechanism thinks that too much pages are dirty and disa=
bles the
writeback - cache.

Who can I send this bug?
Markus

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

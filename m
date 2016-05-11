From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118041] New: My tricky script involving zram and device mapper
 hangs on "mount"
Date: Wed, 11 May 2016 21:22:20 +0000
Message-ID: <bug-118041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbcEKVWY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2016 17:22:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6FF73201CE
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2016 21:22:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D989F201BC
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2016 21:22:20 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118041

            Bug ID: 118041
           Summary: My tricky script involving zram and device mapper
                    hangs on "mount"
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.8-grsec,4.1.9
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: vi0oss@gmail.com
        Regression: No

As far as I remember, I have implemented and used the script on 3.8.3 (or
3.7.5?) successfully. But after upgrading to other kernel version it broke: now
"mount" hangs (in uninterruptible sleep), consuming 100% CPU and eating all
memory.

The script:

---

modprobe zram num_devices=2
sleep 1
echo 1500M > /sys/block/zram0/disksize
echo 100M > /sys/block/zram1/disksize

MS=$(blockdev --getsize /dev/zram0)
WS=$(blockdev --getsize /dev/zram1)
DS=$(blockdev --getsize /dev/mapper/cryptie4-ff)
MN=$(printf '%d:%d' `stat -Lc '0x%t 0x%T' /dev/zram0`)
WN=$(printf '%d:%d' `stat -Lc '0x%t 0x%T' /dev/zram1`)
DN=$(printf '%d:%d' `stat -Lc '0x%t 0x%T'  /dev/mapper/cryptie4-ff`)

pv /dev/mapper/cryptie4-ff | hashed_update /dev/stdin NULL /dev/zram0
/tmp/ff.md5 65536
dmsetup create ff --table "0 $MS snapshot-origin $MN"

# /dev/mapper/ff /mnt/ff ext4 noatime,noauto 0 0
mount /mnt/ff

# after this command ff_snap should begin working
dmsetup create ff_disk --table "0 $DS snapshot-origin $DN"

---

So far I have just abandoned the script and hasn't experimented more. Shall I 
try to isolate and maybe bisect the problem?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

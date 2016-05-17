From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118041] My tricky script involving zram and device mapper hangs
 on "mount"
Date: Tue, 17 May 2016 18:59:47 +0000
Message-ID: <bug-118041-13602-dUd4qd9pt9@https.bugzilla.kernel.org/>
References: <bug-118041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58761 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbcEQS7v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 14:59:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9AB6920259
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 18:59:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 062872021B
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 18:59:48 +0000 (UTC)
In-Reply-To: <bug-118041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118041

--- Comment #4 from Navin <navinp1912@gmail.com> ---
Not related to ext4 . I can reproduce this with below script and i think 
dm-devel@redhat.com should be contacted.


I tested on Linux junk-foo 4.2.0-35-generic from Ubuntu (15.10 ) x64.
Linux junk-foo 4.2.0-35-generic #40-Ubuntu SMP Tue Mar 15 22:15:45 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux



Here is a script that crashes the kernel for me with out of memory. Looks to be
a dm problem because it occurs with dd,mkfs.xfs,mkfs.vat ,without zram ie with
losetup.

Here is the script.Should be run as root for losetup and dmsetup permissions.


#!/bin/bash

fallocate -l 50M 50M_file_unused
fallocate -l 60M 60M_file_unused
losetup  /dev/loop4 50M_file_unused
losetup  /dev/loop5 60M_file_unused

MS=$(blockdev --getsize /dev/loop4)
WS=$(blockdev --getsize /dev/loop5)
echo "0 $MS linear /dev/loop4 0 \n $MS $WS linear /dev/loop5 0" | dmsetup
create cryptie4-ff
DS=$(blockdev --getsize /dev/mapper/cryptie4-ff)
MN=$(printf '%d:%d' `stat -Lc '0x%t 0x%T' /dev/loop4`)
WN=$(printf '%d:%d' `stat -Lc '0x%t 0x%T' /dev/loop5`)
DN=$(printf '%d:%d' `stat -Lc '0x%t 0x%T'  /dev/mapper/cryptie4-ff`)

#pv /dev/mapper/cryptie4-ff | hashed_update /dev/stdin NULL /dev/zram0
/tmp/ff.md5 65536
pv /dev/mapper/cryptie4-ff 
dmsetup create ff --table "0 $MS snapshot-origin $MN"


After this  doing this 
dd if=/dev/zero of=/dev/mapper/ff
or
mkfs.xfs /mkfs.ext4 on /dev/mapper/ff will fail.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48178 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbeLDBlI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 20:41:08 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2288B2ADCC
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 01:41:07 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 01:41:05 +0000
Message-ID: <bug-201685-13602-kHnHQHX4Yu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #213 from Guenter Roeck (linux@roeck-us.net) ---
#210: I rather refrain from it. Messing up one of my systems is bad enough.

Note that the problem is still spurious; it may happen a mionute into the test 
(or even during boot), or after an hour.

I am now at a point where I still see the problem with almost all patches since
4.18.20 reverted; the only patch not reverted is the STAT_WRITE patch, because
it is difficult to revert due to context changes. I'll revert that manually for
the next round of tests. Here is the most recent log:

[ 2228.782567] EXT4-fs error (device sda1): ext4_iget:4795: inode #6317073:
comm borg: bad extra_isize 30840 (inode size 256)
[ 2228.805645] Aborting journal on device sda1-8.
[ 2228.814576] EXT4-fs (sda1): Remounting filesystem read-only
[ 2228.815816] EXT4-fs error (device sda1): ext4_iget:4795: inode #6317074:
comm borg: bad extra_isize 30840 (inode size 256)
[ 2228.817360] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[ 2228.817367] EXT4-fs (sda1): ext4_writepages: jbd2_start: 4086 pages, ino
5310565; err -30
[ 2228.819221] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[ 2228.819227] EXT4-fs (sda1): ext4_writepages: jbd2_start: 9223372036854775745
pages, ino 5328193; err -30

... and so on.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

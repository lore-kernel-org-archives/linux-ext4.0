From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Sat, 11 Nov 2017 11:04:42 +0000
Message-ID: <bug-151491-13602-qMCzUTSxCe@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39002 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751640AbdKKLEn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 11 Nov 2017 06:04:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 954CC2994C
        for <linux-ext4@vger.kernel.org>; Sat, 11 Nov 2017 11:04:43 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

Fischreiher (mfe555@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mfe555@web.de

--- Comment #4 from Fischreiher (mfe555@web.de) ---
I have a similar or same problem on a Linux based Enigma2 set-top box

- ext4
- kernel 4.8.3
- bigalloc enabled
- cluster size of 262144

In normal use of the set-top box, the free space lossage is 10s of Gigabytes
per day. The problem can be easily reproduced:

When creating a fresh file, there is a significant difference in file size (ls
-la) and disk usage (du). When making two copies of the file ..

gbquad:/hdd/test# cp file file.copy1
gbquad:/hdd/test# cp file file.copy2
gbquad:/hdd/test# ls -la
-rw-------    1 root     root     581821460 Nov  1 18:52 file
-rw-------    1 root     root     581821460 Nov  1 18:56 file.copy1
-rw-------    1 root     root     581821460 Nov  1 18:57 file.copy2
gbquad:/hdd/test# du *
607232  file
658176  file.copy1
644864  file.copy2

... all three files show an overhead in the ~10% range, and the overhead is
different for these files although their md5sums are equal.

When deleting a file (rm), the overhead remains occupied on the disk. For
example, after deleting "file", "df" reports approx. 581821460 more bytes free,
not 607232 kbytes more free space. The overhead (607232 kB - 581821460 B =
approx. 39 MB) remains blocked.

When unmounting and mounting again, the blocked space becomes free again, and
in addition the overhead of those files that were not deleted also disappears,
so that after a re-mount the 'file size' and 'disk usage' match for all files
(except for rounding up to some block size).

I found that
    echo 3 > /proc/sys/vm/drop_caches
seems to detach the blocked disk space from the files (so that 'du file' no
longer includes the offset), but it does not free the space, 'df' still shows
all file overheads as used disk space.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

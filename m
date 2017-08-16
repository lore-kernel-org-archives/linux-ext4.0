From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196677] fsck.ext4: unable to set superblock flags, even after
 mounting ok
Date: Wed, 16 Aug 2017 13:49:48 +0000
Message-ID: <bug-196677-13602-gYEMx4qnK3@https.bugzilla.kernel.org/>
References: <bug-196677-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53558 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751642AbdHPNtt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Aug 2017 09:49:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5D8B428A0B
        for <linux-ext4@vger.kernel.org>; Wed, 16 Aug 2017 13:49:49 +0000 (UTC)
In-Reply-To: <bug-196677-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196677

--- Comment #1 from Theodore Tso (tytso@mit.edu) ---
On Wed, Aug 16, 2017 at 08:14:26AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> 
> Just had a Raspberry Pi crash, and upon reboot fsck.ext4 was unable to repair
> the filesystem.  Moving the SD card to a PC and running fsck there showed the
> same behaviour.  I am not sure what exactly you need to know so please advise
> if you need anything else.

This is a e2fsprogs bugs, not a kernel bug, but it's fine to discuss
it here.

Can you send me the output of "dumpe2fs /dev/sdb2", "debugfs -R 'stat
<8>' /dev/sdb2", and "debugfs -R logdump /dev/sdb2"?

Also could you run:

        debugfs -R 'dump_inode <8> /tmp/journal.dat' /dev/sdb2

and then send me a copy of /tmp/journal.dat?

I'm guessing the journal must be corrupted in some interesting way,
since what should have happened if it was just a case of the journal
data being present but the superblock flags not being set sould have
been:

e2fsck 1.43.5 (04-Aug-2017)
/tmp/foo.img: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (26854, counted=24490).
Fix? yes

Free inodes count wrong (8181, counted=7281).
Fix? yes


/tmp/foo.img: ***** FILE SYSTEM WAS MODIFIED *****
/tmp/foo.img: 911/8192 files (0.0% non-contiguous), 8278/32768 blocks

Cheers,

                                                - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

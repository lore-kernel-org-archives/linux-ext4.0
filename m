From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197315] New: ext4 filesystem does not use its badblock list
 fully
Date: Thu, 19 Oct 2017 03:16:10 +0000
Message-ID: <bug-197315-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53470 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbdJSDQM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Oct 2017 23:16:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9E31E28C27
        for <linux-ext4@vger.kernel.org>; Thu, 19 Oct 2017 03:16:11 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197315

               URL: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1
                    723415
            Bug ID: 197315
           Summary: ext4 filesystem does not use its badblock list fully
           Product: File System
           Version: 2.5
    Kernel Version: 4.14.0-041400rc4.201710130854
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: mihailov-d-v@mail.ru
        Regression: No

Always, when I have /dev/sdb2 mounted, I get an errors in the system log, such
as in the file dmesg.txt (attached)(there are i/o errors and something).

Thus I ran fsck:
{
root@user:~# fsck.ext4 -fck /dev/sdb2
e2fsck 1.43.5 (04-Aug-2017)
Checking for bad blocks (read-only test): 0.24% done, 0:25done
/dev/sdb2: Updating bad block inode.
Pass 1: Checking inodes, blocks, and sizes
Programming error? block #230376 claimed for no reason in process_bad_block.
Programming error? block #230385 claimed for no reason in process_bad_block.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/sdb2: ***** FILE SYSTEM WAS MODIFIED *****
}

But the errors did not disappear and I ran "badblocks -so ./bads-sdb2.txt -b
4096 /dev/sdb2"
Then I tried "fsck.ext4 -l ./bads-sdb2.txt /dev/sdb2" and it showed, among
other typical things, this:
{
Programming error? block #230376 claimed for no reason in process_bad_block.
Programming error? block #230385 claimed for no reason in process_bad_block.
}

Then I ran "dump2fs -b /dev/sdb2" and found that every block from bads-sdb2.txt
is already included in there, but the errors keep appear.

And while I was searching for a solution, I found this:
https://sourceforge.net/p/e2fsprogs/bugs/187/

I think this situation can be found on Ubuntu 16.04 too.
Thank you.

1) Ubuntu Artful Aardvark (development branch) 17.10
2) 4.13.0.15.16
...
I've tried to calculate somehow what block is on sector 50868652 and I got
6291509. Badblocks program successfully recognize this block as bad. And
"dumpe2fs -b" shows it. But this block is touched again and again. And I think
that means that messages "Programming error? block #?????? claimed for no
reason in process_bad_block" are irrelevant to this issue.
...
I used 4.14.0-041400rc4.201710130854 kernel for testing and the bug exists on
it too.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

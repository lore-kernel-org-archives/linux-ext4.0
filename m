From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114821] Frequent and recurring ext4 "bad header invalid magic"
 errors on a healthy drive
Date: Sun, 20 Mar 2016 20:50:12 +0000
Message-ID: <bug-114821-13602-JRhgln1z84@https.bugzilla.kernel.org/>
References: <bug-114821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbcCTUuQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2016 16:50:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ACE0720270
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 20:50:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F185420260
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 20:50:12 +0000 (UTC)
In-Reply-To: <bug-114821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114821

--- Comment #8 from Lukas <dse.ssd@gmail.com> ---
The command

$ debugfs -c -R 'stat <1523>' /dev/sdb1

produces the following output:

Inode: 1523   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 0    Version: 0x00000000
User:  1001   Group:   100   Size: 0
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x56b66f93 -- Sat Feb  6 17:11:31 2016
atime: 0x56b66f93 -- Sat Feb  6 17:11:31 2016
mtime: 0x4e4d75ac -- Thu Aug 18 16:27:24 2011
Size of extra inode fields: 0
EXTENTS:
(END)

Executing 'stat <1523>' command does not cause a head load cycle.

As I understand, there are no blocks assigned to the inode. The file is an
empty text file, so maybe it makes sense? I've created a new empty text file
and it also has no blocks assigned to its inode, but it can be read and stat'ed
with no problems.

I've checked a few of the other inode numbers that appear in dmesg less
frequently and - all of them point to empty text files! I would guess the
reason why inode #1523 appears so often in the logs is because the file is in
the root directory and gets listed each time the root is traversed.

So, is it possible that something went wrong with just the zero-length files
while I was copying my data to it? I did use ext2fsd on Windows 8.1 to copy
some of the files... I just tested it again, and I can copy zero-length files
to the drive using Windows and read them when mounted on linux with no
problems.

And since the zero-length files have no useful information (other than their
file names, which I can still read) and have no blocks assigned to them can I
now just remove them using debugfs?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

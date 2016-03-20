From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114821] Frequent and recurring ext4 "bad header invalid magic"
 errors on a healthy drive
Date: Sun, 20 Mar 2016 06:46:35 +0000
Message-ID: <bug-114821-13602-KKDojklqgP@https.bugzilla.kernel.org/>
References: <bug-114821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51272 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbcCTGqk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2016 02:46:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7ABDC2034B
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 06:46:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 089D5202F2
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 06:46:36 +0000 (UTC)
In-Reply-To: <bug-114821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114821

--- Comment #6 from Lukas <dse.ssd@gmail.com> ---
I agree, the head cycling does seem unlikely to be caused by software. But I'm
confused how can the drive be 'failing' simple reads so often and yet pass
every fitness, including a vendor diagnostic test of every sector...

I cannot create a drive image... It is 4TB in size and I don't have that much
contiguous free storage at my disposal. What I could do is wipe the drive and
re-create the ext4 partition. I have most of the contents backed up. It sounds
like a radical way of testing, but let me know if that's my only option.

In the mean time I've done some more testing. Maybe it will prove useful.

Firstly, I've reproduced the error on Raspbian 8 with 4.1.18-v7+ kernel running
on a different Raspberry Pi device. (Sorry, the kernel is again non-vanilla).
Upon accessing a particular file on the drive, I can hear the head load cycle
and a dmesg ext4 error is logged.

Secondly, I've noticed that most of the ext4 errors are due to smbd and for the
same inode #1523. That inode seems to be accessed quite often whenever I do
anything with the drive.

I ran

$ debugfs -R "ncheck 1523" /dev/sdb1

and determined that the inode holds a single text file in the root directory of
the drive - 'file.txt'. I cannot list or delete this file:

% ls -li

ls: cannot access file.txt: Input/output error
? -?????????  ? ?     ?               ?            ? file.txt

$ rm file.txt
rm: cannot remove `file.txt': Input/output error

If I execute

$ debugfs -R 'cat <1523>' /dev/sdb1

it returns nothing and I believe the file should be empty. The command takes a
few minutes to execute, which I don't think is normal too.

I know this sounds even more like hardware problems, but, again, there's
nothing in the SMART attributes, self-tests or vendor diagnostic tests to
support that.

Should I attempt to delete this file using debugfs? Or should I re-create the
partition from scratch? Or should I just get another drive, close this 'bug'
and stop troubleshooting?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

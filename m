From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 14 Oct 2009 09:31:07 GMT
Message-ID: <200910140931.n9E9V74N017655@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49551 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbZJNJbo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 05:31:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9E9V7hH017656
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 09:31:07 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #46 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-14 09:31:06 ---
Oh... after all your comments the things making more sans. Now i see the
corruption happened probably before i found it. I'll assume this was after last
fsck, so like two or three week ago.

Thirst of all i need to say, my primer testing targets are intel graphic, acpi
and ath9k (wifi).  Other bugs will be mostly skipped.

Like i said this bug was mixed with other ubuntu karmik bug which made it more
complicated to find real when was this bug introduced.

The karmik bug was introduced in alpha ~2 - it will fail to boot on fsck.
Normally i did "fsck /root"  or "mount -o remount,ro && fsck".

With kernel 2.6.32-rc1 i needed to bisect some intel graphic issue so i tested
most version between 2.6.32-rc1 and 2.6.31.. some where shortly after
2.6.32-rc1 i get oops on of ext4, so i skipped testing  till short after
2.6.32-rc2 (this is proboly the time where real corruption was). With
~2.6.32-rc3 e get oops on ~scsi  when i tried to fdisk usbstick. While i needed
to make this usbstick work, i rebooted (not reseted) and started with "stable"
2.6.31-ubuntu-13. This time i get same problem - PC wont boot, need to fsck
(looks like karmik fsck issue but it isn't ... with message "bla bla
/forcefsck" this was new for me), it didn't worked. remount,ro didt't worked
too, reason /etc/mtab corrupted. cat /etc/mtab show only random trash in it. I
started 2.6.31-ubuntu-13 to initrd  and mount root manually in ro, run fsck -f
-y /root  returned a lot of messages like file1 and file2 use same sector and
removing file3 bla bla... lostandfound... After reboot the system worked again,
to find what files was lost i run debsums. I showed some packages which was
installed one week before was broken. After i reinstalled broken packages seems
like system work stable.

Now, after i "systematically" trying to analise this, noticed that all my
broken laptops used max 2.6.32-rc1 before die. Probably my major testing pc get
corrupted at 2.6.31-rc1 time too. Now i use e2croncheck script in cron.deily
will see if i can confirm it.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

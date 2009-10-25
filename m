From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 25 Oct 2009 08:58:13 GMT
Message-ID: <200910250858.n9P8wDYt015310@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52589 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZJYI6J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Oct 2009 04:58:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9P8wDnk015311
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2009 08:58:14 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #112 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-25 08:58:06 ---
I was able to reproduce fs corruption by passing barrier=0, _but_ i can't be
sure burriers are disabled for my dm.

fstab say, disabled:
~$ grep barr /etc/fstab
-----------------------------------------------------------------
/dev/mapper/zwerg_buntu-root_one /               ext4   
errors=remount-ro,barrier=0 0       1
/dev/sda8 /home           ext4    defaults,barrier=0        0       2

-------------------------------------------------------------------

proc say, disabled:
$ grep barr /proc/mounts 
----------------------------------------------------------
/dev/mapper/zwerg_buntu-root_one / ext4
rw,relatime,errors=remount-ro,barrier=0,data=ordered 0 0
/dev/sda8 /home ext4 rw,relatime,barrier=0,data=ordered 0 0
-------------------------------------------------------------

dmesg say, _enabled_:
kernel 2.6.31-14-generic
~$ dmesg | grep barr
[    7.063589] EXT4-fs (dm-0): barriers enabled
[    9.365835] EXT4-fs (sda8): barriers disabled

kernel 2.6.32-rc5-00011-g2fdc246
[    9.365835] EXT4-fs (sda8): barriers disabled

i know 2.6.32-rc do not printk if barriers are enabled, so i assume they are
still enabled.
I think this mess with dmesg vs proc should be fixed too.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

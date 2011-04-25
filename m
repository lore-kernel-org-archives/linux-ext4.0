From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Mon, 25 Apr 2011 20:28:16 GMT
Message-ID: <201104252028.p3PKSGxq020402@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46192 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1DYU2R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 16:28:17 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3PKSGbV020403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 20:28:16 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #72 from Theodore Tso <tytso@mit.edu>  2011-04-25 20:28:11 ---
The thing is, the given the stack trace and the fact that it's caused by a null
pointer in next_interrupt, makes me highly dubious this has anything to do with
ext4.   You could put in a printk in fs/ext4/super.c:ext4_put_super() and make
sure it's not trigger, since that's the only place where we mess with timers at
all --- but del_timer() properly disable interrupts before mucking with the
pointer, so I'm not convinced it was caused by ext4.  (Also, the ext4 timer is
only present if the file system has reported any errors, and it only fires once
every 24 hours, so it's highly unlikely it would be on a timer bucket that
would the next timer interrupt would trip against right afterwards.  So I very
much doubt it's caused by the ext4 error reporting timer.)

And if you're seeing this on ext3, which doesn't use a timer at all, then it's
definitely not the fault of the file system layer, but probably something in
the usb block device driver...

In all of the stack traces, there's an scsi disk attach going on right before
the crash:

[ 1255.355192] scsi4 : usb-storage 1-1:1.0
[ 1256.387085] scsi 4:0:0:0: Direct-Access     JetFlash TS2GJF110        0.00
PQ: 0 ANSI: 2
[ 1256.409758] sd 4:0:0:0: Attached scsi generic sg2 type 0
[ 1256.425575] sd 4:0:0:0: [sdb] 4063232 512-byte logical blocks: (2.08 GB/1.93
GiB)
[ 1256.434955] sd 4:0:0:0: [sdb] Write Protect is off
[ 1256.435172] sd 4:0:0:0: [sdb] Mode Sense: 00 00 00 00
[ 1256.447520] sd 4:0:0:0: [sdb] Asking for cache data failed
[ 1256.448031] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1256.484174] sd 4:0:0:0: [sdb] Asking for cache data failed
[ 1256.484174] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1256.493409]  sdb: sdb1
[ 1256.540082] sd 4:0:0:0: [sdb] Asking for cache data failed
[ 1256.540083] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1256.540083] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[ 1257.566980] usb-storage 1-1:1.0: Quirks match for vid 0457 pid 0150: 80
[ 1257.566983] scsi5 : usb-storage 1-1:1.0
[ 1258.400641] BUG: unable to handle kernel NULL pointer dereference at  
(null)
[ 1258.400818] IP: [<c105ccf8>] __next_timer_interrupt+0xa8/0x160

Was sdb the device that had been just yanked out?  Or was this some other SCSI
device?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

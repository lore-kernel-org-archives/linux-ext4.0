From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56821] an ext4 commit ee0906f causes weird disk hangs
Date: Fri, 19 Apr 2013 17:32:55 +0000 (UTC)
Message-ID: <20130419173255.1C70611FADB@bugzilla.kernel.org>
References: <bug-56821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38097 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab3DSRc6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 13:32:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 33FB4206B6
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 17:32:57 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 02973206A0
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 17:32:56 +0000 (UTC)
In-Reply-To: <bug-56821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56821


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2013-04-19 17:32:54 ---
This should allow your system not to crash.

echo 0 > /sys/fs/ext4/<dev>/extent_max_zeroout_kb

The failure which you are showing seems to be one where your SCSI controller
and/or your SCSI disks are freaking out when ext4 tries to zero out a block
range by calling sb_issue_zeroout().   The block layer will translate this into
a TRIM command or a SCSI WRITE SAME command for those devices which support
this, so that blocks can be efficiently zeroed out.  

It looks like the block device layer translated this to a standard SCSI
WRITE(10) command which is getting issued to both disks at the same time (I
assume you are using a software raid via an md device?).   I suspect this is a
case where ext4 is enabling a new block device optimization interface, and this
is interacting badly with your hardware or your block device driver.

So we need to figure out what is actually causing the feature, so we can some
how automatically blacklist whatever is failing.   In the mean time, you can
force off the optimization at the ext4 layer by setting extent_max_zeroout_kb
to zero.  Hopefully we can figure out a better way of disabling the
optimization at a lower level (so you can get the benefits of minimizing extent
tree fragmentation without causing your raid array to hang), and some way of
disabling some level of optimization or hardware breakage workaround
automatically.


mptscsih: ioc0: attempting task abort! (sc=ffff8803ec450f00)
sd 6:0:1:0: [sdb] CDB:
Write(10): 2a 00 12 60 a0 a8 00 00 40 00
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed},
SubCode(0x0000) cb_idx mptscsih_io_done
mptscsih: ioc0: task abort: SUCCESS (rv=2002) (sc=ffff8803ec450f00)
mptscsih: ioc0: attempting task abort! (sc=ffff8803ec450900)
sd 6:0:0:0: [sda] CDB:
Write(10): 2a 00 12 60 a0 a8 00 00 40 00
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed},
SubCode(0x0000) cb_idx mptscsih_io_done
mptscsih: ioc0: task abort: SUCCESS (rv=2002) (sc=ffff8803ec450900)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

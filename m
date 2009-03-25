From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12896] ext3 FS problem or harddisk problem?
Date: Wed, 25 Mar 2009 14:51:21 GMT
Message-ID: <200903251451.n2PEpLeN032051@demeter.kernel.org>
References: <bug-12896-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58181 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbZCYP1Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Mar 2009 11:27:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2PEpLcA032052
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2009 14:51:21 GMT
In-Reply-To: <bug-12896-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12896


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #3 from Jan Kara <jack@suse.cz>  2009-03-25 14:51:20 ---
This seems like a problem with your USB drive (or motherboard having too weak
USB controller to power the drive or something like that). Because the drive
disconnects after being mounted and later also gives IO errors. See:

Mar 20 16:45:57 usb 1-6: configuration #1 chosen from 1 choice
Mar 20 16:45:57 localhost kernel: scsi9 : SCSI emulation for USB Mass Storage
devices
Mar 20 16:46:02 localhost kernel: scsi 9:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] 312581808 512-byte hardware
sectors: (160 GB/149 GiB)
...
Mar 20 16:46:04 localhost kernel: EXT3 FS on sde1, internal journal
...
Mar 20 16:46:47 localhost kernel: usb 1-6: USB disconnect, address 4
...
Mar 20 16:47:00 localhost kernel: EXT3-fs error (device sde1):
ext3_get_inode_loc: unable to read inode block - inode=2, block=1027
Mar 20 16:47:00 localhost kernel: EXT3-fs error (device sde1) in
ext3_reserve_inode_write: IO failure
...
And there are more IO errors because the drive then reconnects, gets sdf
assigned but disconnects again. Anyway, this is either USB stack or HW problem.
If you see it only with some kernel and not with other, it might be worth
pursuing further. Otherwise I'd try to play with HW...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

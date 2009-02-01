From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12594] filesystem corruption while running bonnie
Date: Sun,  1 Feb 2009 12:50:01 -0800 (PST)
Message-ID: <20090201205001.5DF3B108042@picon.linux-foundation.org>
References: <bug-12594-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555AbZBAUuD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 15:50:03 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n11Ko1C6021219
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 12:50:02 -0800
In-Reply-To: <bug-12594-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12594





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2009-02-01 12:50 -------
Reply-To: akpm@linux-foundation.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sun,  1 Feb 2009 06:59:52 -0800 (PST) bugme-daemon@bugzilla.kernel.org
wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12594
> 
>            Summary: filesystem corruption while running bonnie
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.28.1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: fs_ext3@kernel-bugs.osdl.org
>         ReportedBy: folkert@vanheusden.com
> 
> 
> mkdir /mnt/tmp /tmp/tmp ; mount -t tmpfs /dev/null /mnt
> chown folkert /mnt/tmp /tmp/tmp
> 
> and then in parallel:
> while [ 1 ] ; do bonnie++ -d /tmp/tmp -s 128 -r 64 -x 1 -u folkert ; done
> while [ 1 ] ; do bonnie++ -d /mnt/tmp -s 128 -r 64 -x 1 -u folkert ; done
> 
> then after say 15 minutes i run the reboot command (normal via init) during the
> fsck (I always do a touch /forcefsck) I get:
> fsck 1.41.3 (12-Oct-2008)
> /dev/mapper/VGODR-tmp contains a file system with errors, check forced.
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (1) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (1) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (2) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (2) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (3) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (3) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (4) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (4) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (5) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (5) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (6) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (6) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (7) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (7) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (8) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (8) has bad
> max hash
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (8) not
> referenced
> ...
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (523) not
> referenced
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (524) has
> invalid depth (2)
> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (524) not
> referenced
> /dev/mapper/VGODR-tmp: Invalid HTREE directory inode 69634 (/tmp/Bonnie.3813). 
> 
> I've got a gzip'ed dump of /tmp available on request.

htree went bad.  It's strange that exercising tmpfs would do this.

I always get worried when I see device-mapper in the picture.  It has a
history..  Perhaps you can describe your device-mapper setup?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: [Bugme-new] [Bug 12594] New: filesystem corruption while
	running bonnie
Date: Wed, 4 Feb 2009 13:10:42 +0100
Message-ID: <20090204121042.GK21127@vanheusden.com>
References: <bug-12594-10286@http.bugzilla.kernel.org/> <20090201124953.fbae0e76.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2731 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZBDMLZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2009 07:11:25 -0500
Content-Disposition: inline
In-Reply-To: <20090201124953.fbae0e76.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > http://bugzilla.kernel.org/show_bug.cgi?id=12594
> > 
> >            Summary: filesystem corruption while running bonnie
> >            Product: File System
> >            Version: 2.5
> >      KernelVersion: 2.6.28.1
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: ext3
> >         AssignedTo: fs_ext3@kernel-bugs.osdl.org
> >         ReportedBy: folkert@vanheusden.com
> > 
> > 
> > mkdir /mnt/tmp /tmp/tmp ; mount -t tmpfs /dev/null /mnt
> > chown folkert /mnt/tmp /tmp/tmp
> > 
> > and then in parallel:
> > while [ 1 ] ; do bonnie++ -d /tmp/tmp -s 128 -r 64 -x 1 -u folkert ; done
> > while [ 1 ] ; do bonnie++ -d /mnt/tmp -s 128 -r 64 -x 1 -u folkert ; done
> > 
> > then after say 15 minutes i run the reboot command (normal via init) during the
> > fsck (I always do a touch /forcefsck) I get:
> > fsck 1.41.3 (12-Oct-2008)
> > /dev/mapper/VGODR-tmp contains a file system with errors, check forced.
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (1) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (1) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (2) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (2) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (3) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (3) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (4) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (4) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (5) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (5) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (6) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (6) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (7) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (7) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (8) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (8) has bad
> > max hash
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (8) not
> > referenced
> > ...
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (523) not
> > referenced
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (524) has
> > invalid depth (2)
> > /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (524) not
> > referenced
> > /dev/mapper/VGODR-tmp: Invalid HTREE directory inode 69634 (/tmp/Bonnie.3813). 
> > 
> > I've got a gzip'ed dump of /tmp available on request.
> 
> htree went bad.  It's strange that exercising tmpfs would do this.
> 
> I always get worried when I see device-mapper in the picture.  It has a
> history..  Perhaps you can describe your device-mapper setup?

(Sorry for the delayed response, had the flu)

The system is an LVM setup with /home, /, /tmp, /var, /usr and swap in
seperate LVM slices.


Folkert van Heusden

-- 
                     www.ishetweekend.nl
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

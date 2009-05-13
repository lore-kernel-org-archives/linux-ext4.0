From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] New: ext4 without journal reproductible file corruption
Date: Wed, 13 May 2009 09:22:43 GMT
Message-ID: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40821 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbZEMJWm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 05:22:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4D9Mhsf020879
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 09:22:43 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13292

           Summary: ext4 without journal reproductible file corruption
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.29.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: thibm@free.fr
        Regression: No


Created an attachment (id=21323)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=21323)
The harddrive image to mount and chroot

Hi,

I found file(s) corruption using ext4 without journal, on two different
hardware (a dell vostro 1700, 64 bits archlinux + 64 bits jaunty, perso kernel
2.6.29.3 and an acer aspire one a110, ssd, 32 bits archlinux, same kernel
version).


The problem can be reproduced using the hdd image in attachment. This file is
an ext4 without journal image of a minimal archlinux 64 system.

Step to reproduce :

A-

1/ extract the archive on a 64 bits system running 2.6.29.3
2/ mount the .img as ext4, loopback
3/ chroot in the mounted directory
4/ execute "locale-gen"
5/ execute "locale". The result is ok
6/ have a look at /usr/lib/locale/locale-archive file (with vi or other editor)
7/ exit chroot
8/ umount hd image

B-

1/ mount again the hd image
2/ chroot again
3/ execute "locale". There are 3 errors at the beginning, the output is not the
same as previously
4/ look at /usr/lib/locale/locale-archive, the content is not the same !


Reproduce these steps with a journal (tune2fs -O has_journal, fsck -f) and
you'll see the file locale-archive and the output of locale command are
consistants between mount/umount.

The file locale-archive is not the only affected. On other system, that was
nvidia kernel module which was corrupted between installation and reboot.


Regards,

Thibault

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

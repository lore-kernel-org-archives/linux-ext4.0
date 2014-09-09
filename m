From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] New: mount doesn't clear usrjquota / grpjqouta options
Date: Tue, 09 Sep 2014 14:28:52 +0000
Message-ID: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57061 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812AbaIIO3A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Sep 2014 10:29:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BE4B020160
	for <linux-ext4@vger.kernel.org>; Tue,  9 Sep 2014 14:28:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0689C20166
	for <linux-ext4@vger.kernel.org>; Tue,  9 Sep 2014 14:28:53 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

            Bug ID: 84201
           Summary: mount doesn't clear usrjquota / grpjqouta options
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.0-4-amd64
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: robinedgar@gmail.com
        Regression: No

Hi, After changing the group quota file name in after the first run of
remount -o remount /
gives a
mount: / not mounted or bad option
error.
If you remove the usrjquota and groupjquota options from the fstab and remount,
mount runs. dmesg gives
EXT4-fs (vda1): re-mounted. Opts: (null)
but when you
mount
it still shows the old usrjquota and groupjquota values in the output.

/dev/disk/by-uuid/2ceaad1e-7ca8-42f9-b657-ce689beba638 on / type ext4
(rw,relatime,errors=remount-ro,user_xattr,barrier=1,data=ordered,jqfmt=vfsv1,usrjquota=aquota.user,grpjquota=aquota.user)

The same if you specify the noquota option in fstab or options. dmesg then
gives
EXT4-fs (vda1): re-mounted. Opts: noquota
If you remove all from the fstab and try
mount -o
remount,usrjquota=aquota.user,grpjquota=aquota.otherfilename,jqfmt=vfsv1 /
You get the bad option error again. In dmesg you get
EXT4-fs (vda1): group quota file already specified
I have deleted the old files and made sure that quotas are off using
quotaoff -afugpv

How do you clear the options completely?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

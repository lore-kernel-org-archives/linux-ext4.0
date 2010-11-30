From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Tue, 30 Nov 2010 20:54:20 GMT
Message-ID: <201011302054.oAUKsKVe012449@demeter2.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48352 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0K3UyV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Nov 2010 15:54:21 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAUKsKPQ012450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Nov 2010 20:54:21 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772





--- Comment #18 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca>  2010-11-30 20:54:18 ---
(In reply to comment #17)
> Something is scribbling on / has scribbled on the front of your filesystem, it
> seems.

I think/hope this is all old garbage that e2fsck has never cared about fixing.

> The various error tracking bits are in this part of the superblock so you're
> seeing the -1/4294967295 pop out in the error reporting code:

Right, and while it will be annoying to get this printed every day, it doesn't
actually hurt any operation of the filesystem.

> Your dd above should have zeroed this out, though, which makes me wonder how
> you got 1's back in here.  It could be anything, though I wonder if it's
> possible that it's a stray bitmap....

No, my "dd" command only zeroed out the second half of the superblock (starting
at 0x600, the s_mount_opts field.  It didn't touch the "error" parts of the
superblock, for simplicity/safety.  It should be possible to zero out these
fields, even from userspace on a mounted filesystem, since the superblock is
direct-mapped to the buffer.  Whether you do this depends on whether the
annoyance of the error message is higher than the risk that the following
command might clobber your filesystem (which of course I hope it doesn't):

dd if=/dev/zero of=/dev/dsk/by-label/MyBook bs=1 seek=0x17c skip=0x17c
count=0x84

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

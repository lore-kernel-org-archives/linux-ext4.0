From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 21:23:34 GMT
Message-ID: <200910272123.n9RLNYiC022274@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37171 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbZJ0VXa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 17:23:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9RLNY5T022275
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 21:23:34 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #134 from Linus Torvalds <torvalds@linux-foundation.org>  2009-10-27 21:23:33 ---
On Tue, 27 Oct 2009, in comment #132 from Eric Sandeen <sandeen@redhat.com>
wrote:
> 
> Perhaps more strange, doing the same test on a non-root fs under 2.6.32 also
> doesn't seem to hit it reliably.  Could it be something about the remount,ro
> flush of the root fs on the way down?
> 
> Suspecting that possibly "mount -o ro; e2fsck -a /dev/root" during bootup was
> causing problems by writing to the mounted fs, I short-circuited the boot-time
> fsck -a; things were still badly corrupted so that doesn't seem to be it.

It certainly isn't about the 'remount,ro' on the way down, since that's 
the part you avoid entirely in a non-clean shutdown.

But it could easily be something special about mounting the root 
filesystem, together with bad interaction with 'fsck'. 

Non-root filesystems will be fsck'd _before_ being mounted, but the root 
filesystem will be fsck'd _after_ the mount.

If the initial root ro-mount causes the filesystem recovery, and fsck then 
screws things up, then "root filesystem is special" might well trigger. It 
might explain why Ted and others are unable to re-create this - maybe they 
are being careful, and do ext4 testing with a non-ext4 root? 

Example issues that are exclusive to the root filesystem and would never 
be an issue on any other filesystem (exactly due to the "mount ro first, 
fsck later" behavior of root):

 - flaky in-kernel recovery code might trash more than it fixes, and would 
   never trigger for the "fsck first" case because fsck would already have 
   done it.

 - flaky user-mode fsck doesn't understand that the kernel already did 
   recovery, and re-does it.

 - virtually indexed caches might be loaded by the mount, and when you do 
   fsck later, the fsck writes back through the physically indexed direct 
   device. So the mounted root filesystem may never see those changes, 
   even after you re-mount it 'rw'.

 - even if every filesystem cache is physically indexed (ie using the 
   buffer cache rather page cache), there may be various cached values 
   that the kernel keeps around in separate caches, like the superblock 
   compatibility bits, free block counts, etc. fsck might change them, but 
   does 'remount,rw' always re-read them?

None of the four cases above are issues for a filesystem that isn't 
mounted before fsck runs.

            Linus

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

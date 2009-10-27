From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 21:42:11 GMT
Message-ID: <200910272142.n9RLgB7f026211@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33519 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZJ0VmH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 17:42:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9RLgBHi026212
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 21:42:11 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #135 from Eric Sandeen <sandeen@redhat.com>  2009-10-27 21:42:09 ---
(In reply to comment #134)

> Example issues that are exclusive to the root filesystem and would never 
> be an issue on any other filesystem (exactly due to the "mount ro first, 
> fsck later" behavior of root):
> 
>  - flaky in-kernel recovery code might trash more than it fixes, and would 
>    never trigger for the "fsck first" case because fsck would already have 
>    done it.

Yep, but I didn't have auto-fsck in my non-root testing, and I did "mount -o
ro" followed by "e2fsck -a" on it to try to "be like /", and didn't see it. 
Though I'll re-check just to be sure.

>  - flaky user-mode fsck doesn't understand that the kernel already did 
>    recovery, and re-does it.

It should print out a message if it's recovering again, we should see it in the
logs... and I don't think I have.

>  - virtually indexed caches might be loaded by the mount, and when you do 
>    fsck later, the fsck writes back through the physically indexed direct 
>    device. So the mounted root filesystem may never see those changes, 
>    even after you re-mount it 'rw'.

Yes, I've been worried about this... but would this be new?

Could probably test this theory by forcing an immediate reboot if e2fsck does
recovery on a readonly mounted fs.

>  - even if every filesystem cache is physically indexed (ie using the 
>    buffer cache rather page cache), there may be various cached values 
>    that the kernel keeps around in separate caches, like the superblock 
>    compatibility bits, free block counts, etc. fsck might change them, but 
>    does 'remount,rw' always re-read them?

same test above would help determine this, I think.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

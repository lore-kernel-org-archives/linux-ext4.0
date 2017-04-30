From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Sun, 30 Apr 2017 02:59:10 +0000
Message-ID: <bug-195561-13602-E2sxYqMRyd@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34592 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S968503AbdD3C7O (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 22:59:14 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 089B826490
        for <linux-ext4@vger.kernel.org>; Sun, 30 Apr 2017 02:59:14 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #23 from Theodore Tso (tytso@mit.edu) ---
What version of AOSP are you using, and how recently have you refreshed with
latest AOSP master (if you are using AOSP master)?

The reason why I ask is because there have been a number of changes that have
recently landed in AOSP over the last couple of months changing how ext4 file
systems are created.   They used to use make_ext4fs, and they are now using
mke2fs plus a collection of Android-specific utilities in
e2fsprogs/contrib/android.    (Note there are a lot of patches in AOSP's
e2fsprogs that haven't been integrated into mainline e2fsprogs yet.)

No one else is complaining about problems in the Linux kernel, and given that
you are seeing this problem across a huge spread of kernels, I'm wondering if
the problem is in the verison of AOSP you are using and whether it is creating
file systems which are sane.   I know that version being used internally at
Google is working, but it's possible (a) that what has been pushed out to AOSP
doesn't have all of the bug fixes that they are using, or (b) you haven't doing
a repo sync, and the bug has since been fixed in AOSP master, or (c) they have
been doing mostly ARM-based testing and the problem hasn't been noticed in
android-x86 yet.   (I have no idea which branches various Android development
efforts are using; it's not my main area of focus and I've been way to busy
recently to pay enough attention here.   So there is a bit of guessing here.)

Something you might want to try is try installing the file system where you've
been having trouble --- and then checking it with e2fsck before the kernel has
a chance to mount it read/write.   If e2fsck is reporting problems before the
kernel has mounted it, or mounted it read/write, then it's almost certainly a
userspace bug in AOSP somewhere.

One other thought.   I'm pretty sure there are some device kernels using 4.4
under development, but I'm *certain* there are device kernels using 3.18
(including, as it happens, my Pixel XL running Android 7.1.2).   So if you
haven't tried 3.18, give it a quick spin.   If you are seeing the problem on
3.18, then it's almost certainly not a kernel bug, but Something Else.  The
thing I come back to is that I'm not seeing any other complaints similar to
yours from Desktop distributions using Linux, or from people with shipped
devices, or people internally at Google doing development on Android O.  
(Which is out as a developer preview.  :-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

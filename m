From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Sun, 30 Apr 2017 03:20:42 +0000
Message-ID: <bug-195561-13602-m7zdzpoHtf@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35106 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S378482AbdD3DUq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 23:20:46 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A12E826E73
        for <linux-ext4@vger.kernel.org>; Sun, 30 Apr 2017 03:20:45 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #24 from Theodore Tso (tytso@mit.edu) ---
Hmm, the original bug report said you are using Android 7.1.  Which I think was
still using make_ext4fs.   I really don't trust make_ext4fs farther than I can
throw it.   Something else to try --- use "dd if=/dev/zero of=/dev/sdXX" before
doing whatever you do to install the file system.   There are multiple ways of
calling into the  make_ext4fs codepaths (from fastboot, from the recovery
partition, as part of the build process), and some of them didn't work
correctly if the underlying storage device wasn't zero'ed out (as would be the
case if you were using flash and the DISCARD command, or the eMMC equivalent). 
 I wonder if the issue has to do with a slightly different way the file system
is getting set up on android-x86, and if you are using magnetic HDD's that
doesn't have discard, that might be way you're seeing it and other Android
developers aren't.

I got tired of getting pulled in to debug weird problems that were traced down
to make_ext4fs being fragile (it works fine writing to sparse files, since
uninitialized blocks in a sparse file are all zeroes), which is why I was very
happy to see Android switching over to use mke2fs, instead of make_ext4fs,
which was a clean-room implementation back in the day when some Android
management was overly paranoid about GPLv2 in userspace.  There were some rough
spots since mke2fs -d doesn't deal with SELinux and other Android specific
issues, which is why e2fsprogs/contrib/android exists in the AOSP version of
e2fsprogs.   (It's there in the upstream version of e2fsprogs, but there a
bunch of bug fixes in the AOSP version that haven't propagated back to the
upstream e2fsprogs repo yet.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

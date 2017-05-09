From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Tue, 09 May 2017 16:10:16 +0000
Message-ID: <bug-195561-13602-vwK2e3spMx@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58886 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754469AbdEIQKq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 May 2017 12:10:46 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 048A62858E
        for <linux-ext4@vger.kernel.org>; Tue,  9 May 2017 16:10:45 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #29 from Theodore Tso (tytso@mit.edu) ---
If your firewall is not letting you access git.kernel.org, please complain to
your management.

There is a mirror of the xfstests-bld git tree on github:
https://github.com/tytso/xfstests-bld

However, to access the prebuilt test appliace files, or some of the other git
repositories needed by xfstests-bld if you want to do a build from scratch of
the test appliance, you will need access to either www.kernel.org or
git.kernel.org, so you might as well deal with your firewall configuration
issues sooner rather than later.

I basically don't trust make_ext4fs at all.   There is a reason I have been
pushing the android team to use e2fsprogs.  We do have an updated e2fsprogs in
AOSP, and some of the tools so that make_ext4fs can be replaced by mke2fs plus
some helper programs are mostly in AOSP.  They are not used by default, but
rather the Android team has been cutting devices over one at a time for Android
O, instead of whole sale.  My personal suspicion is that they very paranoid
because they are used to make_ext4fs breaking at random, so they have been
doing a slow migration over because they fear similar breakages as they migrate
away from make_ext4fs, particular as it relates to building a new system.img
file and doing a factory reset from the device.   However, if all you need to
do is format an ext4 file system on an SD card, and not try to set up a system
image or something else complicated where you have to set up SELinux labels,
etc., using mke2fs should be just fine.   It's what the rest of the Linux
ecosystem use, and what we upstream developers use for all of our regression
testing and daily personal use.   

To be clear, we do ****not**** make_ext4fs; that's an Android "special" that
was originally developed when certain management/legal types had a pathological
fear of the GPLv2, and then it grew all out of control and manageability.  
Since it was done as a clean room reimplementation, by someone who was not an
ext4 expert, and then had extra ext4 features as well as SELinux spliced into
it over time, it has caused me no end of headaches over the years....   :-(

If so Linaro folks could help accelerate the move away from make_ext4fs, I
would be most grateful.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

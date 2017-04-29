From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Sat, 29 Apr 2017 21:59:14 +0000
Message-ID: <bug-195561-13602-fh4ayVnSma@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55668 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1167015AbdD2V7Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 17:59:16 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2B1012833C
        for <linux-ext4@vger.kernel.org>; Sat, 29 Apr 2017 21:59:16 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #22 from Mauro Rossi (issor.oruam@gmail.com) ---
> Another possible concurring root cause may be 64 bit kernel build,
> as on virtualbox the issue is systematic with 64 bit build and I've never saw 
>  it with 32bit builds.

Quoting myself, because now I saw the issue also on 32bit android/32bit kernel

(In reply to Theodore Tso from comment #21)
> So the fsck outputs demonstrate that the file system really *is* getting
> corrupted.  It's not an erroneous message.   So switching between kernels
> after the file system has been corrupted does not mean that the newer
> kernels have whatever bug might have caused the corruption.   The question
> is which kernel version *corrupted* the file system in the first place.

When I stated that all kernel version between 4.4 and 4.11 are affected,
I haven't changed kernel after corruption, but always rebuilt with those
different kernels, installed Android cleaning EXT4 partition, booted and
updated Google Playstore/apps.

The Android installations based on different kernel versions (rebuilt and
reinstalled to different hard drives) show the same issue and the lustre
patches are undoubtedly a mitigation/workaround, still working on 4.11.
Those patches have been brewed for Linux Red Hat.

The newest kernels I'm using have minimal changes compared to torvalds/master,
and no changes were made to fs/ext4, 4.11rc7 based one is here:

https://github.com/maurossi/linux/tree/kernel-4.11rc7


> Since you are using an x86 kernel, my suggestion is before you try debugging
> it in an Android context, that you take that kernel and run a full set of
> regression tests on it.   See http://thunk.org/gce-xfstests for a very handy
> way to run the regression tests.  If you don't want to pay the cost for
> runnning tests in the cloud (a few pennies for each 30 minute smoke test,
> and around USD$ 1.50 for the full regression test), you can also use
> kvm-xfstests.  That will take longer, and it ties up a machine while the
> test is running (where as you can fire off many tests in parallel using
> gce-xfstests, and just wait for the test reports to be e-mailed back to you).
> 
> Even when I was trying to debug ARM kernels, I would often convert/bludgeon
> the BSP kernel so that the non-portable hacks added by the vendors could be
> worked around so the kernel could be compiled for x86, just because running
> the regression tests was worth it.   These days, on an ARM android system,
> we do have something (probably alpha or very early beta quality) that will
> allow you to run the tests in a chroot.   This is primarily helpful you are
> trying to debug something like hardware In-line crypto, that is only
> available from a particular ARM SOC.    For more information, please see:
> 
> https://github.com/tytso/xfstests-bld/blob/master/Documentation/android-
> xfstests.md
> 
> One warning.... many mobile handsets have ah.... "cost-optimized flash",
> which may be subject to early write exhaustion and massive write
> amplifications when stressed.  So if you try to run xfstests on your mobile
> handset, do it on a throwaway development machine where the flash is
> considered sacrificial.

Thanks, for android-x86 I test on laptops and desktops with magnetic HDD
I'll try blktrace which is available with android sources and android-xfstests,
I've also contacted the original author of the ext4 LU-1026 patch, to get
additional clues.

Mauro

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

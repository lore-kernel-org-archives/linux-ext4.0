From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Wed, 26 Apr 2017 15:11:05 +0000
Message-ID: <bug-195561-13602-58em5Pf7rq@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33254 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1437746AbdDZPLK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Apr 2017 11:11:10 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6FC6C28630
        for <linux-ext4@vger.kernel.org>; Wed, 26 Apr 2017 15:11:09 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #21 from Theodore Tso (tytso@mit.edu) ---
So the fsck outputs demonstrate that the file system really *is* getting
corrupted.  It's not an erroneous message.   So switching between kernels after
the file system has been corrupted does not mean that the newer kernels have
whatever bug might have caused the corruption.   The question is which kernel
version *corrupted* the file system in the first place.

Since you are using an x86 kernel, my suggestion is before you try debugging it
in an Android context, that you take that kernel and run a full set of
regression tests on it.   See http://thunk.org/gce-xfstests for a very handy
way to run the regression tests.  If you don't want to pay the cost for
runnning tests in the cloud (a few pennies for each 30 minute smoke test, and
around USD$ 1.50 for the full regression test), you can also use kvm-xfstests. 
That will take longer, and it ties up a machine while the test is running
(where as you can fire off many tests in parallel using gce-xfstests, and just
wait for the test reports to be e-mailed back to you).

Even when I was trying to debug ARM kernels, I would often convert/bludgeon the
BSP kernel so that the non-portable hacks added by the vendors could be worked
around so the kernel could be compiled for x86, just because running the
regression tests was worth it.   These days, on an ARM android system, we do
have something (probably alpha or very early beta quality) that will allow you
to run the tests in a chroot.   This is primarily helpful you are trying to
debug something like hardware In-line crypto, that is only available from a
particular ARM SOC.    For more information, please see:

https://github.com/tytso/xfstests-bld/blob/master/Documentation/android-xfstests.md

One warning.... many mobile handsets have ah.... "cost-optimized flash", which
may be subject to early write exhaustion and massive write amplifications when
stressed.  So if you try to run xfstests on your mobile handset, do it on a
throwaway development machine where the flash is considered sacrificial.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41004 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLCAHx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 19:07:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C73792A641
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 00:07:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 00:07:47 +0000
Message-ID: <bug-201685-13602-1ut2GDJc2t@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Sune Mølgaard (molgaard@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |molgaard@gmail.com

--- Comment #169 from Sune Mølgaard (molgaard@gmail.com) ---
FWIW, I didn't see any problems with 4.19.0, but see it on all my systems with
4.19.3 and onward (although I *did* skip 4.19.[12].

There fore, I embarked on a git bisect in linux-stable from v4.19 to v4.19.3,
which is nearing its end, *so far with every iteration marked GOOD*.

Referencing https://www.spinics.net/lists/linux-ext4/msg63498.html (#164), and
noting that I usually run kernels from kernel.ubuntu.com/~kernel-ppa/mainline ,
I did the following:

smo@dell-smo:~$ cat /proc/version 
Linux version 4.19.0-041900-generic (kernel@tangerine) (gcc version 8.2.0
(Ubuntu 8.2.0-7ubuntu1)) #201810221809 SMP Mon Oct 22 22:11:45 UTC 2018

Then, I downloaded 4.19.3 from kernel-ppa, unpacked, and:

smo@dell-smo:~/src/deb/foo/boot$ strings vmlinuz-4.19.3-041903-generic |grep
8.2.0
4.19.3-041903-generic (kernel@gloin) (gcc version 8.2.0 (Ubuntu
8.2.0-9ubuntu1)) #201811210435 SMP Wed Nov 21 09:37:20 UTC 2018

BANG, as they say: 8.2.0-9.

Whereas git bisect "GOOD"s continuously (as stated, it is not complete - only
almost) are not impossible, they certainly don't seem entirely normal, but:

sune@jekaterina:~$ gcc --version
gcc (Ubuntu 8.2.0-7ubuntu1) 8.2.0

...on the system where I self-compile during the bisect, *could* explain it.

My impression is, that a lot of affected people are on Ubuntu, and I suspect
the following:

* Many of the affected Ubuntu folks do indeed use kernels from kernel-ppa

* Some of those, as well as non-Ubuntu-folks, may have that compiler version
for other reasons, and hit the bugs on that account

* Bisecting yields inconclusive results, as it seems to do for me, since the
Issues is non-kernel.

* Theodore T'so and Jens Axboe are unable to reproduce due to unaffected
compiler versions, which also explains the no-show in regression tests.

Tso, Axboe: With the two of you being completely unable to replicate, could you 
be enticed to either try GCC 8.2.0-9 (or, possibly, just the packages from the
following URLs, and run your regression tests against those?

http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.19 (presumed GOOD)

http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.19 (presumed BAD)

Best regards,

Sune Mølgaard

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

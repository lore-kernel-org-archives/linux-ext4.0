From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Tue, 19 Sep 2017 17:18:09 +0000
Message-ID: <bug-89511-13602-fgqQoUfpQL@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58470 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750892AbdISRSO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Sep 2017 13:18:14 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CB09928ED9
        for <linux-ext4@vger.kernel.org>; Tue, 19 Sep 2017 17:18:13 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #76 from Theodore Tso (tytso@mit.edu) ---
The problem is that there way too many users for kernel developers to support. 
There are companies who specialize in getting vague reports for problems on
stable kernels (as opposed to the latest development kernels), from users who
don't know how to create a reproducible test case, or how to give a concise bug
report that has all of the necessary information in one place.  (Or for that
matter, understand how to use bugzilla properly!)

If someone wants to join the kernel mailing lists, and actively work the
problem, and submit patches, the upstream kernel devs are happy to invest
effort in helping someone learn how to participate in upstream kernel
development.  The model though of a kernel developers grooming bug tracking
systems for help requests, and trying to get enough information to identify a
problem, and then making it the kernel developers' responsibility to track
whether or not a user's issue has been resolved, simply doesn't scale.   There
are way too many users, and they outnumber the kernel devs.  If we followed
that model, we would never get any work done.

As far as this specific issue is concerned, it seems that per-USB-major/minor
blacklists are the best way to go.  Trying to add block layer and file system
level workarounds for what is, at its core, crappy hardware, doesn't seem to
make any sense.

The bigger problem is that this web page will be around for all eternity as an
attractive nuisance, and clueless users will see something which has similar
symptoms, but a completely different cause, and then re-open and demand
support.  This seems to be an insoluble problem, and I'm not sure what if
anything can be to address this.  (And to be honest, it's much more of a
problem for the Ubuntu Launchpad than the kernel bugzilla.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

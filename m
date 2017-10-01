From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197069] systemd service with ProtectHome=yes causes ELOOP when
 accessing /home
Date: Sun, 01 Oct 2017 00:37:13 +0000
Message-ID: <bug-197069-13602-xqvKTGSFVW@https.bugzilla.kernel.org/>
References: <bug-197069-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58410 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751217AbdJAAhO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 30 Sep 2017 20:37:14 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D693028C6A
        for <linux-ext4@vger.kernel.org>; Sun,  1 Oct 2017 00:37:13 +0000 (UTC)
In-Reply-To: <bug-197069-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197069

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |INVALID

--- Comment #6 from Theodore Tso (tytso@mit.edu) ---
The Fedora bug report you referenced indicates that it is fixed by installing
systemd 232 or above.

I suggest you post a bugfix in bug tracker system used by your distribution.  
And if their answer is they don't support newer kernels on an older / obsolete
distribution, then that's your answer.

You indicated you are using Red Hat 7.0.  I'm going to assume that's RHEL 7.0,
which is based on a 3.10 kernel, and a systemd from 3+ years ago.   If things
fall apart when you try installing a newer kernel, that won't be the first time
RHEL has compatibility problems with newer kernels.  If you are using RHEL 7,
that generally means you value stability more than you do new features.  If you
want to be using a newer kernel, you should try upgrading to a more modern
distribution *first*.

If you are indeed using RHEL, then the place to ask is the Red Hat Support.  I
can tell you that using a 4.4 or 4.9 kernel is not a supported kernel, so it
may very well be that the answer is that there is no right place, and what you
are doing is just not anything anyone is interested in supporting.  If you want
to pay someone enough money, or you want to retain your own Linux experts, I'm
sure they might be able to make it work --- as the old NASA saying goes,
"anything will fly if you give it enough thrust" --- but it's highly likely no
one is going to be interested in supporting you for free.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

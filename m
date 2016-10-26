From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 182261] Deleted files reappear
Date: Wed, 26 Oct 2016 20:40:55 +0000
Message-ID: <bug-182261-13602-uGzIBxWonl@https.bugzilla.kernel.org/>
References: <bug-182261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754342AbcJZUlv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Oct 2016 16:41:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 20F84203AC
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2016 20:40:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 3A493203B5
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2016 20:40:56 +0000 (UTC)
In-Reply-To: <bug-182261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=182261

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
On Tue, Oct 25, 2016 at 01:10:15PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> Hi I have been noticing this problem intermittently for a while now starting
> with kernel 3.14. Files I delete days/weeks ago reappear mysteriously and they
> are fully intact. My most recent encounter is using my Xubuntu system with the
> following config:
> 
> I deleted 4.7.6 / 4.8.0 kernels from my boot and also the /lib/modules for each
> and compiled and installed 4.8.4 only to notice that the files reappeared.

Did you uninstall the relevant Ubuntu package, or did you just delete
the fils using rm?  It could just simply be that Ubuntu was updating
to a newer version of that kernel version as it was updating other
packages on your system.

                        - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

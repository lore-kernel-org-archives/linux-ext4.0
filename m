From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Mon, 13 Nov 2017 16:27:31 +0000
Message-ID: <bug-151491-13602-mLYG2gZynJ@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34434 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752786AbdKMQ2V (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Nov 2017 11:28:21 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D6B4C29176
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 16:28:20 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

Betacentauri (betacentauri@arcor.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |betacentauri@arcor.de

--- Comment #6 from Betacentauri (betacentauri@arcor.de) ---
First result:
When I revert this commit
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/ext4?h=v4.1&id=9d21c9fa2cc24e2a195a79c27b6550e1a96051a4
in a 4.1 ARM kernel the problem doesn't occur any longer.
Scripts for replicating in the kvm-xfstests environment will follow later.


By the way: The setup boxes fischreiher and me are talking about use only
slightly adapted upstream kernel to support broadcom hardware. fs directory in
kernel sources is not changed.

Frank

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

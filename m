Return-Path: <SRS0=Xbv+=M6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39826 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbeJRWNf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Oct 2018 18:13:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5E90D28B6B
        for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2018 14:12:23 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201461] ext4 journal stalls write system call
Date: Thu, 18 Oct 2018 14:12:23 +0000
Message-ID: <bug-201461-13602-x39Iam2bU3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201461-13602@https.bugzilla.kernel.org/>
References: <bug-201461-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201461

--- Comment #5 from Theodore Tso (tytso@mit.edu) ---
Keep in mind that 3.10 was released over ***five years*** ago.   Quite frankly,
using a 3.10 kernel borders on malpractice, since it has so many unpatched
security holes it isn't funny.  If you are talking about a RHEL kernel, it has
diverged significantly from mainline and whether or not it is a security
disaster is between you and your Red Hat support contract.  :-)

My comments apply mainly to the the upstream development kernel, but to answer
your questions:

No, in 3.10, generic_writepages() does not call ext4_da_writepages().   And
ext4_da_writepages roughly corresponds to what ext4_writepages() in
non-obsolete kernels.

A huge number of things have changed between 3.10 and more modern kernels,
including many performance enhancements.   So some of the details have changed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

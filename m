Return-Path: <SRS0=pBWG=MZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:32798 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725734AbeJNFDn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 Oct 2018 01:03:43 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4200C2A636
        for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2018 21:25:09 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 200681] [inline_data] read() does not see what write() has just
 written through different FD in the same thread
Date: Sat, 13 Oct 2018 21:25:09 +0000
Message-ID: <bug-200681-13602-FrG3k8bGSh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200681-13602@https.bugzilla.kernel.org/>
References: <bug-200681-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=200681

--- Comment #8 from Theodore Tso (tytso@mit.edu) ---
Thanks for the repro.   It looks like the critical factor is not the size of
the filesystem, but the blocksize.  It just so happens that using a file system
of size of 8M causes mke2fs to default to a 1k block size.  This can be seen by
trying testing with a file system created by:

mke2fs -Fq -t ext4 -O inline_data -I 1024 -b 1024 /dev/vdc 

I've done some initial investigation, and something really strange is going on.
 If an fsync(2) is forced write after the writes, the problem goes away.  By
changing the size of the reads, it's the second read which is returning all
zeros --- up to the point where when the first read is made to be larger than
16k, at which point it looks like it's the last 4k page which is all zeros.

Unfortuantely, it's not clear what is happening.   The best I can say at this
point is that it looks the problem is related to inline_data, where when doing
a large write which forces a conversion from an inline_data to normal file, and
where the blocksize is != the page size, something is going very wrong.

To date, I've been only testing inline_data with a blocksize of 4k, and that's
probably why I haven't seen any problems like this.

I'm curious how you found this bug; were you deliberately using a 1k block
size, or were you trying to use inline_data with very small file systems?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

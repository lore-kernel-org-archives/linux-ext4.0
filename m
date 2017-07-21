From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Fri, 21 Jul 2017 07:48:28 +0000
Message-ID: <bug-196405-13602-hNTpVIj2cf@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50916 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752650AbdGUHsi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Jul 2017 03:48:38 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 10900286B3
        for <linux-ext4@vger.kernel.org>; Fri, 21 Jul 2017 07:48:38 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #16 from Paul Eggert (eggert@cs.ucla.edu) ---
(In reply to Andreas Dilger from comment #14)
> I did try testing on a small newly created ext4
> filesystem with 1024-byte blocks (in case the limit was with the 2-level
> htree), and hit ENOSPC because I ran out of inodes...

Yes, apparently that was my problem too. Thanks for catching that. I fixed
that, and ran into another problem: disabling dir_nlink is ineffective, i.e.,
mkdir continues to set the parent directory's link count to 1 when it
overflows. That is, if I run the following as root:

# fallocate -l 1G ~eggert/junk/image.iso
# mkfs.ext4 -O ^dir_nlink -N 110000 ~eggert/junk/image.iso
# mount ~eggert/junk/image.iso /mnt
# chmod a+rwx /mnt

and then run the test program in the /mnt directory, the test program still
fails in the same way, creating a parent directory with st_nlink == 1 in the
process. Afterwards, the file system's dir_nlink flag is set even though I did
not set it. (Note added later: I see that Theodore Tso also noticed this
problem.)

So dir_nlink is not really working for ext4, in the sense that st_nlink cannot
be made to work in a POSIX-compatible way.

> That makes LINK_MAX accurate only in a subset of cases, depending on
> the version of ext2/ext3/ext4 in use and filesystem features
> enabled, and it definitely isn't reporting values from the
> filesystem on a mount-by-mount basis.

Ouch, I didn't know that. This is another POSIX-compatibility problem, but one
thing at a time....

> The most important issue is that nlinks=1 on the directory causing fts() to
> miss entries during scanning.  It doesn't make sense for it to take nlinks=1
> and subtract 2 links for "." and ".." and expect to find "-1"
> subdirectories.

No, clearly the glibc code assumes GNU/Linux directories always have a link
count of at least 2.

> It may be that this causes an unsigned underflow and tools
> like "find" will not stop scanning until they hit 2^32-1 entries or similar?

I think "find" is OK because it doesn't happen to hit this particular fts bug.
I think there may well be similar fts bugs elsewhere, though -- possibly bugs
that "find" could hit.

> Also worthy of note, on my Mac (OSX 10.12.5, HFS+ Journaled fs), running
> fts-test.c with 65536 subdirectories has "ls -ld d" reporting 0 links, but
> fts-test.c still passes.

Yes, macOS fts is different. It would not surprise me if it didn't have the bug
we're talking about (also, it's probably significantly slower).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

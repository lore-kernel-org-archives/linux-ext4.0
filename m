Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40026 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725743AbeLBLv2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 06:51:28 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2CE1E2C084
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 00:37:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 00:37:41 +0000
Message-ID: <bug-201685-13602-85aZ64r9j3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

James Courtier-Dutton (James@superbug.co.uk) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |James@superbug.co.uk

--- Comment #118 from James Courtier-Dutton (James@superbug.co.uk) ---
I have not observed the problem, but I have been thinking of maybe a more
reliable way to detect a problem.
btrfs has a "scrub" command that essentially verifies the checksum of every
file on the disk.
Now, ext4 does not have such a feature (as far as I know).
How about people who are seeing this problem, do a recursive sha1sum -b of
every file on the disk while in a known good state, and then do a sha1sum -c 
of every file on the disk to see which ones got corrupted.
This might help when doing git bisect and checking that we are back to a known
good file system, and in cases like comment #116, item 2.

Also, I think there is a way to force a reboot to a particular kernel, using
grub, so one could script and git bisect, reboot to old working kernel, fsck,
then reboot to problem kernel and start next git bisect all using automated
scripts.

Anyway, just ideas.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

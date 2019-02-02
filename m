Return-Path: <SRS0=+s2W=QJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E090C282DA
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 14:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5825B2085A
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 14:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfBBO3x convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 2 Feb 2019 09:29:53 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59502 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbfBBO3x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2019 09:29:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C284B2F77D
        for <linux-ext4@vger.kernel.org>; Sat,  2 Feb 2019 14:29:52 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id B2A1D2F738; Sat,  2 Feb 2019 14:29:52 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202485] chmod'ed permission not persisted upon fsync
Date:   Sat, 02 Feb 2019 14:29:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-202485-13602-g4b7MsXxbZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202485-13602@https.bugzilla.kernel.org/>
References: <bug-202485-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202485

--- Comment #3 from Theodore Tso (tytso@mit.edu) ---
I do believe we should either fix the man page to document existing practice,
or change the kernel.   Changing kernel behaviour here going to be a fairly
involved, since today the filesystem layer (ext4, btrfs, xfs) is not even
informed when a special device file is open, read, written, fsync'ed, etc.  
Which makes sense; when you write to /dev/tty or /dev/ttyS1, or /dev/sda3,
etc., it has nothing to do with the file system where the where the directory
entry to said special device file is found.   And indeed, if one were to open
/dev/sda3, write to it, and then fsync it, the vast majority of user space
programs care about the *data* written to /dev/sda3, and not to any associated
metadata, such as the permission bits or the modtime of /dev/sda3 being
persisted.

The history behind fsync(2) was that it was intended for regular files, not
special device files, and for database programs in particular.  The
fdatasync(2) call was added later as an optimization to avoid unnecessary
updates to the inode when it was not necessary to be able to access the data
blocks that had been written.   I am not sure how many legacy Unix
implementations implement the semantics that you are hoping for, and I very
much doubt there are any user space programs who depend on such a behavior.

As such, I suspect it's going to be hard to get most developers to care about
implementing this if it's only to be about API semantic purity.   If there was
a cash-rich, say, Japanese corporation that was going to throw $$$ at a company
asking them to fix it, it might happen, if it didn't complicate the
implementation; most developers would be far more interested in keeping the VFS
layer bug-free and long-term maintainable compared to API semantic purity.  Or
if *you* really care, it might be an interesting starter project.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

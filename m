Return-Path: <SRS0=+s2W=QJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95190C282D8
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 03:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6281720818
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 03:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfBBDic convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 22:38:32 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41866 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726528AbfBBDib (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 22:38:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C3FA932604
        for <linux-ext4@vger.kernel.org>; Sat,  2 Feb 2019 03:38:30 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id A2DF93313C; Sat,  2 Feb 2019 03:38:30 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202485] chmod'ed permission not persisted upon fsync
Date:   Sat, 02 Feb 2019 03:38:30 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202485-13602-ZNUiFtKKNF@https.bugzilla.kernel.org/>
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

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso (tytso@mit.edu) ---
This is going to be true of all special files (block and character devices,
unix domain sockets, FIFO's etc.), and it's going to be true for all file
systems in Linux.

That's because the VFS provides the file_operations structures for these
special files, and the underlying file system never gets the notified about the
fsync().   All of these special files don't have a fsync function defined, so
fsync() on these devices will be a no-op.

Whether or not this is a bug is an interesting philosophical question.   The
Single Unix Specification is extremely non-directive on this score, saying that
it's all implementation defined.   The Linux man page does have this statement:

        As well as flushing the file data, fsync() also flushes the metadata
        information associated with the file (see inode(7)).

So what has been implemented in the Linux kernel for decades is at odds with
this statement, at least as it relates to special Unix files.

Do you have a use case or a program where this is important?  Or is this
something merely of academic interest?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

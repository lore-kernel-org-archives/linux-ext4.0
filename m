Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38210 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbeLBSTP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 13:19:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 96D752A85F
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 18:19:12 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 18:19:11 +0000
Message-ID: <bug-201685-13602-dqHvOLHx8p@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #153 from James Courtier-Dutton (James@superbug.co.uk) ---
(In reply to Theodore Tso from comment #127)
> 
> While there have been a few people who have reported problems with the
> contents of their files, the vast majority of people are reporting problems
> that seem to include complete garbage being written into metadata blocks ---
> i.e., completely garbage in to inode table, block group descriptor, and
> superblocks.    This is getting detected by the kernel noticing corruption,
> or by e2fsck running and noticing that the file system metadata is
> inconsistent.   More modern ext4 file systems have metadata checksum turned
> on, but the reports from e2fsck seem to indicate that complete garbage (or,
> more likely, data meant for block XXX is getting written to block YYY); as
> such, the corruption is not subtle, so generally the kernel doesn't need
> checksums to figure out that the metadata blocks are nonsensical.
> 

Is it possible to determine the locality of these corruptions?
I.e. Is the corruption to a contiguous page of data (e.g. 4096 bytes corrupted)
or is the corruption scattered, a few bytes here, a few bytes there?
>From your comment about "data meant for block XXX is getting written to block
YYY" can I assume this is fact, or is it still TBD?

If it is contiguous data, is there any pattern to the data that would help us
identify where it came from?

Maybe that would help work out where the corruption was coming from.
Maybe it is DMA from some totally unrelated device driver, but by looking at
the data, we might determine which device driver it is?
It might be some vulnerability in the kernel that some hacker is trying to
exploit, but unsuccessfully, resulting in corruption. This could explain the
reason why more people are not seeing the problem.

Some people reporting that the corruptions are not getting persisted to disk in
all cases, might imply that the corruption is happening outside the normal code
paths, because the normal code path would have tagged the change as needing
flushing to disk at some point.

Looking at the corrupted data would also tell us if values are within expected
ranges, that the normal code path would have validated. If they are outside
those ranges, then it would again imply that the corrupt data is not being
written by the normal ext4 code path, thus further implying that there is not a
bug in the ext4 code, but something else in the kernel is writing to it by
mistake.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

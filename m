Return-Path: <SRS0=3Woa=SR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4638C10F0E
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 21:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD90206B6
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 21:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfDOVJv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 17:09:51 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34420 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726621AbfDOVJv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 15 Apr 2019 17:09:51 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7A71328508
        for <linux-ext4@vger.kernel.org>; Mon, 15 Apr 2019 21:09:50 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 6EC9228587; Mon, 15 Apr 2019 21:09:50 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203247] jbd2 gets stuck at jbd2_journal_commit_transaction
 frequently
Date:   Mon, 15 Apr 2019 21:09:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext3
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-203247-13602-N2POZJJl9p@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203247-13602@https.bugzilla.kernel.org/>
References: <bug-203247-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203247

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #11 from Theodore Tso (tytso@mit.edu) ---
Looking at your iostat -x output, /dev/sda is completely utilized:



Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s 
sda               0.00  1154.00   47.00  836.00   864.00 10076.00    

avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
24.78    136.46     116.05  331.72  103.93   1.13 100.00

Note the 100% utilization and the average queue size of 136.46 I/O requests.  
So as I said, this sounds like I/O overload.   Your workload is simply issuing
more I/O than the disk can handle.   Why is going to be a userspace issue.

If you don't care about stale data (e.g., belonging to deleted files, which may
have privacy issues if you care about GDPR, HIPPA, PCI, etc. mandates) you
could try mounting with the mount option "data=writeback".  It could be that
updating to a newer version of the kernel (4.9.86 is quite antique, and you're
probably missing all sorts of security and otehr bug fixes) and a newer
userspace, and then setting up a new set of file systems formatted with ext4
will also help performance.   Or there might be something going on with
userspace writes to /dev/sda that shouldn't be happening or which could be
optimized away.

But I don't see anything here which is a kernel bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

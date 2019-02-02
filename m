Return-Path: <SRS0=+s2W=QJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B57FC282D7
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 04:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D333D20870
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 04:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfBBEBQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 23:01:16 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45704 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726193AbfBBEBP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 23:01:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1997633192
        for <linux-ext4@vger.kernel.org>; Sat,  2 Feb 2019 04:01:15 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 0C14A32C42; Sat,  2 Feb 2019 04:01:15 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202485] chmod'ed permission not persisted upon fsync
Date:   Sat, 02 Feb 2019 04:01:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vijayc@utexas.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202485-13602-1zdUGW8bIY@https.bugzilla.kernel.org/>
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

Vijay Chidambaram (vijayc@utexas.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vijayc@utexas.edu

--- Comment #2 from Vijay Chidambaram (vijayc@utexas.edu) ---
Hi Seulbae,

Adding on to what Ted said, the POSIX standards are not very specific about
crash-consistency guarantees. I'd recommend you go through the ext4/btrfs/xfs
mailing lists searching for "Vijay Chidambaram", Jayashree Mohan", or "Ashlie
Martinez" to find prior discussions and other potential dead-ends. The previous
discussions also document the guarantees provided by the widely-used Linux file
systems, so that you know what is a bug and what is not. 

For example, a symlink also does not have crash-consistency guarantees:
https://www.spinics.net/lists/linux-btrfs/msg76816.html

Our OSDI paper has more details:
http://www.cs.utexas.edu/~vijay/papers/osdi18-crashmonkey.pdf

Thanks,
Vijay Chidambaram, UT Austin

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

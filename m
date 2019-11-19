Return-Path: <SRS0=YMbR=ZL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7C6C432C3
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Nov 2019 01:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB7A122312
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Nov 2019 01:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfKSBCb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbfKSBCb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Nov 2019 20:02:31 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 205569] potential data race (likely benign) on inode->i_state
 (reading and writing to different bits)
Date:   Tue, 19 Nov 2019 01:02:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mengxu.gatech@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205569-13602-uptZ0YofDD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205569-13602@https.bugzilla.kernel.org/>
References: <bug-205569-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205569

--- Comment #2 from Meng Xu (mengxu.gatech@gmail.com) ---
(In reply to Theodore Tso from comment #1)
> The writeback thread is only applicable for data files.   While rmdir() is
> only applicable for directories.   Also, in both of these function traces,
> what you referenced is i_state bits being *read*:
> 
>  [WRITE] dirty = inode->i_state & I_DIRTY;
>   ^^^^^ not correct!
> 
> That being said, there are places in fs/fs-writeback.c where i_state is
> modified, and there are code paths where ext4_orphan_add() can be called on
> regular data files --- just not the ones you've listed in this bug.
> 
> Can you recheck the call traces and make sure they are correct?

Hi Ted,

My bad, the [WRITE] location is a few lines down the path,
inode->i_state &= ~dirty;

Best Regards,
Meng

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

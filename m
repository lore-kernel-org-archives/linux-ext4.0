Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BB7C282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 03:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E93C2184B
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 03:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfAXDkU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 22:40:20 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47940 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727302AbfAXDkT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 22:40:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 708A52DCC5
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2019 03:40:18 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 6F1482DEA4; Thu, 24 Jan 2019 03:40:18 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Thu, 24 Jan 2019 03:40:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aneesh.kumar@linux.ibm.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201631-13602-7YZqhMcXfx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #50 from Aneesh Kumar KV (aneesh.kumar@linux.ibm.com) ---
(In reply to Jan Kara from comment #47)
> OK, so it seems to be more and more clear that PPC indeed has some race in
> page table updates. What I can see in the latest report is:
> 
> Clean page (index 92, ino 681741, i_size 828368, flags 7fff0000002016,
> mapcount 1) with dirty PTE (pte_val c0000005f7fae186) on unmap! Vma flags
> fb, pgoff 0, file ino 681741
> ...
> page 92: b_state 21, b_blocknr 2801084, b_mapped 1452389112002, b_mapped2 0,
> b_cleaned 1452396217779, now 1452400395514
> 
> So "Vma flags fb" shows its a normal shared, writeable file mapping. Page is
> somewhere in the middle of the file (file size is 828368, page is at offset
> 376832). The page has been writeably mapped 11ms ago (you are using ext2
> filesystem which was confusing my previous debug attempts so only this one
> has shown proper times) and written back 4ms ago (which should have
> writeprotected the pte) but we still have writeable pte now on which the
> assertion hits. So either page_mkclean() failed to clear the PTE or someone
> created new writeable PTE without telling ext4.
> 
> I'll attach a new version of debug patch to distinguish these two cases.

The fact that we did try to write out the page at (bh_cleaned
1452396217779)implies we should have cleared the _PAGE_WRITE bit right
(clear_page_dirty_for_io())? So we should either find that bit cleared in pte
(if we missed a related tlb flush and tlb still has that pte with _PAGE_WRITE)
or we find that set. In this case, we find _PAGE_WRITE set in the pte during
zap. Does that imply we did call finish_fault()? which should have ideally
resulted in we calling page_mkwrite().

I am still not clear what could be a possible race that can result in this?

-aneesh

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

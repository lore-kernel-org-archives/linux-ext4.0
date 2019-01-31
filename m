Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4A9C169C4
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 09:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00AD52086C
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 09:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfAaJKd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 04:10:33 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39158 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbfAaJKd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Jan 2019 04:10:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9AAED2FC94
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2019 09:10:32 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 8C4432FD54; Thu, 31 Jan 2019 09:10:32 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Thu, 31 Jan 2019 09:10:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jack@suse.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201631-13602-cSz8c3YoKz@https.bugzilla.kernel.org/>
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

--- Comment #62 from Jan Kara (jack@suse.cz) ---
Erhard, thanks for the results! They are very weird but pretty clear: cleaned
state is 0x10 so page_vma_mapped_walk() called from page_mkclean() has bailed
out somewhere between:

        if (bh)
                bh->b_cleaned_state |= 16;
restart:
        pgd = pgd_offset(mm, pvmw->address);
        if (!pgd_present(*pgd))
                return false;
        p4d = p4d_offset(pgd, pvmw->address);
        if (!p4d_present(*p4d))
                return false;
        pud = pud_offset(p4d, pvmw->address);
        if (!pud_present(*pud))
                return false;
        if (bh)
                bh->b_cleaned_state |= 32;

I really don't understand how any of these tests could fail when later
unmap_page_range() has found the pte. But I somehow suspect commit 
da7ad366b497f5 "powerpc/mm/book3s: Update pmd_present to look at _PAGE_PRESENT
bit" could be related since it was introduced in the window where the problems
started happening and it touches relevant code.

Aneesh, what needs to be reverted so that we can test that this commit is
indeed the problematic one? I suppose:

da7ad366b497 "powerpc/mm/book3s: Update pmd_present to look at _PAGE_PRESENT
bit"
f1981b5b302f "powerpc/mm/hugetlb/book3s: add _PAGE_PRESENT to hugepd pointer."
ae28f17b5eeb "powerpc/mm/book3s: Check for pmd_large instead of pmd_trans_huge"
75646c480fde "arch/powerpc/mm/hash: validate the pte entries before handling
the hash fault"
8890e03380d3 "powerpc/mm/thp: update pmd_trans_huge to check for pmd_present"
a0820ff33451 "powerpc/mm:book3s: Enable THP migration support"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF115C169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 09:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D8AC2082E
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 09:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfA2JkF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:40:05 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42850 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727041AbfA2JkE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 04:40:04 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E641E2B29D
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 09:40:03 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id D518B2B29E; Tue, 29 Jan 2019 09:40:03 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Tue, 29 Jan 2019 09:40:03 +0000
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
Message-ID: <bug-201631-13602-E0nZwrefms@https.bugzilla.kernel.org/>
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

--- Comment #54 from Jan Kara (jack@suse.cz) ---
Thanks for the results Erhard. Finally something to go on in the debug results.
The pages have been normally faulted in for writing and PTE got set at time
1036580120591 from wp_page_reuse(). But then, although we've called
clear_page_dirty_for_io() which calls page_mkclean() (at time 1036587452118),
we've never reached the debug point in page_mkclean_one() where PTE write bit
gets cleared. So it looks that for some reason page_mkclean() doesn't do what
it should on your machines.

I was considering a race with munmap() but page_mkclean() uses mapping->i_mmap
tree to find the VMA and we remove vmas from that tree only after
unmap_page_range() is complete so that does not look possible. Also it is very
strange because this is common code for all architectures but you seem to be
the only one hitting the problem so far.

Aneesh, any idea?

Anyway, I've added more debugging to page_mkclean() to see which paths it is
taking and maybe that'll tell us something.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

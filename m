Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6437FC282CB
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 09:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A89320821
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 09:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfBEJVP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:21:15 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36110 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727501AbfBEJVP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2019 04:21:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 086AE2AE50
        for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2019 09:21:15 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id E48A52AEB3; Tue,  5 Feb 2019 09:21:14 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Tue, 05 Feb 2019 09:21:13 +0000
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
Message-ID: <bug-201631-13602-IHMtIO3d3z@https.bugzilla.kernel.org/>
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

--- Comment #69 from Aneesh Kumar KV (aneesh.kumar@linux.ibm.com) ---
Ok, can we try with only Revert-powerpc-mm-book3s-Enable-THP-migration patch? I
am looking at whether we are getting the migration check on page table entries
wrong.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

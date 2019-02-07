Return-Path: <SRS0=C+hA=QO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ABEC282C2
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 09:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0BE218B0
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 09:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfBGJGm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:06:42 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39694 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfBGJGl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2019 04:06:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 075F72D043
        for <linux-ext4@vger.kernel.org>; Thu,  7 Feb 2019 09:06:41 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id EFDC22A74B; Thu,  7 Feb 2019 09:06:40 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Thu, 07 Feb 2019 09:06:38 +0000
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
Message-ID: <bug-201631-13602-fLPdVg15vh@https.bugzilla.kernel.org/>
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

--- Comment #72 from Jan Kara (jack@suse.cz) ---
Just a suggestion to PPC maintainers / Aneesh: This bug can lead to data
corruption (lost data written to a file) or potential security issues (writes
to file user is no longer supposed to be able to write to) because it leads to
PPC leaving writeably mapped pages behind. So since we are at -rc5 I think
considering just reverting the patches and figuring out what's going on
separately without exposing general users to these issues is a fair question... 

Note that the problem affects already 4.20 so -stable needs to be included
regardless how you decide to solve these issues.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

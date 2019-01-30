Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD68C282D7
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 12:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7438520882
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 12:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfA3Mxl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 07:53:41 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43178 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727227AbfA3Mxl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 30 Jan 2019 07:53:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F2CCB2EBC5
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2019 12:53:40 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id E77282EC61; Wed, 30 Jan 2019 12:53:40 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Wed, 30 Jan 2019 12:53:39 +0000
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
X-Bugzilla-Changed-Fields: attachments.isobsolete attachments.created
Message-ID: <bug-201631-13602-WrUfM7p1CL@https.bugzilla.kernel.org/>
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

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #280697|0                           |1
        is obsolete|                            |
 Attachment #280841|0                           |1
        is obsolete|                            |

--- Comment #58 from Jan Kara (jack@suse.cz) ---
Created attachment 280871
  --> https://bugzilla.kernel.org/attachment.cgi?id=280871&action=edit
mm: Dump page and PTE state and some history (v6)

Yeah, that was just a context difference. Rebased the patch on top of 5.0-rc4.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

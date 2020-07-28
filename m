Return-Path: <SRS0=temF=BH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F8CC433E0
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Jul 2020 08:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42E92075D
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Jul 2020 08:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgG1Ice convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 28 Jul 2020 04:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbgG1Icd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 28 Jul 2020 04:32:33 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 207729] Mounting EXT4 with data_err=abort does not abort
 journal on data block write failure
Date:   Tue, 28 Jul 2020 08:32:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jack@suse.cz
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207729-13602-9qz1oojuSh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207729-13602@https.bugzilla.kernel.org/>
References: <bug-207729-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207729

--- Comment #4 from Jan Kara (jack@suse.cz) ---
Thanks for the reproducer! Good spotting! This is indeed broken. The problem is
that the write to the second file block happens, data is written to page cache.
Then fsync(2) happens. It starts writeback of the second file block - allocates
block, extends file size, submits write of the second file block, and waits for
this write to complete. Because the write fails with EIO, waiting for the write
to complete returns EIO which then bubbles up to userspace. But this also
"consumes" the IO error and so the journalling layer which commits transaction
later does not know there was IO error before and so it happily commits the
transaction. As I've verified, this scenario indeed leads to stale data
exposure that data_err=abort mount option is meant to prevent.

I have to think how to fix this properly...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

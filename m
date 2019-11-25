Return-Path: <SRS0=iiOq=ZR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8516C432C0
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Nov 2019 10:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFD42071E
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Nov 2019 10:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfKYKJI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Nov 2019 05:09:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfKYKJI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 25 Nov 2019 05:09:08 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 205609] Multiple bugs in __ext4_expand_extra_isize (OOB write
 and UAF write)
Date:   Mon, 25 Nov 2019 10:09:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tristmd@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205609-13602-cx13eaOmDi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205609-13602@https.bugzilla.kernel.org/>
References: <bug-205609-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205609

--- Comment #6 from Tristan (tristmd@gmail.com) ---
Dear  Theodore,

- Looks like syzkaller bot have found the UAF too. 

- The OOB write's path is different to be triggered (check the stack trace) but
the root cause seems to be similar at the end

- I am running syzkaller by myself 

- I will work on the dev branch of the ext4.git tree as suggested

- At this time, I think the commit "ext4: add more paranoia checking in
ext4_expand_extra_isize handling" should have fixed both issues but I can
verify

Thanks.

Kind regards,

Tristan

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

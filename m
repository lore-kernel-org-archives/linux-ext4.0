Return-Path: <SRS0=U/jV=DJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2841FC4363D
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Oct 2020 10:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C32206B6
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Oct 2020 10:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgJBKex convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 2 Oct 2020 06:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgJBKex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Oct 2020 06:34:53 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 205957] Ext4 64 bit hash breaks 32 bit glibc 2.28+
Date:   Fri, 02 Oct 2020 10:34:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: glaubitz@physik.fu-berlin.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205957-13602-E6zvtw7amD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205957-13602@https.bugzilla.kernel.org/>
References: <bug-205957-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205957

--- Comment #18 from John Paul Adrian Glaubitz (glaubitz@physik.fu-berlin.de) ---
> The right place to fix this is in the distributions enabling LFS support, not
> in ext4, not in qemu (which is completely blameless and should not be
> changed) and only marginally in glibc.

(...)

> If distributions didn't enable LFS (large file support) in the last 15 years,
> they are weird.  Everyone has drives > 4 GiB, usually > 1000 GiB, nowadays. 
> But without LFS users can't even create a file > 4 GiB on those.  How are
> there still distributions which actually have this problem?

You are absolutely right but the real world isn't perfect, unfortunately and
while I have done my best to find packages affected by this and force them to
use _FILE_OFFSET_BITS=64, I'm still occasionally running into packages affected
by this bug which is why I'm still patching glibc locally.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

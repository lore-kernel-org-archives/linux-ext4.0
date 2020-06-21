Return-Path: <SRS0=HOyS=AC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8856FC433DF
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Jun 2020 20:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FF325286
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Jun 2020 20:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgFUUkH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Jun 2020 16:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgFUUkG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Jun 2020 16:40:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 208271] Occurred when tried to create an ext4 filesystem on an
 exfat micro-sd. Trace is in description
Date:   Sun, 21 Jun 2020 20:40:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dreamshader@gmx.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-208271-13602-MRQearvxak@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208271-13602@https.bugzilla.kernel.org/>
References: <bug-208271-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208271

dreamshader@gmx.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Occurred when tried to      |Occurred when tried to
                   |create an ext4 filesystem   |create an ext4 filesystem
                   |on an exfat micro-sd. Trace |on an exfat micro-sd. Trace
                   |is in dexcription           |is in description

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

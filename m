Return-Path: <SRS0=TfJH=XU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2832C432C2
	for <linux-ext4@archiver.kernel.org>; Wed, 25 Sep 2019 14:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 893292146E
	for <linux-ext4@archiver.kernel.org>; Wed, 25 Sep 2019 14:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbfIYOdv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 25 Sep 2019 10:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfIYOdv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 25 Sep 2019 10:33:51 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 204779] Xubuntu 18.04 Sometimes freezes when turned off on the
 logo
Date:   Wed, 25 Sep 2019 14:33:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: ACPI
X-Bugzilla-Component: BIOS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: acpi_bios@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc assigned_to
Message-ID: <bug-204779-13602-nfj3TDibYK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204779-13602@https.bugzilla.kernel.org/>
References: <bug-204779-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204779

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
           Assignee|fs_ext4@kernel-bugs.osdl.or |acpi_bios@kernel-bugs.osdl.
                   |g                           |org

--- Comment #4 from Theodore Tso (tytso@mit.edu) ---
It was assigned to the upstream ext4 group, which meant no one was going to be
paying attention to it (the ext4 file system team does not look at ACPI issues)
and the bug is versus a distribution kernel.   If you can reproduce the problem
using the latest upstream kernel, then you can file a bug reporting to the ACPI
mailing list.  But it is often much more efficient to let the distribution's
kernel team triage the bug first.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

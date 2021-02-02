Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68C2C433DB
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Feb 2021 17:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D11B64F8C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Feb 2021 17:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbhBBRI5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236908AbhBBRGs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Feb 2021 12:06:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AC4FC64E40
        for <linux-ext4@vger.kernel.org>; Tue,  2 Feb 2021 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612285568;
        bh=wtGhN6vXItomTl/ihJHbhdn7GYKhnJZyVU95FDDQPu8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fqCCVVvMtyYp5zuTP5JuPSKibpSFPXlssPruBTCCfLzallmYbsgKES6N7RXm4YIXy
         EXgHbyVHFFVaj3roKn/8Rl744U689m53VZnniC0rTAu7qngzQXQdS86uBTpxHPkH1+
         vhNiGQcscOnYx339SEUxy3PNEs2k4tAntLXy7AWe39SrfW144pTx/IldXZwhIp5Rpb
         6CKkl7LU16fXMZWdyW2ZTbTjyz/UTo7RsmQiiouMXMu3A8p9XYamKrGbYdGzkiUf3s
         WvqUMQm4lUSipagIDMJ31LGNrg96yGmQKfhLCYJ06tlQEQQpKco8jFl397xRwcOrnt
         3hRU/c1AVdkQw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 210185] kernel BUG at fs/ext4/page-io.c:126!
Date:   Tue, 02 Feb 2021 17:06:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210185-13602-LYfNPNlJdL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210185-13602@https.bugzilla.kernel.org/>
References: <bug-210185-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D210185

--- Comment #13 from Theodore Tso (tytso@mit.edu) ---
How many CPU's and memory do you have on your servers?   And what distribut=
ion
and distro version are you using, in case that matters?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

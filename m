Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599B5C4332F
	for <linux-ext4@archiver.kernel.org>; Mon, 30 Oct 2023 08:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjJ3I2m (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Oct 2023 04:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjJ3I2l (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Oct 2023 04:28:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40870B4
        for <linux-ext4@vger.kernel.org>; Mon, 30 Oct 2023 01:28:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D32A1C433C8
        for <linux-ext4@vger.kernel.org>; Mon, 30 Oct 2023 08:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698654518;
        bh=NPai1scm7gbbyZ/eJKxzJh1XzVHc8vwmsaaQTlH49to=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DGqUhgVpGlDNJmS6IV9S2GhhgAREIsPir1+YMv8r+uhaPcM+EQIv/NedbhsawEvOW
         a5OflfZxWgFzY29ZgaBPflYAKnXVdpGFbXA3Q2P1Hdn99l3PVkq+yAuiVBD6HKBM+t
         M1A7jNRqPlz1e/8muvQk2FY4KPJQbd3D766NibCa9Xf+02NP8gwgHxO4YP1V1xHtGC
         1oPZa/JpuwSGb4VSZpTLHepOxIPMNWTwoJ6ykvsdoS9pvQ/t+Z8Gd4EcsSQNNzISvc
         S/ErBFXxeaK2tZ/8ILj1AMy8lcchAZObzIfG5TIfRumiVSYbeiO0vhuIEhQu7pBswm
         /9T/1j5wbsooA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BC65FC53BD1; Mon, 30 Oct 2023 08:28:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 218087] ext4 hung on kernel 4.14.133
Date:   Mon, 30 Oct 2023 08:28:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218087-13602-tSRjFlGfAD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218087-13602@https.bugzilla.kernel.org/>
References: <bug-218087-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218087

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
Without a reproducible test case, it's extremely unlikely anyone will be
investigating an issue in a many years old unsupported kernel.

The current supported release of the 4.4 tree is 4.14.328.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

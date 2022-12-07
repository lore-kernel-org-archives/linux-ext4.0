Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799F5C47089
	for <linux-ext4@archiver.kernel.org>; Wed,  7 Dec 2022 17:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiLGRUW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLGRTv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2022 12:19:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74F7218E
        for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2022 09:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C400B81F27
        for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2022 17:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31C5EC433B5
        for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2022 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670433588;
        bh=h4vy1TBbLxv/qAVQbXSAHe2ezL94gydeZNlALKwNO8U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dZtkI19U3QuTLL+BPVhVQw0nED02bHxHhD0SrQJs713xQqrPiuFRDoDXv0rrmks+g
         /w0Ix/hBPqX/wXA8/nt+WwBIid/aAa/sFUApiOom2okCT2r7kll8n6bEVsJE4Qkkya
         0eM+d53yD4OuVpnazfvPgvaKDLozk1PGZX8rL3ENl4h3yxvSUYyLXo/HyELdhWhFYi
         FyMSaI+8AYNYEjdiopaWMOCYJgpHDkpAX7MXqCLDMH059BmVqoIAmtTfNVH3t5+flf
         5yEtxOZY+QqCzMs0UO51rtKH79xiFs471r6Q9Pm5H/Nk92feo8yVBKm1tLiNKYpz0b
         zroxGwoFt6IVw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 22842C433E9; Wed,  7 Dec 2022 17:19:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 216784] There is "ext4_xattr_block_set" WARNING in v6.1-rc8
 guest kernel
Date:   Wed, 07 Dec 2022 17:19:47 +0000
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
X-Bugzilla-Changed-Fields: longdescs.isprivate
Message-ID: <bug-216784-13602-h7RFBlEWJ5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216784-13602@https.bugzilla.kernel.org/>
References: <bug-216784-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216784

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
      Comment #1 is|1                           |0
            private|                            |

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EC3C04A68
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Jul 2022 20:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiGZUKb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Jul 2022 16:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiGZUKa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2022 16:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853E731DEB
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2022 13:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40588B8199F
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2022 20:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5C77C433D7
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2022 20:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658866226;
        bh=YsgwQt1iAQGcsiXTCMJdSvqP0bI/49+MwZNNe2tq+H8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oVBnjBr6E3QUzFIdvgdhbbcbRppE4/IZbU0QUgxLHyt0PM2u3PLvEQ4MrbD83H4r8
         JdvV27OnWGjjDgCY224RJEArfJZQ29wRqSqC/0aqp6f51+ULGsBs4jBB0ROthOJ9pd
         zwzEntDzeUxp1sBlL97EiSz3YSyCV++f9YAkewdY276eaITQSDalswMx4qrHVoA/mC
         C1qLf4ZdqRbqdhx8a/ntHPb5OSTIdjtVcWA5jYYWQ/IsSAH4srlB4oyv2j64haMv+0
         fn3N/g+oZLXD4jU+3vGdbHONPyXgU3FykBPp97wSg85tUPqtk0zWe/wCzkNirELgFz
         J6VhIEFegbUJA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CF2A4C433EA; Tue, 26 Jul 2022 20:10:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 216283] FUZZ: BUG() triggered in
 fs/ext4/extent.c:ext4_ext_insert_extent() when mount and operate on crafted
 image
Date:   Tue, 26 Jul 2022 20:10:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216283-13602-csDiMX2CgW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216283-13602@https.bugzilla.kernel.org/>
References: <bug-216283-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216283

--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
If you are going to run some scripted tool to randomly
corrupt the filesystem to find failures, then you have an
ethical and moral responsibility to do some of the work to
narrow down and identify the cause of the failure, not just
throw them at someone to do all the work.

--D

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

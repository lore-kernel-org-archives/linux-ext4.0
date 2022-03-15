Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF99C433F5
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Mar 2022 11:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348094AbiCOL7G (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Mar 2022 07:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348095AbiCOL7E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2022 07:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284096350
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2022 04:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51DF614FC
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2022 11:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F901C340F7
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2022 11:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647345472;
        bh=7fjVcIIZJ/644SY5LCSFplSQdncQWkhFBxYX0YwQdUs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mEiH7Eq094eWlyF/kAT/Q9QXJSDQSLiK09M7xpdefvbilG6PSr0rcEwlMODt3Jtps
         gTNGe0UEHb/RHc9Kw1WsKF/7G7zirpwDDWd2mu016/AHDLuGbOxzBdFgFDj4l8NscO
         FlbMiKOBJvN4BC3Gd5MxFkWEW32DYh9Bj5qzMMcNtShVYnhPmFKHG2eaBP/8WBV6iG
         SVuacejO2YyCcJa5YLWEWsgcUN30GQovzVE1vfR4t7TNGs5xCDMEzkSIV4JdZ37m1x
         nzSYwVjrYhAicSkrhDqQoChpYrUq/APsPfvveremfc/CndfJMz+f88TakBc7WFwSn/
         OPlwEtQPlV0Gg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 170C1C05FCE; Tue, 15 Mar 2022 11:57:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 215676] fanotify Ignoring/Excluding a Directory not working
 with FAN_MARK_MOUNT
Date:   Tue, 15 Mar 2022 11:57:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: VFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: jack@suse.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_vfs@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc component assigned_to
Message-ID: <bug-215676-13602-IGIg66NAIs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215676-13602@https.bugzilla.kernel.org/>
References: <bug-215676-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215676

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
          Component|ext4                        |VFS
           Assignee|fs_ext4@kernel-bugs.osdl.or |fs_vfs@kernel-bugs.osdl.org
                   |g                           |

--- Comment #1 from Jan Kara (jack@suse.cz) ---
This is the expected behavior, although there are workarounds and possible
future improvements. More details in the email thread here:

https://lore.kernel.org/all/CAOQ4uxiDubhONM3w502anndtbqy73q_Kt5bOQ07zbATb8n=
dvVA@mail.gmail.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50177C4321E
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Dec 2022 09:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiLEJUX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Dec 2022 04:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiLEJTp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2022 04:19:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F7E1275C
        for <linux-ext4@vger.kernel.org>; Mon,  5 Dec 2022 01:19:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5573C60FE3
        for <linux-ext4@vger.kernel.org>; Mon,  5 Dec 2022 09:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE80BC433D7
        for <linux-ext4@vger.kernel.org>; Mon,  5 Dec 2022 09:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670231983;
        bh=nxu4Xv9Lok30T9yv8kx2jVCIuVyfN26ovjmhUQ/AjBE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jfd+Dcazhn5xyBQ8BgPNIbqgWHgd+zBv2N/nBUPyQDb5M/miDvxkR24jTcUqgeV/5
         u8rc4gQkzNEluHgGkMTxaSr+jcWzFh60//CLEUg27YKxyhG32xsUkXp3rL0voCmOHu
         BSF4VnOt175uS1MGz1Su6cIH9eDAVazWvl/oQYZnHmEDhifkRy+6Eyd2Y+YDsZBfze
         93r9vDT/m2q3XtfwrWzrknSMmCR1N83+L+M/bVf3dR7N1Q5wHtB1qxagrGgDxO9RKh
         JrE1FZow1SO5Pyk2FkD9Jxavos3XTXJmUM+fX7QmxM66+SDnIOSDv4IMZEH+FUpmmG
         4Znip5E43XglA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B03ACC433E7; Mon,  5 Dec 2022 09:19:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 216775] fanotify reports parent PPID insted of PID for
 FAN_MODIFY events
Date:   Mon, 05 Dec 2022 09:19:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: saikiran.gummaraj@icloud.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216775-13602-4i6P5TmRfR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216775-13602@https.bugzilla.kernel.org/>
References: <bug-216775-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216775

opcoder0 (saikiran.gummaraj@icloud.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #3 from opcoder0 (saikiran.gummaraj@icloud.com) ---
Test issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

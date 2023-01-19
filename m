Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B64C46467
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Jan 2023 18:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjASS0j (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 Jan 2023 13:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjASS0i (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2023 13:26:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B71690B36
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jan 2023 10:26:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 396BD61D01
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jan 2023 18:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A03F0C433F0
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jan 2023 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674152796;
        bh=f2ukKN7G7qwSw52DAEz7wACRFTtlXLFhJoHFWktEL0o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Oz2t63zITyNDzrMB8SWYOxqopPFrIXpAea8ey85Dw0gUq59XX6lsIAHqCNTU1xybp
         e3pf7BdARO68YARoHZqID3PtFOhkcbCtCKyvx+x3oqBVz2lE3zVayXhqDTWbHAlLBZ
         ynDLzc/ukSwRF1RModhmrIF7lo0XJgZnRfAIwKKDMstrvJD7gTJ3UgiQgO/rk9yuKs
         49tXeaOkRbTW52NfntqlWkKvVp0ZxzDyZJPMRQC6i8luKsGV9tPzkcSWDeDuO40hER
         XEw+SyUe2ssC/IkryUq0smkx/E3bHUluUexCfLuItJiVFO/Lk5TOfsKy5g0qTzpmQ2
         tS6Tt66p0KGCg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 917F7C43143; Thu, 19 Jan 2023 18:26:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 216953] BUG: kernel NULL pointer dereference, address:
 0000000000000008
Date:   Thu, 19 Jan 2023 18:26:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: gjunk2@sapience.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216953-13602-9sWUD33uuk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216953-13602@https.bugzilla.kernel.org/>
References: <bug-216953-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216953

--- Comment #2 from Gene (gjunk2@sapience.com) ---
Created attachment 303629
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303629&action=3Dedit
crash log

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

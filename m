Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0CCC433EF
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Mar 2022 12:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347388AbiCUMdj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344466AbiCUMdi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2022 08:33:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E878909D
        for <linux-ext4@vger.kernel.org>; Mon, 21 Mar 2022 05:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1078B8136B
        for <linux-ext4@vger.kernel.org>; Mon, 21 Mar 2022 12:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D0F8C340F4
        for <linux-ext4@vger.kernel.org>; Mon, 21 Mar 2022 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647865928;
        bh=O1bMAGrTHioErVj57bfX5ZI3+4hOJMhZk5mi8ASUbiU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VUwMJ8kFVEwJK4/nSX8XebJzdB4SsI/k4rq4zyYJNzsZrmUly//ucvrn21FyEaPt1
         28FTh/yoDO9bNYBqE2gA5Ir99G/yMpvXm234mMhtEWRynC0U/YnzedL40ItXIE799H
         IeNK+QrJtQo8cftPPZyNQcWBH+lWlqiecN7hbhFZV4rf5FiPDFN1BcQ5X/UdtDfVYj
         PxL8GiYLHUeEkeQ0vxYS/H7JNRcUskCXUXP297uKzv3GF+QUAwbwgC0b69m+wPftVE
         aPW4LlJuS0nQTUUAzZIy36OY3q6nQN6o7dtz0XkGn/+zv7V6a+GXhPn9lNiJcanb5S
         dGqJ1VsjgiSNw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 34A5FC05FE2; Mon, 21 Mar 2022 12:32:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 215712] kernel deadlocks while mounting the image
Date:   Mon, 21 Mar 2022 12:32:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215712-13602-WZBAr9uLZu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215712-13602@https.bugzilla.kernel.org/>
References: <bug-215712-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215712

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
(In reply to bughunter from comment #0)
> I have created an image with mkfs.ext4, and modified some of the metadata=
 of
> the image. Unfortunately, when I tried to mount the image with a loop
> device, the kernel deadlocked. I have attempted many ways to stop the mou=
nt
> process, even executed a 'kill' command, but they are failed, only what I
> can do is to reboot the system. Can anyone tell me why the kernel
> deadlocked, and how can I fix this problem?

That's a bug in the kernel, this situation shouldn't happen. Hopefully some=
one
will debug and fix this.

In the meanwhile it would be great if you confirmed that 5.17 is also affec=
ted.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

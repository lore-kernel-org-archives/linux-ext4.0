Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927B8C54EBE
	for <linux-ext4@archiver.kernel.org>; Sat,  7 Jan 2023 09:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjAGJ1Z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 7 Jan 2023 04:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjAGJ1Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jan 2023 04:27:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9306CE5A
        for <linux-ext4@vger.kernel.org>; Sat,  7 Jan 2023 01:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DACF660A23
        for <linux-ext4@vger.kernel.org>; Sat,  7 Jan 2023 09:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F78BC433F0
        for <linux-ext4@vger.kernel.org>; Sat,  7 Jan 2023 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673083641;
        bh=rAtPejGe4lcvhUZwT67RFy7k5yMRyaX5928x5pUlpu4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=o/UsZ731fEwH5xrJbOWdRAYu9na3hJAB3VNrYoomNaH79TdcEL9nzVU4uX0tTl9CE
         +SGLq6OdZipMml3E4WnWOBd3sBkEwPlblvTrvYB0vXkUhHhdQJiU9RZTqdv37qVQbC
         n5rkYhw8NV6kmx8QG77jc+dlRHu9HSzeISZ9NorvWjwf73Djh0K3KaIBUHO5+f0Smx
         P5tX1grO3pJkl/dVYAJl6zqdR8A+fzjIYrBXbJbjuIvtaF9MzZphf5uBYYQkAuwPJV
         qhRGN24mW9Z/fEVqz7XkVZD9hKtYHB2AxWDb+BuSywtqAYji6GiraIBYf4HDF+rEdk
         HSl/2LUXJWlgQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3F5A4C43143; Sat,  7 Jan 2023 09:27:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 216898] jbd2: Data missing when reusing bh which is ready to be
 checkpointed
Date:   Sat, 07 Jan 2023 09:27:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chengzhihao1@huawei.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216898-13602-BcLF9SC9UB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216898-13602@https.bugzilla.kernel.org/>
References: <bug-216898-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216898

--- Comment #2 from Zhihao Cheng (chengzhihao1@huawei.com) ---
Created attachment 303545
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303545&action=3Dedit
a.c

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

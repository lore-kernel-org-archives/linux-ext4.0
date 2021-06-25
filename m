Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04D4C2B9F4
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jun 2021 04:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C7161410
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jun 2021 04:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhFYEjk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jun 2021 00:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhFYEjk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jun 2021 00:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1601061410
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jun 2021 04:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624595840;
        bh=Er4H1w9DUqwH1lytk838lyTxKPs4Nxu+HfejhB7pH10=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sbjzJoChEQAdohVEVy5umO51d4GJJuCaxPuYMByT8sMUX2h4MOlHs4GWAuzlXAdp0
         57CmUEv0YSNHr6hSYieY/NasQOrFcT1Fh+cw+Dm9WuJ5Fj/eq8gAFqUjC6kkkfOAci
         xB65N9vcCuc4BjmahlBuVWCacGN6Md0rYuH2n4GGVw5ssX3pKFtZ77QaAe2PrGefo9
         MpCnNX13+n+MVzcKweK0obZ155KZsjwVut6KccLRF/NTMaLoO9hz1gDMyoJ0HUTiXS
         M6KbmI3Y0T4Hy634L3SkyyQi7L0eNkV9XP40u/l6Worpk6TtUJAtl6FNqIJXX7KvB0
         dVNp64AAVirdg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 213539] KASAN: use-after-free Write in ext4_put_super
Date:   Fri, 25 Jun 2021 04:37:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: 6201613047@stu.jiangnan.edu.cn
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213539-13602-N4LfiQtzkU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213539-13602@https.bugzilla.kernel.org/>
References: <bug-213539-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213539

--- Comment #2 from 6201613047@stu.jiangnan.edu.cn ---
This bug can be repro, if you need it, please tell me.
Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

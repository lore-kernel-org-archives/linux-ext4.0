Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0462CCDB47E
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Oct 2023 22:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376524AbjJKWYD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 11 Oct 2023 18:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376533AbjJKWYB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Oct 2023 18:24:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236FCC6
        for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2023 15:23:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EE61C433C8
        for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2023 22:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697063038;
        bh=kq2Di3ShC5ppxJS1fJ4d6FyRlIV7bHcYgsyA2/vz1Uo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=q8VQU0OOt+bGw6c+D+nUDco7CbCaaykLP9TBPX4jib2+MrnMJZPA9vLxqRljV5uUX
         XbGxzLr70k2oSh8Er2qWG4Xk1HfNj5CE8HoAqAbOUyjs1UDzUNDIW/jFmS7WAPw2gr
         BsfIuo34TOkmAfB9xodUjiozdACjsCblZjq54rVg/ui+8srl0tvqsoFT+woy/xsT0R
         h3grMqlv5kSGLu/ecE4L3OgsPsG6D3jZgiInIQQPcmnjMw6kQiQ4r4weGlqm4v4F4i
         /3IqfCqrQOeUGLo4tawLcw5SpySwcyvNZodAQUHheqLDo+mE7Vqm1t11kSGw1VlOkg
         TdmecTCbMOPFw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 75F33C53BD0; Wed, 11 Oct 2023 22:23:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 217965] ext4(?) regression since 6.5.0 on sata hdd
Date:   Wed, 11 Oct 2023 22:23:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: iivanich@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217965-13602-eyveZU0VEG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217965-13602@https.bugzilla.kernel.org/>
References: <bug-217965-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217965

--- Comment #14 from Ivan Ivanich (iivanich@gmail.com) ---
Not affected 6.4.16:
iostat: https://pastebin.com/6XadeAuh
perf:
https://drive.google.com/file/d/1neAq73hoztfTU87NyCHWGAQhCKQfILOH/view?usp=
=3Dsharing
backtrace: https://pastebin.com/zdnWgx4M
uname -a:
Linux gentoo-desktop 6.4.16-gentoo-x86_64 #1 SMP PREEMPT_DYNAMIC Thu Oct 12
00:09:02 EEST 2023 x86_64 Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz GenuineI=
ntel
GNU/Linux

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0650C352A1
	for <linux-ext4@archiver.kernel.org>; Wed,  7 Dec 2022 09:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiLGJU4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 7 Dec 2022 04:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGJUz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2022 04:20:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC762F8
        for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2022 01:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3B21B815F6
        for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2022 09:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2DEFC433D6
        for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2022 09:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670404851;
        bh=eWHT9UH24/MV4aYcDOkRBAYATyEFLZtPYlFOteLp1UA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GkVnkX+CdGKD42qtk53TWJyUYeNNrGcee9feHB2cQ1PCHKnjEAp4aoxVtZJKUw512
         hrG2Bsewwby/EJLnY7S1udX35/aZFec1xPRpK08C8jWV9j2raIJW7NJg7j/lXqhm4p
         CKNUlmVbogGgIgBJvYI02U5Q3W8MnN5CJvMwfrixNGusHbikJaMMhYS9VDH9CW3Dlr
         iHqH5Rn+PcnQwsebEdlY+JIRD7rHKwmRrBOnHQJJXyEb9f68yVAVSaQogyBYYk0VWk
         iwmdV8CpQo2vtfUB/AlC0IoImCEJzqLBXZrhgi3ei534oHcARUWMjHRdXje5u6LBVC
         z5rMwiPHKioIg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8C857C433E9; Wed,  7 Dec 2022 09:20:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 216783] There is "ext4_xattr_block_set" WARNING in v6.1-rc8
 guest kernel
Date:   Wed, 07 Dec 2022 09:20:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216783-13602-9G07BC4DAI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216783-13602@https.bugzilla.kernel.org/>
References: <bug-216783-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216783

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

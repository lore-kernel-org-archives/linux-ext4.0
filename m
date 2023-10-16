Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F0CCDB465
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Oct 2023 08:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbjJPIoQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 16 Oct 2023 04:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjJPIoQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Oct 2023 04:44:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0E7A1
        for <linux-ext4@vger.kernel.org>; Mon, 16 Oct 2023 01:44:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A951C433C7
        for <linux-ext4@vger.kernel.org>; Mon, 16 Oct 2023 08:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697445853;
        bh=A6Lg8yxVAH+UyD7l0d1U8jbqHagXlAR6MTsqZ/+D1oU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AaBi3RQHIziztmrhs9pGDlogKvRZ4ObVRSQCQdvAmsw/EQGjGnc38cSOVMRiDWMVL
         PSrNjUJmiJhWd+pcBDHZvV91sB1WkqBaQpY1sonmGV4eQT4WoGHPvs0stAVKhBmp8t
         I1OWqoaf1OJTFbXIiDCz7dDjT4EFrslPHaidEnoUkObBvPJfWq1Xx+VzTlDtAL41L9
         Z19T4w29dBDKHAjK2RZu0v96WfJ0Wl/PTj6HO5PwtxQQ4AmUWTiZipjqnqRJNFd8+/
         KkMQ12orgzMOW5F9MXv8RY3QsNk9T1kSz86rMAPQeXNYZ4to6YMusZOt+ZlIlQ0EgU
         y9dP+MSHyk7QA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 36966C53BD0; Mon, 16 Oct 2023 08:44:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 218006] [ext4] system panic when ext4_writepages:2918: Journal
 has aborted
Date:   Mon, 16 Oct 2023 08:44:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: fengchunguo@126.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218006-13602-omOhos7JXV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218006-13602@https.bugzilla.kernel.org/>
References: <bug-218006-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218006

--- Comment #5 from Gary (fengchunguo@126.com) ---
Created attachment 305227
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305227&action=3Dedit
fs/ext4 code

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

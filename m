Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83516C64EC4
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Mar 2023 12:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCJMi5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 10 Mar 2023 07:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjCJMir (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Mar 2023 07:38:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF8CD2909
        for <linux-ext4@vger.kernel.org>; Fri, 10 Mar 2023 04:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BFEBB82288
        for <linux-ext4@vger.kernel.org>; Fri, 10 Mar 2023 12:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39F92C4339B
        for <linux-ext4@vger.kernel.org>; Fri, 10 Mar 2023 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678451923;
        bh=BU8AdevWDBsbPN9YQQ9sIRJpAv6YWL5sPP/Qi5t7YnI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LNZXgi+oKSCIrNjxBFLHso6+1AaV5+vly8l4oce59kY7K39NnSj86qjWhRfquxZIm
         NYczBzVmtMPx4VjY291c7MrylRgtqIpaneIlAz08i7q75kJEYsKT6tUXBUtx2Wi/A4
         oTEVtpTOyfb/32gch3N72hb+KHoq/GBUNAzG3mEHzDNL1S1dvBR3c6NWYtsObs9yrO
         QPIOzjt48RjidXoSuyDWtew8FJ7Q/KqqrGudmw3gx7tzXwOnsBbXPpHefoYxH5y13U
         2WWMGOcklkaqGKIxanAmGE/W4hGdhU/4JZGzGwIl+Lld3iIeFrMaT6XG5WFKu5GtQx
         uMKd3JqeRsbhQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2B134C43143; Fri, 10 Mar 2023 12:38:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 217171] ext4: stale buffer loading from last failed mounting
Date:   Fri, 10 Mar 2023 12:38:42 +0000
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
Message-ID: <bug-217171-13602-njvWVpZhVR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217171-13602@https.bugzilla.kernel.org/>
References: <bug-217171-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217171

--- Comment #2 from Zhihao Cheng (chengzhihao1@huawei.com) ---
Created attachment 303917
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303917&action=3Dedit
test.sh

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

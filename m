Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A40EC77B73
	for <linux-ext4@archiver.kernel.org>; Fri, 26 May 2023 12:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243529AbjEZM4I (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 May 2023 08:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbjEZM4E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 26 May 2023 08:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B6BE6B
        for <linux-ext4@vger.kernel.org>; Fri, 26 May 2023 05:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FFB164FB6
        for <linux-ext4@vger.kernel.org>; Fri, 26 May 2023 12:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F788C4339B
        for <linux-ext4@vger.kernel.org>; Fri, 26 May 2023 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685105743;
        bh=wqoMRy/vSB1+4Y3vMRBy84lDz4O4FqKAr3sv0v7Y7iI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=e41ZHY7nPbIIR5Xu9M+5vEPBnpZXXWXTLA+wN0roOVwMd2zD0l8DWgA/u+WLt+fLG
         wuDbH4V1J8JZQ07Xp41FkY6OLF62OMFk++oWIbMOcVpksL6H/3SflkdjqrooH4D38e
         vw2MB4AVFMJJES0eC90tey4Pj2IRR+0JILHjpeWW0C90Fb0DzyqGnDq4SoK/amlk+b
         LykyMSbyTNAFnR35mTesBNCW2ReUE8ALckmAIxFHEfepD6V+vb3TGe/Li3JmvC+PLZ
         Tg23MAY5MpUwiEurOBsryoH/U9uRv7MxiOaquiS78O60nY+H3HWJnTMoxPJNSaDmYn
         0bBj/KoUWpoJg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 80C1AC43143; Fri, 26 May 2023 12:55:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 217490] Wrongly judgement for buffer head removing
Date:   Fri, 26 May 2023 12:55:43 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217490-13602-wLkVHb5oDe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217490-13602@https.bugzilla.kernel.org/>
References: <bug-217490-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217490

--- Comment #6 from Zhihao Cheng (chengzhihao1@huawei.com) ---
Created attachment 304332
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304332&action=3Dedit
test_3.sh

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

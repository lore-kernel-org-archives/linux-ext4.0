Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26FCC433F5
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Mar 2022 12:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346238AbiCXMsI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Mar 2022 08:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350337AbiCXMr7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Mar 2022 08:47:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62CEA9974
        for <linux-ext4@vger.kernel.org>; Thu, 24 Mar 2022 05:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C4760DE7
        for <linux-ext4@vger.kernel.org>; Thu, 24 Mar 2022 12:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8F9EC340ED
        for <linux-ext4@vger.kernel.org>; Thu, 24 Mar 2022 12:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648125986;
        bh=XwgaoYQ/w/up7nrdIC0/7cdxHQUUdWdBpGYAGypbXhQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rXxO7neKQjc1lGx68TvkxzGF6WMiUNcoEZaXKY7VYH/O6aSgda3oBdoOZ4b2OKFg3
         1nNmQhxFWVkc0p+UJKSd+jmWnGHAoOt2TB7lIqS6NiqQWI7wMsFFxCoqZ3b0tFiS8c
         r3I9C84tRUAa91RYVhZD7AsdXHC8OkJAYJLFcc/iJU+5sAzbutrg3XCJywbKvbbCNh
         vyJ8+WXHIhSp9Qu8wK3n0yfLHnJDqunE0Dj9BcXRvUIUujsAXWIF38pSH3L7KkIqF2
         yA4m5OsMbhd/E/xW275mpvCKZxLdA1llPdmwzABTAPnDXtZzRNSkJUaI+kTDD0KtQ4
         avu4E2RU6QwRw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A642ACAC6E2; Thu, 24 Mar 2022 12:46:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 215712] kernel deadlocks while mounting the image
Date:   Thu, 24 Mar 2022 12:46:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yanming@tju.edu.cn
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215712-13602-T1Adr5sx8D@https.bugzilla.kernel.org/>
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

--- Comment #6 from bughunter (yanming@tju.edu.cn) ---
Why does the 'mount' command take so long when using such a small image?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7394EB64DA
	for <linux-ext4@archiver.kernel.org>; Wed, 28 Jun 2023 13:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjF1NU0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 28 Jun 2023 09:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjF1NUC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jun 2023 09:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BADFC
        for <linux-ext4@vger.kernel.org>; Wed, 28 Jun 2023 06:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DEB96131A
        for <linux-ext4@vger.kernel.org>; Wed, 28 Jun 2023 13:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95B8AC433C9
        for <linux-ext4@vger.kernel.org>; Wed, 28 Jun 2023 13:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687958400;
        bh=jLczwUpqE+uZC/azBnm9N6Rx4Q+9fJLmwxRUYAgqlWk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ROiUx8WiMlCqGSd2blomNjQn9IrGSohPMX4+q/0gHAUY7b0qx5kaz/plz8sgF/adA
         43s/3kUDfMv7uwAddu0B95IePV6Joic1fSvM2YqrTLDAbB1HZGc4yo7Vv5Yh79xRiT
         CNwKHTCLG7TUZ8WcxEXlhgR5JsaKIgDBdWayRn8K3jaXg8T3L9vGJh9GXFK2voyuzM
         whdutmZo3cv84yxTZahO2o+xa8UxEaXdJD/T/QCpONGsT4GECHg0xxm1LQe7PnrCe/
         jIB3ZwtcYxFgCozclpsHHXZzWSS/C9Qvtlwx4w0lzlU8wpmem6KH19YK9ZX8hchArC
         EYzN/aWGWL9cg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 865BCC53BC6; Wed, 28 Jun 2023 13:20:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 217605] unttached inode after power cut with orphan file
 feature enabled
Date:   Wed, 28 Jun 2023 13:20:00 +0000
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
Message-ID: <bug-217605-13602-E8F0Lh75SW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217605-13602@https.bugzilla.kernel.org/>
References: <bug-217605-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217605

--- Comment #2 from Zhihao Cheng (chengzhihao1@huawei.com) ---
Created attachment 304497
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304497&action=3Dedit
diff

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

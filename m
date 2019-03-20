Return-Path: <SRS0=eYnO=RX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F03C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 00:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B39B20828
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 00:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfCTAXz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Mar 2019 20:23:55 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38608 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbfCTAXz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Mar 2019 20:23:55 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0545729911
        for <linux-ext4@vger.kernel.org>; Wed, 20 Mar 2019 00:23:55 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id EDC512992E; Wed, 20 Mar 2019 00:23:54 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202897] BUG: unable to handle kernel paging request at
 __memmove
Date:   Wed, 20 Mar 2019 00:23:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: 389387252@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-202897-13602-hcLvm7U5fI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202897-13602@https.bugzilla.kernel.org/>
References: <bug-202897-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202897

--- Comment #4 from phoonchiang (389387252@qq.com) ---
The following patch can fix this bug, but i'm not sure it is the best way 
to fix it.


diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 86ed9c6..fd2ebba 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1695,7 +1695,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info
*i,

        /* No failures allowed past this point. */

-       if (!s->not_found && here->e_value_size && here->e_value_offs) {
+       if (!s->not_found && here->e_value_size && here->e_value_offs &&
!here->e_value_inum) {
                /* Remove the old value. */
                void *first_val = s->base + min_offs;
                size_t offs = le16_to_cpu(here->e_value_offs);

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAE5C56202
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Nov 2020 20:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2902221D7F
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Nov 2020 20:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgKMUKV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 13 Nov 2020 15:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgKMUKV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 13 Nov 2020 15:10:21 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 210185] kernel BUG at fs/ext4/page-io.c:126!
Date:   Fri, 13 Nov 2020 20:10:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: enbyamy@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-210185-13602-ebKRR1LdC2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210185-13602@https.bugzilla.kernel.org/>
References: <bug-210185-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210185

Amy (enbyamy@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |enbyamy@gmail.com

--- Comment #1 from Amy (enbyamy@gmail.com) ---
Hey there!

Traced back that file. That line runs page_buffers(), which launches a bug if
PagePrivate is false. 

#define page_buffers(page)                                      \
        ({                                                      \
                BUG_ON(!PagePrivate(page));                     \
                ((struct buffer_head *)page_private(page));     \
        })

What application were you running, if I may ask?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=nvKl=4I=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21804C11D0C
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Feb 2020 17:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9CAD208E4
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Feb 2020 17:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBTRSj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgBTRSj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Feb 2020 12:18:39 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 206613] On hitting tab key from terminal against a directory
 name ending with ':\' doesnot shows files/dir inside it
Date:   Thu, 20 Feb 2020 17:18:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: cubonix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-206613-13602-sx9cZnTNuJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206613-13602@https.bugzilla.kernel.org/>
References: <bug-206613-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206613

Abhishek Srivastava (cubonix@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|On hitting tab key from     |On hitting tab key from
                   |terminal against a          |terminal against a
                   |directory name ending with  |directory name ending with
                   |':\' doesnot shows          |':\' doesnot shows
                   |files/dir inside it rather  |files/dir inside it
                   |shows dir name itself       |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

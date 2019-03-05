Return-Path: <SRS0=D5Fw=RI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63FBC43381
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 13:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8859620842
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 13:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfCENOI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:14:08 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43778 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728294AbfCENOI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Mar 2019 08:14:08 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 76E462C07D
        for <linux-ext4@vger.kernel.org>; Tue,  5 Mar 2019 13:14:07 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 6AF2A2C01E; Tue,  5 Mar 2019 13:14:07 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202771] New: Malformed file name generates some issues.
Date:   Tue, 05 Mar 2019 13:14:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: addammo@tiscali.it
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-202771-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202771

            Bug ID: 202771
           Summary: Malformed file name generates some issues.
           Product: File System
           Version: 2.5
    Kernel Version: 4.18.6-1~bpo9+1 (Debian stretch)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: addammo@tiscali.it
        Regression: No

Created attachment 281511
  --> https://bugzilla.kernel.org/attachment.cgi?id=281511&action=edit
The file that causes the issue due to its name.

With the attached file I get some issues.

1) some program cannot properly recognize it, and cannot write any character
into it, such as vim.tiny and Geany.

2) Other programs such as JuffED can write into it, then I get two files. They
will always show the same content.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

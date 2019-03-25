Return-Path: <SRS0=eNh3=R4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC19C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 03:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D384220879
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 03:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfCYDk1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 24 Mar 2019 23:40:27 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37504 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729298AbfCYDk1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 24 Mar 2019 23:40:27 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E04F52923B
        for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2019 03:40:25 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id C2A3B29239; Mon, 25 Mar 2019 03:40:25 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202879] Segmentation fault while running crafted program
Date:   Mon, 25 Mar 2019 03:40:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-202879-13602-b5LULnlGRk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202879-13602@https.bugzilla.kernel.org/>
References: <bug-202879-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202879

--- Comment #8 from Theodore Tso (tytso@mit.edu) ---
Jungyeon,

One of the things you can do which would be helpful when creating a minimal
reproducer, is to fix some of the gratuitous corruptions in the file system
image, so we can be 100% sure which file sysutem corruption is combining with
your test syscall load to trigger the failure.

For example, both of these super block corruptions which cause e2fsck to stop
dead in its track because it views the superblock as being too compromised for
automated machine assumptions to be safe are probably things we can clear and
still have ext4-combined dump core:

% e2fsck -fy /tmp/tmp.img 
e2fsck 1.45.0 (6-Mar-2019)
Found invalid V2 journal superblock fields (from V1 journal).
Clearing fields beyond the V1 journal superblock...

Corruption found in superblock.  (desc_size = 33667).

E2fsck fixed up the first problem automatically, and the second I could fix up
using debugfs: debugfs -w -R "ssv s_desc_size 64" /tmp/tmp.img

I'm suspect that root cause is that the block allocation bitmap has a block
which is also used by the journal as being free.   And if that block gets
reallocated so that a directory block (which, being metadata is accessed via a
buffer head) overlaps with the journal block, I can imagine all sorts of
hilarity enusing.   

I will attach a proposed patch which should detect this case, and block the
reuse of a block belonging to the journal.   Can you try applying this patch to
your LKL ext4-combined program, and see if it traps the file system corruption
early enough that core dump doesn't get triggered?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

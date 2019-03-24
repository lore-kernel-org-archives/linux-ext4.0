Return-Path: <SRS0=L97M=R3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2E3C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 24 Mar 2019 05:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94E7721741
	for <linux-ext4@archiver.kernel.org>; Sun, 24 Mar 2019 05:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfCXF2n convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 24 Mar 2019 01:28:43 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47760 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbfCXF2m (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 24 Mar 2019 01:28:42 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6449F29AD5
        for <linux-ext4@vger.kernel.org>; Sun, 24 Mar 2019 05:28:41 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 5416429AD9; Sun, 24 Mar 2019 05:28:41 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202897] BUG: unable to handle kernel paging request at
 __memmove
Date:   Sun, 24 Mar 2019 05:28:40 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202897-13602-8IXBluNGKu@https.bugzilla.kernel.org/>
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

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #6 from Theodore Tso (tytso@mit.edu) ---
The patch in #4 looks closer to the right thing.  In fact, this should do:

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index dc82e7757f67..491f9ee4040e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1696,7 +1696,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info
*i,

        /* No failures allowed past this point. */

-       if (!s->not_found && here->e_value_size && here->e_value_offs) {
+       if (!s->not_found && here->e_value_size && !here->e_value_inum) {
                /* Remove the old value. */
                void *first_val = s->base + min_offs;
                size_t offs = le16_to_cpu(here->e_value_offs);


That's because if e_value_inum==0, then here->e_value_offs is guaranteed to be
non-zero --- otherwise it would have failed a check in earlier in
ext4_xattr_check_entries().  In the case where e_value_inum !=0,
here->e_value_offs must be zero.  We're currently however, not checking it both
in the kernel and in e2fsck.  We're just ignoring in all other cases when
!e_value_inum.   Why we're ignoring e_value_offs and not doing a check I'm not
sure.  I want to dig back through some older e-mail discussions and see if I
can get the original developer who did ea_inode feature to see if he knows of
some reason why we're not enforcing that check.    My preference would be to
enforce that check and fail the inode as corrupt, but there may be something
I'm missing. 

There are also a large number of other tests which we're not enforcing in the
kernel that I'm strongly considering adding.   The root inode is being used as
a ea_inode value --- and that should have been rejected, except the
EXT4_EA_INODE_FL flag was set on inode #2.   But in that case, we probably
should reject all files that are reachable from the name space (e.g., all
directories, regular files, etc.) that have EXT4_EA_INODE_FL; that should never
happen.   If we did that, the file system would have never successfully
mounted, so we wouldn't have tripped this particular memmove case.   Which is
good in production, but it does make it harder for fuzzers to find legitimate
real bugs, since we block them much earlier in the process.    In this
particular case, the fact that we have e_value_inum pointing at a root
directory is not the reason why we BUG'ed on the memmove.  It's because
e_value_offs was non-zero when e_value_inum was also non-zero, and that's not
supposed to ever happen.  

I should probably also make the kernel more strict about having both a journal
UUID and a journal inum set at the same time.  That's again one of those
"should never happen situations".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

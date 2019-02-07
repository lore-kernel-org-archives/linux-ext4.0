Return-Path: <SRS0=C+hA=QO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04888C282C2
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEF5F21872
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfBGL3T convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:29:19 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41196 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbfBGL3T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2019 06:29:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 612912A8D6
        for <linux-ext4@vger.kernel.org>; Thu,  7 Feb 2019 11:29:18 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 5596C2A862; Thu,  7 Feb 2019 11:29:18 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Thu, 07 Feb 2019 11:29:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aneesh.kumar@linux.ibm.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201631-13602-5o0owaje4n@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #73 from Aneesh Kumar KV (aneesh.kumar@linux.ibm.com) ---
(In reply to Jan Kara from comment #72)
> Just a suggestion to PPC maintainers / Aneesh: This bug can lead to data
> corruption (lost data written to a file) or potential security issues
> (writes to file user is no longer supposed to be able to write to) because
> it leads to PPC leaving writeably mapped pages behind. So since we are at
> -rc5 I think considering just reverting the patches and figuring out what's
> going on separately without exposing general users to these issues is a fair
> question... 
> 
> Note that the problem affects already 4.20 so -stable needs to be included
> regardless how you decide to solve these issues.

I understand the urgency. But we are still not able to work out why the revert
the change helps. Few things which are different from other commonly used
kernel configs are

1) 4K page size
2) Big endian kernel.

One thing we could do is just revert the definition of pud_present and
pgd_present. ( I already shared a patch to try that). If this helps, we could
take that to upstream. But that is still not the fix because we still don't
know who is clearing the top bit of the page table tree. This Level1 and Level2
entries are not modified in between. They are set during fault and cleared on
page table free.


Another debugging effort we could try is with little-endian config. Erhard, how
easy/difficult it will be you try a little-endian config?

All my effort to recreate this on my POWER9 system with 4k config has not been
successful. The difference here is I have a little-endian config.

-aneesh

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

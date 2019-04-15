Return-Path: <SRS0=3Woa=SR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84B9C10F0E
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 17:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A55A42073F
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 17:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfDORjr convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:39:47 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51154 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbfDORjq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 15 Apr 2019 13:39:46 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8DFA728741
        for <linux-ext4@vger.kernel.org>; Mon, 15 Apr 2019 17:39:46 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 82A7728861; Mon, 15 Apr 2019 17:39:46 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203319] [xfstests generic/538]: unaligned direct AIO find ext4
 corruption
Date:   Mon, 15 Apr 2019 17:39:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203319-13602-sVAcn3KhTG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203319-13602@https.bugzilla.kernel.org/>
References: <bug-203319-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203319

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
ppc64le(64k pagesize, 512b sector size) can reproduce this bug nearly 100%. I
just ran it 200 times on pcc64le, all failed[1]. But x86_64 can't trigger this
issue, even I use 1k block size ext4.

[1]
QA output created by 538
Data verification fails
Find corruption
00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
*
00000200  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
00002000
FAIL: [8704, 8192, 512, 0]
-------------------------------------------------
Silence is golden

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

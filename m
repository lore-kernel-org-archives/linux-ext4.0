Return-Path: <SRS0=Qk7k=Y4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B7DCA9EB5
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Nov 2019 14:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E86B821D7F
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Nov 2019 14:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfKDOzz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Nov 2019 09:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbfKDOzz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Nov 2019 09:55:55 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 205417] Files corruption ( fs/ext4/inode.c:3941
 ext4_set_page_dirty+0x3e/0x50 [ext4] )
Date:   Mon, 04 Nov 2019 14:55:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: the.dmol@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205417-13602-fv0MqfR1UO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205417-13602@https.bugzilla.kernel.org/>
References: <bug-205417-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205417

--- Comment #3 from Ivan Baidakou (the.dmol@gmail.com) ---
> So please also describe your hardware and storage configuration, and what
> distribution are you using.

I use void linux distribution. My notebook is HP Probook 450 G5 (
https://support.hp.com/gb-en/document/c05682645 ). 

> Also, is this a 5.3.8 upstream kernel which you compiled yourself or a
> distro-supplied kernel?   If you compiled it yourself, please also send the
> kernel config

I use my distro kernel. I think their patches/config can be found at 
https://github.com/void-linux/void-packages/tree/master/srcpkgs/linux5.3/

Also, please note, that the reported issue (at least the reported stack trace)
does not happen on 5.2.21 (again, shipped by void-linux). I currently us it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

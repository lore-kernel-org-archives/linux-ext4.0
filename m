Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37986 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbeLBL5Z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 06:57:25 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7C14A29F06
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 11:57:21 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 11:57:20 +0000
Message-ID: <bug-201685-13602-mz6qzh4KHo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #136 from carlphilippreh@gmail.com ---
(In reply to Rainer Fiebig from comment #132)
> (In reply to carlphilippreh from comment #129)
> > While I wasn't able to reproduce the bug for quite some time, it ended up
> > coming back. I'm currently running 4.19.6 and I see invalid metadata in
> > files that I have written using this version.
> 
> I think it could be helpful if you provided your .config(s) here.
> 
> And what kernel are you using: self-compiled/from your distribution (which)?
> If self-compiled: have you made changes to the .config?
> 
> The set-up of the boxes you mentioned in comment 5 seems just right to hunt
> this down. ;)

I'm configuring the kernels myself. Two things that I always enable and that
_might_ be related are:

CONFIG_BLK_WBT / CONFIG_BLK_WBT_MQ
and
CONFIG_CFQ_GROUP_IOSCHED

Maybe I can come up with a way to reproduce this bug more quickly. Writing a
lot of (small) files and then deleting them seems like a good way so far.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

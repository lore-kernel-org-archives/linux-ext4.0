Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41500 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbeKZTmq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 14:42:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B531029777
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 08:49:20 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 26 Nov 2018 08:49:20 +0000
Message-ID: <bug-201685-13602-JI0r0b7nPD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #48 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Jimmy.Jazz from comment #43)
> I do some bisecting on the linux-master git source.
> I'm at the kernel version 4.19.0-rc2-radeon-00922-gf48097d294-dirty
> currently. I hope that all the fscks didn't make my system immune to this
> issue :)

Great! Everyone who's had his share of bisecting knows to value you effort! ;)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

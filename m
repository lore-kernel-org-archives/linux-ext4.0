Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55452 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbeLCPZt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 10:25:49 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 654F52B4EC
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 15:25:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 15:25:46 +0000
Message-ID: <bug-201685-13602-eArWWrWNKx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #203 from Rainer Fiebig (jrf@mailbox.org) ---
#199
That it cannot be reproduced in VMs may still offer a clue, namely that it may
indeed have something to do with hardware and/or configuration.

In the end there has to be a discriminating factor between those systems that
have the problem and those that don't.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

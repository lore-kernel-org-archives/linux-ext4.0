Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60618 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726209AbeLAUh0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 15:37:26 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7AE3B2E808
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 09:25:21 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 09:25:21 +0000
Message-ID: <bug-201685-13602-UNKxiOiV1x@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #104 from Rainer Fiebig (jrf@mailbox.org) ---
#101 Both 4.19.x kernels (VM/real HW):

> grep DAX .config
# CONFIG_DAX is not set
# CONFIG_FS_DAX is not set

Both kernels did *not* have the problem.

This may explain why some see the problem and others don't.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

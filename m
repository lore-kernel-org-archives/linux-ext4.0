Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55104 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbeLDUZ1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 15:25:27 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 22B192C679
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 20:25:27 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 20:25:25 +0000
Message-ID: <bug-201685-13602-CD5DmLoEMp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #238 from Rainer Fiebig (jrf@mailbox.org) ---
#232
That you could see the errors so early and reliably really baffles me.

This very morning I *concurrently*
- ran Guenter's script for 30 minutes
- compiled a kernel
- did some file copying

with CONFIG_SCSI_MQ_DEFAULT=y and didn't see one error. 

But it is a Debian-8-VM, 1024 GB RAM and the two discs attached as SATA/SSD. I
guess you must have played around with the settings for a while - or did you
have the idea of limiting RAM and attaching the disc as IDE right from the
start? Anyway - great that you found this out!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

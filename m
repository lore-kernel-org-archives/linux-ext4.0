Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36216 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730549AbeKVWbB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 17:31:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 19AA82C503
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 11:51:57 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 11:51:56 +0000
Message-ID: <bug-201685-13602-YMs04YG4Er@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Henrique Rodrigues (henrique.rodrigues@ist.utl.pt) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |henrique.rodrigues@ist.utl.
                   |                            |pt

--- Comment #30 from Henrique Rodrigues (henrique.rodrigues@ist.utl.pt) ---
(In reply to Theodore Tso from comment #23)
> So from a personally very selfish perspective, I'm hoping someone who has
> already suffered corruption problems is willing to try either 4.19.3, or
> disabling CONFIG_SCSI_MQ_DEFAULT, or both, and report that they are no
> longer seeing problems, than my putting my own personal data at risk....

On a Ubuntu 18.10 machine I've upgraded to 4.19.0 and started getting these
corruption errors. Yesterday I've upgraded to 4.19.3 and was still getting
corrupted. 4.18 was fine. Unfortunately the latest corruption rendered the
operating system unbootable. I'm going to try and fix it tonight and then will
try to disable CONFIG_SCSI_MQ_DEFAULT and test.

I'm in a somewhat fortunate position since the data that I care about lives on
another disk with a different filesystem type, so the corruption on the root
filesystem is just annoying and not really that dangerous.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

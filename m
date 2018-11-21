Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53486 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727628AbeKVF0D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 00:26:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EC0A42C65E
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 18:50:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 18:50:33 +0000
Message-ID: <bug-201685-13602-A8ZOJICwwB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #19 from Jimmy.Jazz@gmx.net ---
(In reply to Theodore Tso from comment #11)

So perhaps this is a MQ specific bug?  

I checked old .config and I had CONFIG_SCSI_MQ_DEFAULT=y activated since
version 4.1.6.

MQ investigation will probably lead us to a dead end.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

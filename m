Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39978 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbeLEJGl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2018 04:06:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 96C2F2CCFB
        for <linux-ext4@vger.kernel.org>; Wed,  5 Dec 2018 09:06:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 05 Dec 2018 09:06:39 +0000
Message-ID: <bug-201685-13602-YsSVN9wzVh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #264 from Rafał Miłecki (zajec5@gmail.com) ---
Is this possible to avoid this bug by using some command line parameter or
setting some sysfs entry? Something I could use on my machines before the fix
get included in my distribution?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

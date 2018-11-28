Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57248 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbeK1QLE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 11:11:04 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1A7562CC8A
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 05:10:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 05:10:43 +0000
Message-ID: <bug-201685-13602-z0GSEXulA4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #60 from Theodore Tso (tytso@mit.edu) ---
Henrique -- what is dm-0?  How is it configured?   And are you using discard
(either the mount option, or fstrim)?   Thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43710 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbeLCDAx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 22:00:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 947D62A8ED
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 03:00:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 03:00:48 +0000
Message-ID: <bug-201685-13602-JxVT4Qfafr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #183 from Theodore Tso (tytso@mit.edu) ---
Eric, re #180, could you upload your .config file for your kernel and the
boot-command line?   I'm interested in particular what I/O scheduler you are
using.   And are you using the same .config and boot command line (and other
system configurations) on your other system where you were seeing the problem? 
Many thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

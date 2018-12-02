Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46408 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbeLBS5E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 13:57:04 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AC7A52A756
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 18:57:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 18:56:59 +0000
Message-ID: <bug-201685-13602-PSAlxUJwxH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #154 from James Courtier-Dutton (James@superbug.co.uk) ---
I have scanned all the comments. So far I have only seen 1 person who has this
problem and have also reported what hardware they have.
So, the sample size is statistically far too small to conclude that it is an
AMD or a INTEL only problem.
Is there anyone out there who sees this problem, and is running Intel hardware?
How many people are seeing this problem? Can they each post the output of
"lspci -vvv" and a dmesg showing the problem they have?

This appears to be a problem that is reported by an extremely small amount of
people.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

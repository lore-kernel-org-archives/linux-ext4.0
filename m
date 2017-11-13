From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Mon, 13 Nov 2017 17:27:41 +0000
Message-ID: <bug-151491-13602-LTgEPhjuNz@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51544 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753990AbdKMR1n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Nov 2017 12:27:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F0ABC28F36
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 17:27:42 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #7 from Betacentauri (betacentauri@arcor.de) ---
Created attachment 260631
  --> https://bugzilla.kernel.org/attachment.cgi?id=260631&action=edit
Test script

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

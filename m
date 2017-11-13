From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Mon, 13 Nov 2017 17:39:41 +0000
Message-ID: <bug-151491-13602-HPLdhJTkyP@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56016 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754138AbdKMRjn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Nov 2017 12:39:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AEEB328DA5
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 17:39:42 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #9 from Betacentauri (betacentauri@arcor.de) ---
Forgot to say that the script is for the kvm-xfstests environment. And the
output already shows the output of that environment.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

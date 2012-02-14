From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Tue, 14 Feb 2012 05:07:40 GMT
Message-ID: <201202140507.q1E57eDi004645@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:55915 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2BNFHl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Feb 2012 00:07:41 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1E57ekS004646
	for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2012 05:07:40 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #8 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-14 05:07:39 ---
I just discovered that one RAID drive has large and increasing SMART values for
Raw_Read_Error_Rate and Hardware_ECC_Recovered.

Apparently, any disk read errors are being recovered, since I'm not seeing any
errors in dmesg or /proc/mdstat - so I still think there's an ext4 problem
(though perhaps it takes a flooded queue and a very-slow-response disk to
trigger...)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

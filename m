From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 01:50:01 +0000
Message-ID: <bug-76261-13602-sUVTjLewx2@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53151 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbaEPBuF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 21:50:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C036A2039C
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 01:50:03 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 188D92038D
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 01:50:02 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #2 from kun.chen <kun.chen@mediatek.com> ---
You can refer this:
https://android.googlesource.com/platform/system/core/+/master/libcutils/android_reboot.c
During shutdown in android, it realy will goto emergency_remount() flow. 

And from the ksmg log, it seems ext4 writeback continued almost 15 seconds
after emergency_remount() completed. Not sure why still has so many writeback
occurs, even it used emergency_remount(), still has so many writeback occurs,
and takes so long time, this will lead to shutdown hang or delay

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

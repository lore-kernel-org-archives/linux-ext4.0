From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56821] an ext4 commit ee0906f causes weird disk hangs
Date: Fri, 19 Apr 2013 12:26:22 +0000 (UTC)
Message-ID: <20130419122622.563F511FADB@bugzilla.kernel.org>
References: <bug-56821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56182 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030220Ab3DSM0Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 08:26:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4ADAC2061E
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 12:26:24 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5802C20618
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 12:26:22 +0000 (UTC)
In-Reply-To: <bug-56821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56821





--- Comment #1 from Tommi Kyntola <kynde@ts.ray.fi>  2013-04-19 12:26:22 ---
Created an attachment (id=99311)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=99311)
the config used during the bisection

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

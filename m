From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Wed, 10 Oct 2012 09:36:28 +0000 (UTC)
Message-ID: <20121010093628.7E14411FB04@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab2JJJgf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Oct 2012 05:36:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4BCAA20395
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2012 09:36:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 86D8C20388
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2012 09:36:33 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #13 from Elmar Stellnberger <estellnb@elstel.org>  2012-10-10 09:36:28 ---
Oops; my fault; have overlooked the response:

> The 480GB Extreme SSD drive has to be aligned to 8K. It cannot be aligned to 
> smaller blocks, i.e. 4K. This issue will be addressed in the new firmware 
> release, however, we cannot announce any specific time frame regarding when 
> this release is going to happen.
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

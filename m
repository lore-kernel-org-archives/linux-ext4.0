From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60121] -next and -mm: kmemleak reports 6 leaks in ext4_mount
 paths
Date: Wed, 26 Jun 2013 05:32:33 +0000 (UTC)
Message-ID: <20130626053233.BF2DF11FECB@bugzilla.kernel.org>
References: <bug-60121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60917 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab3FZFch (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 01:32:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5DDB9201E6
	for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 05:32:36 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 62FCF201D6
	for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 05:32:34 +0000 (UTC)
In-Reply-To: <bug-60121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60121





--- Comment #1 from Dave Chinner <david@fromorbit.com>  2013-06-26 05:32:33 ---
On Tue, Jun 25, 2013 at 06:25:04PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=60121
> 
>            Summary: -next and -mm: kmemleak reports 6 leaks in ext4_mount
>                     paths
>            Product: File System
>            Version: 2.5
>     Kernel Version: v3.10-rc6-684-g9dcc58c
>           Platform: All
>         OS/Version: Linux
>               Tree: -mm
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext4
>         AssignedTo: fs_ext4@kernel-bugs.osdl.org
>         ReportedBy: jmesmon@gmail.com
>         Regression: Yes
> 
> 
> Created an attachment (id=106021)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=106021)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=106021)
> .config
> 
> In next-20130624, next-20130625 and mmotm (v3.10-rc6-684-g9dcc58c), kmemleak
> complains about some ext4_mount related allocations.

Has nothing to do with ext4, and fixes are already on the way to -mm
and -next. Thread here:

http://marc.info/?l=linux-fsdevel&m=137154854120579&w=2

Cheers,

Dave.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

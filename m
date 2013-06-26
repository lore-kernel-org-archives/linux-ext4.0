From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 60121] New: -next and -mm: kmemleak reports 6 leaks in
 ext4_mount paths
Date: Wed, 26 Jun 2013 15:32:28 +1000
Message-ID: <20130626053228.GH29376@dastard>
References: <bug-60121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58378 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab3FZFcc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 01:32:32 -0400
Content-Disposition: inline
In-Reply-To: <bug-60121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 25, 2013 at 06:25:04PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
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
Dave Chinner
david@fromorbit.com

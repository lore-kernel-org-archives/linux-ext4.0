From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32972] EXT4 causes corrupt BitTorrent downloads
Date: Mon, 11 Apr 2011 02:26:45 GMT
Message-ID: <201104110226.p3B2QjA8009978@demeter2.kernel.org>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:55308 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1DKC0p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2011 22:26:45 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p3B2QjZf009979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2011 02:26:45 GMT
In-Reply-To: <bug-32972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32972





--- Comment #5 from Feng Tang <feng.tang@intel.com>  2011-04-11 02:26:43 ---

> 
> Actually, I'm much more comfortable backing out commit 6de9843da
> entirely.  The above is *not* equivalent to what we had before ---
> consider the case where ext4_map_blocks returns !EXT4_MAP_MAPPED && 
> !EXT4_MAP_UNWRITTEN.
> 
> I don't *think* this should happen in the case where ext4_map_blocks
> returns a value > 0, but the fact that it's not obvious, means I'd
> much rather keep things the way that they are.  It's not like dropping
> the set_buffer_mapped(bh) was saving anything measurable anyway....
> 
>                         - Ted

Agree for the revert and sorry for the inconvenience brought by my patch. I
walked across the code when debugging a problem, and thought the patch can
clean the code a little :( 

Thanks,
Feng

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

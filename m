From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12672] lockdep warning when using ext4 on x86_64
Date: Thu, 12 Feb 2009 15:42:42 -0800 (PST)
Message-ID: <20090212234242.E42A1108041@picon.linux-foundation.org>
References: <bug-12672-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761713AbZBLXnE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 18:43:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CNghgv009435
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 15:42:44 -0800
In-Reply-To: <bug-12672-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12672





------- Comment #4 from tytso@mit.edu  2009-02-12 15:42 -------
On Mon, Feb 09, 2009 at 03:38:17PM +0530, Aneesh Kumar K.V wrote:
> 
> Updated patch
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Subject: [PATCH] ext4: Fix lockdep warning
> 
> We should not call ext4_mb_add_n_trim while holding alloc_semp.

Added to the ext4 patch queue.

                                        - Ted


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

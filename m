From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 12624] umount hangs after fsstress with data=journal
Date: Wed, 3 Jun 2009 17:51:39 -0400
Message-ID: <20090603215139.GO31943@mit.edu>
References: <bug-12624-13602@http.bugzilla.kernel.org/> <200905220651.n4M6ph5X017461@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45243 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZFCVvj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jun 2009 17:51:39 -0400
Content-Disposition: inline
In-Reply-To: <200905220651.n4M6ph5X017461@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2009 at 06:51:43AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> I guess we would need this patch. But i am still hitting the BUG_ON.
> Will try to debug further later today.
> 
> -aneesh
> 
> commit 85ddb1581222bac63035c16a6536b0a5a2cd60a0
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Thu May 21 23:58:17 2009 +0530
> 
>     ext4: Don't look at buffer_heads outside i_size.
> 
> 
>     Buffer heads outside i_size will be unmapped. So when we
>     are doing "walk_page_buffers" limit ourself to i_size.
> 
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

OK, added to the ext4 patch tree.

						- Ted

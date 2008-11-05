From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Patch collision: 64-bit quota changes and ext4 delalloc quota
 changs
Date: Wed, 5 Nov 2008 08:43:03 -0800
Message-ID: <20081105084303.ed0c53d5.akpm@linux-foundation.org>
References: <E1Kxkwt-0007Np-O4@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbYKEQnp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 11:43:45 -0500
In-Reply-To: <E1Kxkwt-0007Np-O4@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 05 Nov 2008 11:09:39 -0500 "Theodore Ts'o" <tytso@mit.edu> wrote:

> Hi,
> 
> Mingming has been working on some changes to support better support
> quotas when ext4's delayed allocation is enabled.  Unfortunately, they
> conflict with Jan's 64-bit quota changes.  The first two patches in
> mingming's series change core quota handling code; the last one is ext4
> specific.
> 
> Andrew has commented on the patches and I assume Mingming will be
> addressing his comments.  In the meantime, there is the question of
> where the patches should live while they cook.
> 
> Mingming has dropped her patches, followed by Jan's 64-bit quota
> patches, into the ext4 patch queue tree.  This was for her convenience,
> and also so she could modify Jan's patches so they would apply after
> making the changes she needed.  That makes sense, but it means that we
> have the quota patches in the ext4 tree, which isn't so great,
> especially if Jan wants/needs/plans to make any further changes.
> 
> Andrew has I see sucked up the Mingming's quota changes into the mm
> tree.  Given that 2 out of the 3 patches affect core code, that also
> makes sense, although the last patch is ext4 specific, and some changes
> to that patch might be needed as we make other changes to ext4.  (For
> example, my latest patch to reduce stack space on x86_64 systems by
> fixing inappropriate use of "unsigned long" required some minor fix ups
> to Mingming's last patch.
> 
> So what to do...  I *think* the thing which makes the most sense is for
> me to drop all of the quota related changes from the ext4 patch queue,
> since in reality 95% of the changes are are all outside of the ext4
> tree, and let Andrew carry the changes in -mm.  Mingming, if you like we
> can save the patches off to a subdirectory in the ext4 patch queue, and
> make it easier for you to do your development.
> 
> Does that make sense to everyone?
> 

It works for me.  I really need to get off my butt and get -mm into
linux-next.

I can merge ext4-quota-handling-for-delayed-allocation.patch if you
like, or you can merge it once te quota changes have gone in.


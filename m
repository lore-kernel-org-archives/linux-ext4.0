From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Wed, 17 Nov 2010 19:29:00 -0800
Message-ID: <20101117192900.da859ac7.akpm@linux-foundation.org>
References: <20101116110058.GA4298@amd>
	<20101116130146.GG4757@quack.suse.cz>
	<4CE35A6D.2040906@redhat.com>
	<20101117043845.GA3586@amd>
	<4CE362B0.6040607@redhat.com>
	<20101117061057.GA3989@amd>
	<20101118030613.GQ3290@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@kernel.dk>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab0KRDct (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Nov 2010 22:32:49 -0500
In-Reply-To: <20101118030613.GQ3290@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 17 Nov 2010 22:06:13 -0500 "Ted Ts'o" <tytso@mit.edu> wrote:

> On Wed, Nov 17, 2010 at 05:10:57PM +1100, Nick Piggin wrote:
> > On Tue, Nov 16, 2010 at 11:05:52PM -0600, Eric Sandeen wrote:
> > > On 11/16/10 10:38 PM, Nick Piggin wrote:
> > > >> as for the locking problems ... sorry about that!
> > > > 
> > > > That's no problem. So is that an ack? :)
> > > > 
> > > 
> > > I'd like to test it with the original case it was supposed to solve; will
> > > do that tomorrow.
> > 
> > OK, but it shouldn't make much difference, unless there is a lot of
> > strange activity happening on the sb (like mount / umount / remount /
> > freeze / etc).
> 
> This makes sense to me as well.
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> So how do we want to send this patch to Linus?  It's a writeback
> change, so through some mm tree?

It's in my todo pile.  Even though the patch sucks, but not as much as
its changelog does.  Am not particularly happy merging an alleged
bugfix where the bug is, and I quote, "I saw a lock order warning on
ext4 trigger".  I mean, wtf?  How is anyone supposed to review the code
based on that??  Or to understand it a year from now?

When I get to it I'll troll this email thread and might be able to
kludge together a description which might be able to fool people into
thinking it makes sense.

And someone at least needs to fix the comment: s/i_lock/i_mutex/.  I
guess that would be me.

>  Or it lives in fs/fs-writeback.c
> (which I always thought was weird; why is it not in mm/?),

The idea was that the writeback walk goes
superblocks->inodes->address_spaces->pages->bios->drivers, so that code
needs to be spread over fs->mm->block->drivers.  The dividing line
between fs and block is approximately at the "address_spaces" mark. 
Yes, that line is a bit smeary.

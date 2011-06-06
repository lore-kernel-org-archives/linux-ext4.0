From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 6 Jun 2011 16:55:12 -0400
Message-ID: <20110606205512.GE20818@thunk.org>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
 <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
 <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
 <4DECF2D5.7050408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amir G." <amir73il@users.sourceforge.net>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38388 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1FFUzS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 16:55:18 -0400
Content-Disposition: inline
In-Reply-To: <4DECF2D5.7050408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 06, 2011 at 10:31:33AM -0500, Eric Sandeen wrote:
> > For one reason, a snapshot file format is currently an indirect file
> > and big_alloc
> > doesn't support indirect mapped files.
> > I am not saying it cannot be done, but if it does, there would be
> > several obstacles
> > to cross.
> 
> I know I'm kind of just throwing a bomb out here, but I am very concerned
> about the ever-growing feature (in)compatibility matrix in ext4.

bigalloc doesn't support indirect blocks mainly because it was faster
to get things working if I didn't have to worry about indirect blocks.
It wouldn't be _that_ hard to make bigalloc work on indirect blocks.
I'll get around to it at some point.

dioread_nolock is something that I had hoped to clean up by now, by
making this the default way we do all buffered writebacks, for all
block sizes.

> Take for example dioread_nolock caveats:
> 
>           "However this does not work with nobh
>            option and the mount will fail. Nor does it work with
>            data journaling and dioread_nolock option will be
>            ignored with kernel warning. Note that dioread_nolock
>            code path is only used for extent-based files."

Hey, at least we got rid of nobh!  :-)

> If ext4 matches the lifespan of ext3, in 10 years I fear that it will look
> more like a collection of various individuals' pet projects, rather than
> any kind of well-designed, cohesive project.
> 
> How long can we really keep adding features which are semi- or wholly-
> incompatible with other features?
> 
> Consider this a cry in the wilderness for less rushed feature introduction,
> and a more holistic approach to ext4 design...

It's something I do worry about; and I do share your concern.  At the
same time, the reality is that we are a little like the Old Dutch
Masters, who had take into account the preference of their patrons
(i.e., in our case, those who pay our paychecks :-).  

In the case of dioread_nolock, I allowed dioread_nolock in even though
it was a not a complete solution since internally, we had critical
business for it, and in my judgement, (a) it wasn't that horrible
(most of the horrible code paths was already being used for AIO/DIO),
and (b) I had a plan for how to clean it up eventually.  The
fs/ext4/page_io.c implementation was in fact the first part of my
cleanup plan, so we've made some progress; it's just not gone as fast
as I would like.

Snapshots are an example of a feature where I am very much worried
about taking on technical debt.  On the other hand, there are a lot of
people who are quite excited of it as a feature, so I'm hoping we can
clean it up enough we don't put a huge maintenance burden on
ourselves.

It should be possible to make snapshots work on bigalloc file systems,
once support is added for indirect blocks.  The COW granulaity will
have to be done at the cluster level, of course, though.  So from a
design perspective it should be possible to make things knit together.

       		      	     		    - Ted

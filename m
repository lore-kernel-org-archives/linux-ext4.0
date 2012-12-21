From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Uninitialized extent races
Date: Fri, 21 Dec 2012 13:02:43 -0500
Message-ID: <20121221180243.GB31731@thunk.org>
References: <20121221012526.GD13474@quack.suse.cz>
 <20121221031151.GA5014@thunk.org>
 <20121221161929.GF17357@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39779 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab2LUSCz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2012 13:02:55 -0500
Content-Disposition: inline
In-Reply-To: <20121221161929.GF17357@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2012 at 05:19:29PM +0100, Jan Kara wrote:
>   No, I'm speaking about merging currently uninitialized extents. I.e.
> suppose someone does the following on a filesystem with dioread_nolock so
> that writeback happens via unwritten extents:
>   fd = open("file", O_RDWR);
>   pwrite(fd, buf, 4096, 0);
> 					flusher thread starts writing
> 					we create uninitialized extent for
> 					  range 0-4096
>   fallocate(fd, 0, 4096, 4096);
>     - we merge extents and now have just 1 uninitialized extent for range
>       0-8192
> 					ext4_convert_unwritten_extents() now
> 					  has to split the extent to finish
> 					  the IO.

Ah, I see.  Disabling the the merging that might take place as a
result of the fallocate.  Yes, I agree that's a completely sane thing
to do.

The alternate approach would be to add a flag in the extent status
tree indicating that an unwritten conversion is pending, but that
would add more complexity.

Hmmm.... do we need that complexity anyway?  What happens if we have a
race between a punch (or truncate) and the flusher thread, so there is
pending write.  There are two things that would be of concern.  (1)
Will convert_unwritten_extents do the right thing if the extent in
question has disappeared, and (2) what if the block gets reused for
some other inode in the interim?

I _think_ we're OK in the case of (2), since we're not using FUA
writes for anything other than the commit block, so there shouldn't be
any way that a write for the new inode could complete before the
pending write finishes up.  And (1) should be OK, although it may end
up triggering a WARN_ON and a scarry ext4_msg() in
ext4_convert_unwritten_extents().   But it made me stop and think....

> And I regarding more merging, that could be done (obviously), just we might
> need to postpone that after writeback is finished (PageWriteback is
> cleared) because there extent estimates are not clear. And I need to know
> necessary number of extents well in advance to be able to reserve credits
> in the journal. OTOH maybe we could use jbd2_journal_extend() to get more
> credits if we need them for merging. And when that fails, bad luck but we
> can cope... Anyway, this is a different problem.

Yeah, using jbd2_journal_extend() was what I was thinking about doing
where we could do some opportunistic merging if there's room in the
journal to allow that.  But I agree that's a different problem....

	   	 	      	    - Ted

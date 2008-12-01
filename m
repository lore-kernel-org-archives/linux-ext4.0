From: Theodore Tso <tytso@mit.edu>
Subject: Re: [ext4] Documentation patch
Date: Mon, 1 Dec 2008 15:58:28 -0500
Message-ID: <20081201205828.GA20069@mit.edu>
References: <8763m3u9kv.fsf@basilikum.skogtun.org> <20081201165700.GA26680@infradead.org> <493425DC.1010008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Harald Arnesen <skogtun.harald@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58113 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352AbYLAU6o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 15:58:44 -0500
Content-Disposition: inline
In-Reply-To: <493425DC.1010008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 01, 2008 at 11:58:52AM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Mon, Dec 01, 2008 at 05:46:56PM +0100, Harald Arnesen wrote:
> >>      So when comparing with a metadata-only journalling filesystem, such
> >> -    as ext3, use `mount -o data=writeback'.  And you might as well use
> >> +    as jfs or xfs, use `mount -o data=writeback'.  And you might as well use
> > 
> > data=ordered comes closest to what xfs does for quite a long time..
> 
> Agreed; that whole bit which mentions other filesystem comparisons
> should probably be stricken, unless it can be
> proven/demonstrated/substantiated that ext3 really does "offer higher
> data integrity guarantees than most" at this point.
> 
> data=ordered ensures that stale data won't be exposed on a crash; xfs
> won't do this (it'd be a security bug) and I'd be surprised if jfs or
> reiserfs do either.    And it probably *should* be mentioned that
> data=writeback bears this risk.

Well, the original text was written by David Kleikamp, so it might be
the case that jfs doesn't handle the stale data block case well.  I
haven't checked.  However, the sense of that paragraph got mangled
badly in commit 93e3270c, and what's there clearly doesn't make any
sense.

I agree the best thing to do is to nuke that whole paragraph.  The one
thing that's worth mentioning (as a replacement paragraph) is that
ext4 (and many other filesystems) has barreiers on by default, and
ext3 has barriers off by default, so that's something that should be
taken into account when doing head-to-head comparisons.

							- Ted

P.S.  Speaking of barriers, there was a rumor floating around that
someone was working on patches so at least in the case of RAID 0 and
RAID 1, that the LVM and MD stack would actually pass barier requests
down to the block device layer.  Whatever happened to that?  Is that
bug in the LVM layer going to get fixed any time soon?

From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Thu, 30 Jul 2009 20:44:48 +0200
Message-ID: <20090730184448.GC24295@duck.suse.cz>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com> <20090729181007.GC14105@mit.edu> <20090730183053.GE9223@atrey.karlin.mff.cuni.cz> <4A71E8D0.3030505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZG3Sot (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jul 2009 14:44:49 -0400
Content-Disposition: inline
In-Reply-To: <4A71E8D0.3030505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 30-07-09 13:39:12, Eric Sandeen wrote:
> Jan Kara wrote:
> >> On Tue, Jul 28, 2009 at 05:28:05PM -0700, Curt Wohlgemuth wrote:
> 
> ...
> 
> >> 2) We can modify the ext4_ext_convert_to_initialized() to be more
> >> aggressive about initializing data blocks if we know we are doing DIO,
> >> since zero'ing an aligned 16 to 32 blocks and then waiting for the
> >> journal commit once is cheaper than converting the extent one block at
> >> a time and waiting for the journal commit after each block write.
> >   Definitely. I'm not following the discussion too much in detail but
> > what seems to me is the following could work:
> >   The direct IO path would first send all the data to disk to the
> > desired location (get_block wouldn't do any conversion, just map blocks).
> > When this is done, we convert all the touched extents to initialized ones
> > from ext4_direct_IO, update i_size if needed, and wait for transaction
> > commit.
> > 
> > 								Honza
> 
> This is all about right, but it's tricky, because right now, get_block
> is called in the direct IO path from get_more_blocks(), and it's called
> with create == 0 unless OWN_LOCKING is specified.  If we do get_block w/
> create == 0 and find prealloc'd blocks, then we're given back unmapped
> buffer heads. This looks like a hole, and so DIO falls back to buffered.
>
> Right now the only way to get create == 1 sent to get_blocks via
> directio is to do OWN_LOCKING, which implies... we have to do our own
> locking, and it'll take some time to get it right I think.
  But the get_block function called by get_more_blocks() is specified in
ext4_direct_IO. So we can provide it with a special direct_IO version of
get_block function which happily maps also uninitialized extents... It's a
slight hack, but maintainable IMHO.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

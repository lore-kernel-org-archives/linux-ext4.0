From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Thu, 30 Jul 2009 13:39:12 -0500
Message-ID: <4A71E8D0.3030505@redhat.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com> <20090729181007.GC14105@mit.edu> <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZG3SjT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jul 2009 14:39:19 -0400
In-Reply-To: <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>> On Tue, Jul 28, 2009 at 05:28:05PM -0700, Curt Wohlgemuth wrote:

...

>> 2) We can modify the ext4_ext_convert_to_initialized() to be more
>> aggressive about initializing data blocks if we know we are doing DIO,
>> since zero'ing an aligned 16 to 32 blocks and then waiting for the
>> journal commit once is cheaper than converting the extent one block at
>> a time and waiting for the journal commit after each block write.
>   Definitely. I'm not following the discussion too much in detail but
> what seems to me is the following could work:
>   The direct IO path would first send all the data to disk to the
> desired location (get_block wouldn't do any conversion, just map blocks).
> When this is done, we convert all the touched extents to initialized ones
> from ext4_direct_IO, update i_size if needed, and wait for transaction
> commit.
> 
> 								Honza

This is all about right, but it's tricky, because right now, get_block
is called in the direct IO path from get_more_blocks(), and it's called
with create == 0 unless OWN_LOCKING is specified.  If we do get_block w/
create == 0 and find prealloc'd blocks, then we're given back unmapped
buffer heads. This looks like a hole, and so DIO falls back to buffered.

Right now the only way to get create == 1 sent to get_blocks via
directio is to do OWN_LOCKING, which implies... we have to do our own
locking, and it'll take some time to get it right I think.

-Eric

From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Thu, 30 Jul 2009 14:16:32 -0500
Message-ID: <4A71F190.3050209@redhat.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com> <20090729181007.GC14105@mit.edu> <20090730183053.GE9223@atrey.karlin.mff.cuni.cz> <4A71E8D0.3030505@redhat.com> <20090730184448.GC24295@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40432 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZG3TQq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jul 2009 15:16:46 -0400
In-Reply-To: <20090730184448.GC24295@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> On Thu 30-07-09 13:39:12, Eric Sandeen wrote:
...

							Honza
>> This is all about right, but it's tricky, because right now, get_block
>> is called in the direct IO path from get_more_blocks(), and it's called
>> with create == 0 unless OWN_LOCKING is specified.  If we do get_block w/
>> create == 0 and find prealloc'd blocks, then we're given back unmapped
>> buffer heads. This looks like a hole, and so DIO falls back to buffered.
>>
>> Right now the only way to get create == 1 sent to get_blocks via
>> directio is to do OWN_LOCKING, which implies... we have to do our own
>> locking, and it'll take some time to get it right I think.
>   But the get_block function called by get_more_blocks() is specified in
> ext4_direct_IO. So we can provide it with a special direct_IO version of
> get_block function which happily maps also uninitialized extents... It's a
> slight hack, but maintainable IMHO.

Hm, perhaps.  xfs does have a xfs_get_blocks_direct() that it uses for DIO.

Although returning mapped unwritten blocks ... well, we'll have to be
sure it doesn't cause any problems elsewhere.  :)

-Eric

> 									Honza


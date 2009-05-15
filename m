From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 11:27:03 -0500
Message-ID: <4A0D97D7.3050304@redhat.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu> <4A0CC381.3080804@redhat.com> <20090515125035.GC9173@mit.edu> <4A0D66F5.2090204@redhat.com> <4A0D8921.8000304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@Sun.COM>, Alex Tomas <bzzz@Sun.COM>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbZEOQ1M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 12:27:12 -0400
In-Reply-To: <4A0D8921.8000304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Theodore Tso wrote:
>>> On Thu, May 14, 2009 at 08:21:05PM -0500, Eric Sandeen wrote:
>>>> it should lay out a 4g file in random 1m direct IOs to fragment it and
>>>> get a lot of extents, then launch 2 threads, one each doing random reads
>>>> and random writes of that same file.
>>>>
>>>> I can't make this trip it, though ...
>>> If all of the blocks are in the page cache, you won't end up calling
>>> ext4_get_blocks().  Try adding a shell script which runs in parallel
>>> doing a "while /bin/true ; do sleep 1; echo 3 > /proc/sys/vm/drop_cache; done".
>>>
>>> 							- Ted
>> I made sure it was a big enough file, and consumed enough memory on the
>> system before the test, that the entire file couldn't fit in memory.
>>
>> I can try doing the dropping in the bg ... but it should have been going
>> to disk already.
>>
>> -Eric
> 
> in a desperate attempt to show the window, I tried this in
> ext4_ext_put_in_cache():
> 
>         cex->ec_block = -1;
>         cex->ec_start = -1;
>         schedule_timeout_uninterruptible(HZ/2);
>         cex->ec_start = start;
>         cex->ec_block = block;
> 
> and this in ext4_ext_in_cache():
> 
>         if (cex->ec_block == -1 || cex->ec_start == -1)
>                 printk("%s got bad cache\n", __func__);
> 
> and it's not firing.

I take it back, needed a different workload.

Sorry for being pedantic, but if this race is so blindingly obvious and
we're getting so few reports, I wanted to be sure we could hit it.  With
my artificially wide window now I think I can see it, but I'm still not
winding up with any corruption or EIOs....

-Eric

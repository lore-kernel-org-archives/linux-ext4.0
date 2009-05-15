From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 20:21:05 -0500
Message-ID: <4A0CC381.3080804@redhat.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33739 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZEOBVO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 21:21:14 -0400
In-Reply-To: <20090514212325.GG21316@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, May 15, 2009 at 06:32:45AM +0930, Kevin Shanahan wrote:
>> Okay, so now I've booted into 2.6.29.3 + check_block_validity patch +
>> short circuit i_cached_extent patch, mounted the fs without
>> nodelalloc. I was able to run the full exchange backup without
>> triggering the check_block_validity error.
> 
> Great!
> 
> So here's the final fix (it replaces the short circuit i_cached_extent
> patch) which I plan to push to Linus.  It should be much less of a
> performance hit than simply short-circuiting i_cached_extent...
> 
> Thanks so much for helping to find track this down!!!  If ever someone
> deserved an "Ext4 Baker Street Irregulars" T-shirt, it would be
> you....
> 
>        	       	   	      	   	      - Ted

So here's a fio job I thought would try to hit this ...

[global]
ioengine=libaio
iodepth=1
filesize=4g
bs=1m
norandommap
direct=1
loops=500
size=16g

[setup]
filename=file
rw=randwrite
loops=1

[thread1]
stonewall
filename=file
rw=randwrite

[thread2]
filename=file
rw=randread

it should lay out a 4g file in random 1m direct IOs to fragment it and
get a lot of extents, then launch 2 threads, one each doing random reads
and random writes of that same file.

I can't make this trip it, though ...

-Eric

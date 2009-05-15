From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 07:58:29 -0500
Message-ID: <4A0D66F5.2090204@redhat.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu> <4A0CC381.3080804@redhat.com> <20090515125035.GC9173@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZEOM6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 08:58:39 -0400
In-Reply-To: <20090515125035.GC9173@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, May 14, 2009 at 08:21:05PM -0500, Eric Sandeen wrote:
>> it should lay out a 4g file in random 1m direct IOs to fragment it and
>> get a lot of extents, then launch 2 threads, one each doing random reads
>> and random writes of that same file.
>>
>> I can't make this trip it, though ...
> 
> If all of the blocks are in the page cache, you won't end up calling
> ext4_get_blocks().  Try adding a shell script which runs in parallel
> doing a "while /bin/true ; do sleep 1; echo 3 > /proc/sys/vm/drop_cache; done".
> 
> 							- Ted

I made sure it was a big enough file, and consumed enough memory on the
system before the test, that the entire file couldn't fit in memory.

I can try doing the dropping in the bg ... but it should have been going
to disk already.

-Eric

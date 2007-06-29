From: Mike Waychison <mikew@google.com>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 29 Jun 2007 18:07:25 -0400
Message-ID: <4685829D.2020401@google.com>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org>	<20070629205525.GD32178@thunk.org> <20070629143818.9f4ac7d7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:58484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbXF2WHu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2007 18:07:50 -0400
In-Reply-To: <20070629143818.9f4ac7d7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Fri, 29 Jun 2007 16:55:25 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> 
>>On Fri, Jun 29, 2007 at 01:01:20PM -0700, Andrew Morton wrote:
>>
>>>Guys, Mike and Sreenivasa at google are looking into implementing
>>>fallocate() on ext2.  Of course, any such implementation could and should
>>>also be portable to ext3 and ext4 bitmapped files.
>>
>>What's the eventual goal of this work?  Would it be for mainline use,
>>or just something that would be used internally at Google?
> 
> 
> Mainline, preferably.
> 
> 
>> I'm not
>>particularly ennthused about supporting two ways of doing fallocate();
>>one for ext4 and one for bitmap-based files in ext2/3/4.  Is the
>>benefit reallyworth it?
> 
> 
> umm, it's worth it if you don't want to wear the overhead of journalling,
> and/or if you don't want to wait on the, err, rather slow progress of ext4.
> 
> 
>>What I would suggest, which would make much easier, is to make this be
>>an incompatible extensions (which you as you point out is needed for
>>security reasons anyway) and then steal the high bit from the block
>>number field to indicate whether or not the block has been initialized
>>or not.  That way you don't end up having to seek to a potentially
>>distant part of the disk to check out the bitmap.  Also, you don't
>>have to worry about how to recover if the "block initialized bitmap"
>>inode gets smashed.  
>>
>>The downside is that it reduces the maximum size of the filesystem
>>supported by ext2 by a factor of two.  But, there are at least two
>>patch series floating about that promise to allow filesystem block
>>sizes > than PAGE_SIZE which would allow you to recover the maximum
>>size supported by the filesytem.
>>
>>Furthermore, I suspect (especially after listening to a very fasting
>>Usenix Invited Talk by Jeffery Dean, a fellow from Google two weeks
>>ago) that for many of Google's workloads, using a filesystem blocksize
>>of 16K or 32K might not be a bad thing in any case.
>>
>>It would be a lot simpler....
>>
> 
> 
> Hadn't thought of that.
> 
> Also, it's unclear to me why google is going this way rather than using
> (perhaps suitably-tweaked) ext2 reservations code.
> 
> Because the stock ext2 block allcoator sucks big-time.

The primary reason this is a problem is that our writers into these 
files aren't neccesarily coming from the same hosts in the cluster, so 
their arrival times aren't sequential.  It ends up looking to the kernel 
like a random write workload, which in turn ends up causing odd 
fragmentation patterns that aren't very deterministic.  That data is 
often eventually streamed off the disk though, which is when the 
fragmentation hurts.

Currently, our clustered filesystem supports pre-allocation of the 
target chunks of files, but this is implemented by writting effectively 
zeroes to files, which in turn causes pagecache churn and a double 
write-out of the blocks.  Recently, we've changed the code to minimize 
this pagecache churn and double write out by performing an ftruncate to 
extend files, but then we'll be back to square-one in terms of 
fragmentation for the random writes.

Relying on (a tweaked) reservations code is also somewhat limitting at 
this stage given that reservations are lost on close(fd).  Unless we 
change the lifetime of the reservations (maybe for the lifetime of the 
in-core inode?), crank up the reservation sizes and deal with the 
overcommit issues, I can't think of any better way at this time to deal 
with the problem.

Mike Waychison

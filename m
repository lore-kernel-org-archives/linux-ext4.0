From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 02 Mar 2007 07:17:59 -0600
Message-ID: <1172841479.7992.10.camel@kleikamp.austin.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com> <45E72647.9000001@redhat.com>
	 <20070302104532.GT6573@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:46443 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423064AbXCBNSH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2007 08:18:07 -0500
In-Reply-To: <20070302104532.GT6573@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-03-02 at 18:45 +0800, Andreas Dilger wrote:
> On Mar 01, 2007  13:15 -0600, Eric Sandeen wrote:
> > One thing I'd like to see is a cmd argument as well, to allow for 
> > example allocation vs. reservation (i.e. allocating blocks vs. simply 
> > reserving a number), as well as the inverse of those functions 
> > (un-reservation, de-allocation)?
> > 
> > If the allocation interface allows allocation/reservation within 
> > arbitrary ranges, if the only way to un-allocate is via a truncate, 
> > that's pretty asymmetric.
> 
> I'd rather we just get the oft-discussed punch() syscall instead.
> This is really what "unallocate" would do for persistent allocations
> and it would be useful for files that were not preallocated.

I can see a difference though.  punch() would throw away written data as
well as pre-allocated-but-never-written-to data.  I can see where a user
might preallocate a large file and do a lot of random writes.  At some
point, he decides the file isn't going to grow much more, so let's free
up the remaining pre-allocated blocks.  This makes even more sense with
reservation.

The alternative would be to have punch() take a flag to specify if only
preallocated or reserved blocks should be freed.

> 
> For filesystems that don't implement punch glibc() would do zero-filling
> of the punched area I guess (to make it equivalent to reading from a
> hole in the file).

Or it could just fail.  Writing zeroes may be really slow and not give
the caller any benefit.  (The intention was to free blocks back to the
file system.)

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

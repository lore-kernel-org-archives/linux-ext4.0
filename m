From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/1] e2fsprogs: Add undo I/O manager.
Date: Thu, 07 Jun 2007 17:10:54 +0530
Message-ID: <4667EEC6.8040001@linux.vnet.ibm.com>
References: <4c7823c85d4ea3b4535f9fc0e4afa93078317f81.1179828850.git.aneesh.kumar@linux.vnet.ibm.com> <20070603231701.GA10140@thunk.org> <46668633.7060403@linux.vnet.ibm.com> <20070606120218.GC32603@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:65126 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbXFGLmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2007 07:42:22 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l57C3BG4299812
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 22:03:17 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l57BjRAJ060464
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 21:45:34 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l57BfEKD016709
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 21:41:14 +1000
In-Reply-To: <20070606120218.GC32603@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Wed, Jun 06, 2007 at 03:32:27PM +0530, Aneesh Kumar K.V wrote:
>> If we allow to change the block size in between that would mean the
>> records that we store in the tdb database will be of variable size ( 
>> different block sizes). That would also add all the code/complexity that 
>> i have in is_trans_overlapping. So if we are looking at avoiding the 
>> above for() loop then we should have constant block size (4K ?).  But in 
>> your above statement, you are counting overhead as a percentage of 
>> blocksize. So how do we handle this ?
> 
> As I suggested in my previous mail message, the block size rarely
> changes (mke2fs being the primary counter-example, and then only in a
> fairly restricted case).  So as far as the tdb is concerned, we have
> to use a constant blocksize (the first one which is used when writing
> to the i/o block).  So the undo manager would save away the blocksize
> the first time it was written to --- and yes, we would have to store
> that information in the tdb file so the restore program knows what
> block size is used, but that's easy; just write out the blocksize that
> out as an ascii number (to avoid byte swapping issues) with the key
> "blocksize" :-).
> 
> 

I don't think we need to store the blocksize because we can use the 
data.dsize that is returned from tdb_fetch as the block size. For the 
replay below is what i have right now.


  for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
                 data = tdb_fetch(tdb, key);
                 blk_num = *(unsigned long *)key.dptr;
                 location = blk_num * data.dsize;
printf("Replayed transaction of size %d at location %ld\n", data.dsize, 
blk_num);
                 lseek(fd, location, SEEK_SET);
                 write(fd, data.dptr, data.dsize);
         }



> 
>>> What version of e2fsprogs are you developing against?
>> Right now i am manually linking it against libtdb.
>>
>> dpkg --search /usr/lib/libtdb.so
>> tdb-dev: /usr/lib/libtdb.so
> 
> Any particular reason you're not using the development version from
> Mercurial for your development?  In general it's good practice to send
> patches against the latest develoment tip.  What caught my eye of that
> particular comment was that it was pretty much saying that you weren't
> doing that....
> 



Nothing particular. In the beginning i have imported the extent based 
patches into  a git repository and i continued using the same. Once we 
all agree with the approach followed by the code i will port the same to 
the code found in mercurial.


-aneesh

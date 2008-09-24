From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the inode
 table
Date: Wed, 24 Sep 2008 09:23:34 -0400
Message-ID: <48DA3F56.8090806@redhat.com>
References: <E1KhvsB-0002Ik-Ex@closure.thunk.org> <20080923101613.58768083@lxorguk.ukuu.org.uk> <20080923115045.GI10950@webber.adilger.int> <48D8DEAE.4080309@redhat.com> <20080924013014.GA9747@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54475 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIXNXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Sep 2008 09:23:48 -0400
In-Reply-To: <20080924013014.GA9747@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Sep 23, 2008 at 08:18:54AM -0400, Ric Wheeler wrote:
>   
>> I think that Alan is probably right - the magic number for modern drives  
>> is probably closer to 256K. Having it be a /sys tunable (with a larger  
>> default) would be a nice way to verify this.
>>     
>
> I've played with this a bit, and with the "git status" workload,
> increasing the magic number beyond 16 (64k) doesn't actually help,
> because the number of inodes we need to touch wasn't big enough.
>
> So I switched to a different workload, which ran "find /path -size 0
> -print" with a much larger directory hierarchy.  With that workload I
> got the following results:
>
> ra_bits	ra_blocks  ra_kb  seconds  % improvement
> 0	   1	     4	  53.3		 -
> 1	   2	     8	  47.3		11.3%
> 2	   4	    16	  41.7		21.8%
> 3	   8	    32	  37.5		29.6%
> 4	  16	    64	  34.4		35.5%
> 5	  32	   128	  32		40.0%
> 6	  64	   256	  30.7		42.4%
> 7	 128	   512	  28.8		46.0%
> 8	 256	  1024	  28.3		46.9%
> 9	 512	  2048	  27.5		48.4%
>
> Given these numbers, I'm using a default of inode_readahead_bits of 5
> (i.3., 32 blocks, or 128k for 4k blocksize filesystems).  For a
> workload that is 100% stat-based, without any I/O, it is possible to
> get better results by using a higher number, yes, but I'm concerned
> that a larger readahead may end up interfering with other reads.  We
> need to run some other workloads to be sure a larger number won't
> cause problems before we go more aggressive on this parameter.
>
> I'll send the revised patch in another message.
>
> 					- Ted
>   

That sounds about right for modern S-ATA/SAS drives. I would expect that 
having this be a tunable knob might help for some types of storage (SSD 
might not care, but should be faster in any case?).

ric


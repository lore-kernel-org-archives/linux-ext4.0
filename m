From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4_fallocate
Date: Fri, 29 Jun 2012 13:02:35 -0600
Message-ID: <27810AD9-FEA3-4C82-A5EC-A4B9B5F90071@dilger.ca>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org> <4FEB9115.6090309@redhat.com> <4FEC3FAA.1060503@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Ric Wheeler <ricwheeler@gmail.com>,
	Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org,
	wenqing.lz@taobao.com
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54739 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab2F2TCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2012 15:02:36 -0400
In-Reply-To: <4FEC3FAA.1060503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-28, at 5:27 AM, Ric Wheeler wrote:
> We need to keep in mind what the goal of pre-allocation is (should be?) - spend a bit of extra time doing the allocation call so we get really good, contiguous layout on disk which ultimately will help in streaming read/write workloads.
> 
> If you have a reasonably small file, pre-allocation is probably simply a waste of time - you would be better off overwriting the maximum file size with all zeros (even a 1GB file would take only a few seconds).
> 
> If the file is large enough to be interesting, I think that we might want to think about a scheme that would bring small random IO's more into line with the 1MB results Eric saw.
> 
> One way to do that might be to have a minimum "chunk" that we would zero out for any IO to an allocated but unwritten extent. You write 4KB to the middle of said region, we pad up and zero out to the nearest MB with zeros.

There is already code for this in the ext4 uninit extent handling.
Currently the limit is 15(?) blocks, to inflate the write size up
to zero-fill a 64kB chunk on 4kB blocksize filesystems.  I wouldn't
object to increasing this to zero out a full 1MB (aligned) chunk
under random IO cases.

Yes, it would hurt the latency a small amount for the first writes
(though not very much for disks, given the seek overhead), but it
would avoid clobbering the extent tree so drastically, which also
has long-term bad performance effects.

> Note for the target class of drives (S-ATA) that Ted mentioned earlier, doing a random 4KB write vs a 1MB write is not that much slower (you need to pay the head movement costs already).  Of course, the sweet spot might turn out to be a bit smaller or larger.

Right, at ~100-150 seeks/sec, it is pretty close to the 150 MB/s write
bandwidth limit, so the cost of doing 4kB vs. 1MB writes is a toss-up.
I expect the bandwidth of drives to continue increasing, while the seek
rate will stay the same.  The tradeoff for SSD devices is not so clear,
since inflated writes will hurt the cache, but in that case, it makes
more sense to use trim-with-zero (if supported) instead of unallocated
blocks anyway.

Cheers, Andreas






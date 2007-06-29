From: Mike Waychison <mikew@google.com>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 29 Jun 2007 18:26:30 -0400
Message-ID: <46858716.2050901@google.com>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org> <20070629205525.GD32178@thunk.org> <20070629214615.GB5026@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:60615 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXF2W1W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2007 18:27:22 -0400
In-Reply-To: <20070629214615.GB5026@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Jun 29, 2007  16:55 -0400, Theodore Tso wrote:
> 
>>What's the eventual goal of this work?  Would it be for mainline use,
>>or just something that would be used internally at Google?  I'm not
>>particularly ennthused about supporting two ways of doing fallocate();
>>one for ext4 and one for bitmap-based files in ext2/3/4.  Is the
>>benefit reallyworth it?
>>
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
> 
> 
> I don't think ext2 is safe for > 8TB filesystems anyways, so this
> isn't a huge loss.

This is reference to the idea of overloading the high-bit and not 
related to the >PAGE_SIZE blocks correct?

> 
> The other possibility is, assuming Google likes ext2 because they
> don't care about e2fsck, is to patch ext4 to not use any
> journaling (i.e. make all of the ext4_journal*() wrappers be
> no-ops).  That way they would get extents, mballoc and other speedups.
> 

We do care about the e2fsck problem, though the cost/benefit of e2fsck 
times/memory problems vs the overhead of journalling doesn't weigh in 
journalling's favour for a lot of our per-spindle-latency bound 
applications.  These apps manage to get pretty good disk locality 
guarantees and the journal overheads can induce undesired head movement.

ext4 does look very promising, though I'm not certain it's ready for our 
consumption.

What are people's thoughts on providing ext3 non-journal mode?  We could 
benefit from several of the additions to ext3 that aren't available in 
ext2 and disabling journalling there sounds much more feasible for us 
instead of trying to backport each ext3 component to ext2.

Mike Waychison

> That said, what is the reason for not using ext3?  Presumably performance
> (which is greatly improved in ext4) or is there something else?
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

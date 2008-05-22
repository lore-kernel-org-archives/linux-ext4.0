From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Storing inodes in a separate block device?
Date: Thu, 22 May 2008 10:21:57 -0500
Message-ID: <48358F95.4070900@redhat.com>
References: <48358907.3010103@yahoo-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nathan Roberts <nroberts@yahoo-inc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYEVPWU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2008 11:22:20 -0400
In-Reply-To: <48358907.3010103@yahoo-inc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nathan Roberts wrote:
> Has a feature ever been considered (or already exist) for storing inodes 
> in a block device separate from the data? Is it even a "reasonable" 
> thing to do or are there major pitfalls that one would run into?

XFS has such a thing, although it evolved for slightly different
reasons.  The "realtime subvolume" is a data-only volume, with all
metadata on the main block device.  It also has some different allocator
characteristics.  In practice I don't think it's been used much in the
field on Linux, but ISTR some people have had good luck for some workloads.

> The rationale behind this question comes from use cases where a file 
> system is storing very large numbers of files. Reading files in these 
> file systems will essentially incur at least two seeks: one for the 
> inode, one for the data blocks. If the seek to the inode were more 
> efficient, dramatic performance gains could be achieved for such use cases.
> 
> Fast seeking devices (such as flash based devices) are becoming much 
> more mainstream these days and would seem like a reasonable device for 
> the inodes. The $/GB is not as good as disks but it's much better than 
> DRAM. For many use cases, the number of these "fast access" inodes that 
> would need to be cached in RAM is near 0. So, RAM savings are also a 
> potential benefit.

One downside may be flash wear; in a hand-wavy way I could imagine that
data blocks may change less often than metadata in many use casees
(think atimes, directory updates and whatnot).  Just a thought.

> I've ran some basic tests using ext4 on a SATA array plus a USB thumb 
> drive for the inodes. Even with the slowness of a thumb drive, I was 
> able to see encouraging results ( >50% read throughput improvement for a 
> mixture of 4K-8K files).

How'd you test this, do you have a patch?  Sounds interesting.

Thanks,
-Eric

> I'm interested in hearing thoughts/potential pitfalls/etc.
> 
> Nathan
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


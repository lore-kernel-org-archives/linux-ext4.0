From: Andreas Dilger <adilger@sun.com>
Subject: Re: Storing inodes in a separate block device?
Date: Thu, 22 May 2008 10:03:18 -0600
Message-ID: <20080522160317.GY3516@webber.adilger.int>
References: <48358907.3010103@yahoo-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Nathan Roberts <nroberts@yahoo-inc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34062 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYEVQDX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2008 12:03:23 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4MG3Lea027273
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 09:03:22 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1A00K011JCSE00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 22 May 2008 09:03:21 -0700 (PDT)
In-reply-to: <48358907.3010103@yahoo-inc.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 22, 2008  09:53 -0500, Nathan Roberts wrote:
> Has a feature ever been considered (or already exist) for storing inodes in 
> a block device separate from the data? Is it even a "reasonable" thing to 
> do or are there major pitfalls that one would run into?

There was a filesystem called "dualfs" that implemented this - I believe
it was a hacked version of ext3.  It showed quite decent results.
Similarly, Lustre splits filesystem metadata (path, permissions,
attributes) onto different filesystems from the data.

For ext4 there is work being done on the FLEX_BG feature, which will allow
clustering of the metadata into a larger groups inside the filesystem, in
order to reduce seeking when doing filesystem scans.  This could be taken
to extremes to group all of the metadata into a single area, and use LVM
to place that on a separate disk.

Putting the journal on a separate disk would also help reduce the seeking
during writes.  Using flash for the journal is not useful because it does
almost exclusively linear IO and no seeking.

> The rationale behind this question comes from use cases where a file system 
> is storing very large numbers of files. Reading files in these file systems 
> will essentially incur at least two seeks: one for the inode, one for the 
> data blocks. If the seek to the inode were more efficient, dramatic 
> performance gains could be achieved for such use cases.
>
> Fast seeking devices (such as flash based devices) are becoming much more 
> mainstream these days and would seem like a reasonable device for the 
> inodes. The $/GB is not as good as disks but it's much better than DRAM. 
> For many use cases, the number of these "fast access" inodes that would 
> need to be cached in RAM is near 0. So, RAM savings are also a potential 
> benefit.
>
> I've ran some basic tests using ext4 on a SATA array plus a USB thumb drive 
> for the inodes. Even with the slowness of a thumb drive, I was able to see 
> encouraging results ( >50% read throughput improvement for a mixture of 
> 4K-8K files).

Ah, are you using FLEX_BG for this test?  It would also be interesting to
see if splitting the metadata onto a normal disk had the same effect,
just by virtue of allowing the data and metadata to seek independently.

There is also work to aggregate the allocation of ext4 file allocation
metadata, and while this speeds up unlink the current algorithm hurts
the read performance.  Having the file allocation metadata on a separate
disk may avoid this performance hit.  It may also be that we just need
to make more effort to do readahead on this metadata.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


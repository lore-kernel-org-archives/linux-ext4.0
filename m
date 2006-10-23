From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 10:01:49 -0500
Message-ID: <453CD95D.4010000@redhat.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz>	<20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3vembnlwz.fsf@bzzz.home.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>>>>>> Theodore Tso (TT) writes:
> 
>  TT> On Mon, Oct 23, 2006 at 02:27:10PM +0200, Jan Kara wrote:
>  >> Hello,
>  >> 
>  >> I've written a simple patch implementing ext3 ioctl for file
>  >> relocation. Basically you call ioctl on a file, give it list of blocks
>  >> and it relocates the file into given blocks (provided they are still
>  >> free). The idea is to use it as a kernel part of ext3 online
>  >> defragmenter (or generally disk access optimizer). 
> 
> isn't that a kernel responsbility to find/allocate target blocks?
> wouldn't it better to specify desirable target group and minimal
> acceptable chunk of free blocks?

XFS does this by allocating new blocks for a temporary file (initiated from 
userspace, implemented in kernelspace of course), then just checks to see if the 
result is better than what we had before; if so, then swap the storage space & 
throw away the temporary file (which now has the original, more-fragmented file 
blocks).

see xfs_swapext() in xfs_dfrag.c for the extent swapping part of this.

You probably want to avoid the page cache in all of this too, doing O_DIRECT IO 
if possible, I don't think there's any reason to churn the page cache while the 
defragmenter runs over a filesystem?

-Eric

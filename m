From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 10:15:59 +0100
Message-ID: <20110225091559.GC15464@bitwizard.nl>
References: <E1PsnrK-0005r5-JH@tytso-glaptop> <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:53166 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932191Ab1BYJQF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 04:16:05 -0500
Content-Disposition: inline
In-Reply-To: <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

I must say I haven't read all of the large amounts of text in this
discussion.

But what I understand is that you're suggesting that we implement
larger blocksizes on the device, while we have to maintain towards the
rest of the kernel that the blocksize is no larger than 4k, because
the kernel can't handle that.

Part of reasoning why this should be like this comes from the
assumption that each block group has just one block worth of bitmap.
That is IMHO the "outdated" assumption that needs to go.

Then, especially on filesystems where many large files live, we can
emulate the "larger blocksize" at the filesystem level: We always
allocate 256 blocks in one go! This is something that can be
dynamically adjusted: You might stop doing this for the last 10% of
free disk space.

Now, you might say: How does this help with the performance problems
mentioned in the introduction? Well. reading 16 block bitmaps from 16
block groups will cost a modern harddrive on average 16 * (7ms avg
seek + 4.1 avg rot latency + 0.04ms transfer time), or about 170 ms.

Reading 16 block bitmaps from ONE block group will cost a modern
harddrive on average: 7ms avg seek + 4.1ms rot + 16*0.06 =
11.2ms. That is an improvement of a factor of over 15...

Now, whenever you allocate blocks for a file, just zap 256 bits at
once! Again the overhead of handling 255 more bits in memory is
trivial. 

I now see that andreas already suggested something similar but still
different.

Anyway: Advantages that I see: 

- the performance benefits sougth for. 

- a more sensible number of block groups on filesystems. (my 3T
  filessytem has 21000 block groups!)

- the option of storing lots of small files without having to make 
  a fs-creation-time choice. 

- the option of improving defrag to "make things perfect".  (allocation
  strategy may be: big files go in big-files-only block groups and
  their tails go in small-files-only block groups. Or if you think
  big files may grow, tails go in big-files-only block groups. Whatever
  you chose, defrag may clean up a fragpoint and or some unallocated
  space when after a while it's clear that a big file will no longer
  grow, and is just an archive). 

	Roger. 


On Fri, Feb 25, 2011 at 01:21:58AM -0700, Andreas Dilger wrote:
> On 2011-02-24, at 7:56 PM, Theodore Ts'o wrote:
> > = Problem statement = 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ

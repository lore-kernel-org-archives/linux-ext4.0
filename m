From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 03:01:08 -0700
Message-ID: <BBAF46A2-4F43-47E5-B98C-A33837EEF67E@dilger.ca>
References: <E1PsnrK-0005r5-JH@tytso-glaptop> <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca> <20110225091559.GC15464@bitwizard.nl>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:28364 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab1BYKBK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 05:01:10 -0500
In-Reply-To: <20110225091559.GC15464@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-25, at 2:15 AM, Rogier Wolff wrote:
> I must say I haven't read all of the large amounts of text in this
> discussion.

We don't write it to be read, just for fun :-).

> But what I understand is that you're suggesting that we implement
> larger blocksizes on the device, while we have to maintain towards the
> rest of the kernel that the blocksize is no larger than 4k, because
> the kernel can't handle that.
> 
> Part of reasoning why this should be like this comes from the
> assumption that each block group has just one block worth of bitmap.
> That is IMHO the "outdated" assumption that needs to go.

What you are suggesting is a feature called "flex_bg", and already is
implemented in ext4, which is why I referenced it in my email.

> Then, especially on filesystems where many large files live, we can
> emulate the "larger blocksize" at the filesystem level: We always
> allocate 256 blocks in one go! This is something that can be
> dynamically adjusted: You might stop doing this for the last 10% of
> free disk space.

That's exactly what I wrote.

> Now, you might say: How does this help with the performance problems
> mentioned in the introduction? Well. reading 16 block bitmaps from 16
> block groups will cost a modern harddrive on average 16 * (7ms avg
> seek + 4.1ms avg rot latency + 0.04ms transfer time), or about 170 ms.

That is the time to load bitmaps in a non-flex_bg filesystem, which is
the default for ext3-formatted filesystems.

> Reading 16 block bitmaps from ONE block group will cost a modern
> harddrive on average: 7ms avg seek + 4.1ms rot + 16*0.04ms xfer =
> 11.2ms. That is an improvement of a factor of over 15...

That is possible with flex_bg and a flex_bg factor of 16.  That said,
I don't think the kernel explicitly fetches all 16 bitmaps today,
though it may have the benefit of a track cache on the disk.  I think
the correct number above is actually 11.8ms, not 11.2ms.

In comparison, Ted's proposal would have an average access time of

7ms avg seek + 4.1ms rot + 0.04ms xfer = 11.14ms

which is not a significant savings.

> Now, whenever you allocate blocks for a file, just zap 256 bits at
> once! Again the overhead of handling 255 more bits in memory is
> trivial. 
> 
> I now see that andreas already suggested something similar but still
> different.

I'm not quite sure how your proposal is different, once you understand
what a flex_bg is.

> Anyway: Advantages that I see: 
> 
> - the performance benefits sougth for. 
> 
> - a more sensible number of block groups on filesystems. (my 3T
>  filessytem has 21000 block groups!)
> 
> - the option of storing lots of small files without having to make 
>  a fs-creation-time choice. 
> 
> - the option of improving defrag to "make things perfect".  (allocation
>  strategy may be: big files go in big-files-only block groups and
>  their tails go in small-files-only block groups. Or if you think
>  big files may grow, tails go in big-files-only block groups. Whatever
>  you chose, defrag may clean up a fragpoint and or some unallocated
>  space when after a while it's clear that a big file will no longer
>  grow, and is just an archive). 
> 
> 	Roger. 
> 
> 
> On Fri, Feb 25, 2011 at 01:21:58AM -0700, Andreas Dilger wrote:
>> On 2011-02-24, at 7:56 PM, Theodore Ts'o wrote:
>>> = Problem statement = 
> 
> -- 
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
> Does it sit on the couch all day? Is it unemployed? Please be specific! 
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ


Cheers, Andreas






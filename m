From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: [PATCH, RFC 00/12] bigalloc patchset
Date: Mon, 21 Mar 2011 12:31:19 +0100
Message-ID: <20110321113119.GA16292@bitwizard.nl>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu> <5427513F-76B9-4315-AC17-4BF35B290B18@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:34351 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753194Ab1CULbV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 07:31:21 -0400
Content-Disposition: inline
In-Reply-To: <5427513F-76B9-4315-AC17-4BF35B290B18@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 09:55:07AM +0100, Andreas Dilger wrote:

> Unfortunately, the overhead of allocating a whole cluster for every
> index block and every directory is fairly high.  For Lustre it
> matters very little, since there are only a handful of directories
> (under 40) on the data filesystems where this would be used and the
> real directory tree is located on a different metadata filesystem
> which probably wouldn't use this feature, but for most "normal"
> users this overhead may become prohibitive.  That is why I've been
> trying to think of a way to allow sub-cluster allocations for these
> uses.

FYI, one filesystem I know has a neat trick that works well (IMHO). 

Whenever you have a file or a "tail-of-a-file" that is smaller than a
cluster, you allocate it from a special file that contains all
tails-of-files that are a specific size.

That filesystem happened to have 64k clusters and 512byte
tail-file-granularity. So it had 128 files that contained the tails of
all possible differt sizes.

In our case I would suggest using a sequence something like: 
4k, 8k, 12k, 16k, 24k, 32k, 48k 64k, 96k, 128k and so on. 

That way with about 15 tail-files we are reasonably efficient (never
having more than 4k or 33% allocated over the filesize). Also, adding
8k to a 128k file doesn't require moving the whole file from one spot
in the filesystem to another, which would be required if we were to 
enumerate all 4k-multiples up to 1M. 

The higher bits of the block numbers will indicate that it refers to a
tail-block blocknumber, and in which tail-file to look for the
tail-block.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ

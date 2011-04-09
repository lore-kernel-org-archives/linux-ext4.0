From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: tune2fs can't be used on a mounted ext4, or...?
Date: Sat, 9 Apr 2011 15:30:42 -0600
Message-ID: <14B9D41F-4D38-4F01-97E9-17E86DA578FC@dilger.ca>
References: <20110410003954.4108b9c9@natsu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:41959 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab1DIVao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Apr 2011 17:30:44 -0400
In-Reply-To: <20110410003954.4108b9c9@natsu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-09, at 12:39 PM, Roman Mamedov wrote:
> Here's what happened. I reshaped my RAID5 to a RAID6 and a larger disk count.
> Then I ran "resize2fs /dev/md0". It successfully enlarged the filesystem
> online (that took a couple of hours, I think).

The online resize shouldn't take more than a few minutes, unless the disk is crazy busy and you are going from 16GB to 16TB or something.

> Since my count of disks changed, I thought I should change the array stripe
> width. Then, while still not unmounting the filesystem, I did:
> 
>  tune2fs -E stripe_width=48 /dev/md0

This does nothing more than set a field in the superblock, and it only gives a hint to the allocator to align the files on multiples of 48-block boundaries.

> Then I started copying files from another array to the one on which the above
> operations were conducted. I did:
> 
>  cp -Rp /mnt/array1/data/* /mnt/array2/new-data/

What kernel version do you have, and what version of coreutils?  Is this perhaps a bleeding-edge kernel/coreutils with the "FIEMAP" bug?

> This completed successfully. No errors on the console, silence in dmesg.
> 
> Then I thought I'd verify the destination, just to be sure. Luckily, I have
> checksums stored in almost every directory as .SFV files (created with "cfv").
> 
> And some checksums did not match. On a closer investigation, it appears like
> some files deep down in the directory tree (and with a rare occurence,
> something like one file in a thousand) were truncated during copying. E.g.
> they'd have size of 188 MB instead of 349 MB, or 128 MB instead of 170 MB.
> Some files (originally less than 1 MB in size) just had zero-length on the
> destination.

Were the source files that had problems recently written themselves in this case?

> Other than these truncations, there is NO corruption of data inside any of the
> files. Which kinda rules out CRC-style errors in controller/disk/cable.
> 
> So.. this is completely puzzling to me, and I suspect either a kernel bug, or
> my mistake, and tune2fs cannot modify a mounted FS (however it did NOT show any
> warning that the FS was mounted, and if this is the case, it should've
> absolutely refused to operate on a mounted FS).
> 
> Any ideas? :)
> 
> -- 
> With respect,
> Roman


Cheers, Andreas






From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Uneven load on my raid disks.
Date: Mon, 03 Jan 2011 11:18:59 -0600
Message-ID: <4D220503.80706@redhat.com>
References: <20101228090749.GB1351@bitwizard.nl> <4D1B646C.8030100@uni-konstanz.de> <20101229221715.GK10149@thunk.org> <20101230103200.GH2986@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Kay Diederichs <kay.diederichs@uni-konstanz.de>,
	linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1ACRTH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 12:19:07 -0500
In-Reply-To: <20101230103200.GH2986@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/30/2010 04:32 AM, Rogier Wolff wrote:
> On Wed, Dec 29, 2010 at 05:17:15PM -0500, Ted Ts'o wrote:
>> On Wed, Dec 29, 2010 at 05:40:12PM +0100, Kay Diederichs wrote:
>>>> says: dumpe2fs -h /dev/md0 | grep RAID
>>>
>>> % tune2fs -l /dev/md0
>>>
>>> ...
>>> RAID stride:              128
>>> RAID stripe width:        768
>>> ...
>>>
>>> runs much faster than dumpe2fs.
>>> The command can also adjust the values.
>>
>> Actually, "tune2fs -l" and "dumpe2fs -h" both run in about the same
>> amount of time.  dumpe2fs without the -h option runs slower than
>> tune2fs -l, true.  But that's because it reads and prints out
>> information regarding the block and inode allocation bitmaps.
> 
> And the annoying thing is that it apparently uses a library function
> that only returns after reading all that data. 
> 
> So while it could print the superblock info and the first few block
> groups, I'm left waiting.
> 
> My remove-of-200-million-files has completed. It took a week. 
> 200000000/7/24/3600 = 330.7 .
> 
> So it deleted around 330 files per second. With one IO operation per
> delete, the four disks operating at close to 75 IOs per second have
> performed reasonable. And at an average of 1 IO per remove, also
> the filesystem has performed reasonable. It seems I forgot the
> -E stride= option on mkfs. 
> 
> The manual of tune2fs hints that this can be tuned after the fact with
> tune2fs. I seriously doubt it. Correct?
> 
> TUNE2FS(8)                                                          
> ...
>        -E extended-options
>               Set extended options for the filesystem.  Extended  options  are
>               comma separated, and may take an argument using the equals ('=')
>               sign.  The following extended options are supported:
> 
>                    stride=stride-size
> ...
>                    stripe_width=stripe-width
> 

It will change the superblock values, but you're right, it does not
appear to actually move around any metadata or inode tables.

Interestingly there are some facilities for doing this if the inode
size gets changed:

/*
 * We need to scan for inode and block bitmaps that may need to be
 * moved.  This can take place if the filesystem was formatted for
 * RAID arrays using the mke2fs's extended option "stride".
 */
static int group_desc_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)


-Eric

> 
> 	Roger. 
> 


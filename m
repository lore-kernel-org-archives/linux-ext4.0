From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 17:02:51 -0400
Message-ID: <4A9C3A7B.3050302@redhat.com>
References: <4A9BFB88.5030409@redhat.com> <4A9C0220.1040503@redhat.com> <20090831205608.GE4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@thunk.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZHaVB2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 17:01:28 -0400
In-Reply-To: <20090831205608.GE4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/31/2009 04:56 PM, Andreas Dilger wrote:
> On Aug 31, 2009  13:02 -0400, Ric Wheeler wrote:
>> One more note - this file system was filled using fs_mark, but without
>> doing any fsync() calls.
>>
>> umount:
>>
>> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 2580708130 blocks
>> 516141626 reqs (511081408 success)
>> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 5060218 extents
>> scanned, 0 goal hits, 5060218 2^N hits, 0 breaks, 0 lost
>> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 85164 generated and
>> it took 471527376
>> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 2590831616
>> preallocated, 10120312 discarded
>>
>> Mount after fsck:
>> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75):
>> ext4_check_descriptors: Checksum for group 487 failed (59799!=46827)
>> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors
>> corrupted!
>>
>> The MBALLOC messages are a bit worrying - what exactly gets discarded
>> during an unmount?
>
> The in-memory preallocation areas are discarded.  This is reporting
> that of the 2590M preallocation areas it reserved, only 10M of them
> were discarded during the lifetime of the filesystem.
>
> Of the other stats:
> - 471 seconds were spent in total generating the 85k buddy bitmaps
>    (this is done incrementally at runtime)
> - 516M calls to mballoc to find a chunk of blocks, 511M calls were able
>    to find the requested chunk (not surprising given it is a new filesystem,
>    probably the 5M calls that failed were when the fs was nearly full)
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>

This file system was never more than 7% full - the 511M calls were for each of 
the 20KB files more or less I guess.

ric


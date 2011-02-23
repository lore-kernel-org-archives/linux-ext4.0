From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck performance.
Date: Wed, 23 Feb 2011 15:24:18 -0700
Message-ID: <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca>
References: <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl> <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu> <20110223205309.GA16661@bitwizard.nl>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34937 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab1BWWYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 17:24:20 -0500
In-Reply-To: <20110223205309.GA16661@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-23, at 1:53 PM, Rogier Wolff wrote:
> My implementation has been a "cleanroom" implementation in that I've
> only looked at the specifications and implemented it from
> there. Although no external attestation is available that I have been
> completely shielded from the newer GPLv3 version... 
> 
> On a slightly different note: 
> 
> A pretty good estimate of the number of inodes is available in the
> superblock (tot inodes - free inodes). A good hash size would be: "a
> rough estimate of the number of inodes." Two or three times more or
> less doesn't matter much. CPU is cheap. I'm not sure what the
> estimate for the "dircount" tdb should be.

The dircount can be extracted from the group descriptors, which count the number of allocated directories in each group.  Since the superblock "free inodes" count is no longer updated except at unmount time, the code would need to walk all of the group descriptors to get this number anyway.

> The amount of disk space that the tdb will use is at least: 
>  overhead + hash_size * 4 + numrecords * (keysize + datasize +
>                                                 perrecordoverhead)
> 
> There must also be some overhead to store the size of the keys and
> data as both can be variable length. By implementing the "database"
> ourselves we could optimize that out. I don't think it's worth the
> trouble. 
> 
> With keysize equal 4, datasize also 4 and hash_size equal to numinodes
> or numrecords, we would get
> 
> overhead + numinodes * (12 + perrecordoverhead). 
> 
> In fact, my icount database grew to about 750Mb, with only 23M inodes,
> so that means that apparently the perrecordoverhead is about 20 bytes.
> This is the price you pay for using a much more versatile database
> than what you really need. Disk is cheap (except when checking a root
> filesystem!)
> 
> So... 
> 
> -- I suggest that for the icount tdb we move to using the superblock
> info as the hash size.
> 
> -- I suggest that we use our own hash function. tdb allows us to
> specify our own hash function. Instead of modifying the bad tdb, we'll
> just keep it intact, and pass a better (local) hash function.
> 
> 
> Does anybody know what the "dircount" tdb database holds, and what is
> an estimate for the number of elements eventually in the database?  (I
> could find out myself: I have the source. But I'm lazy. I'm a
> programmer you know...).
> 
> 
> On a separate note, my filesystem finished the fsck (33 hours (*)),
> and I started the backups again... :-)

If you have the opportunity, I wonder whether the entire need for tdb can be avoided in your case by using swap and the icount optimization patches previously posted?  I'd really like to get that patch included upstream, but it needs testing in an environment like yours where icount is a significant factor.  This would avoid all of the tdb overhead.

Cheers, Andreas






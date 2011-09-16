From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Thu, 15 Sep 2011 22:03:28 -0600
Message-ID: <7DCB013F-0EE0-439E-97EF-951AC0F613A0@dilger.ca>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu> <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca> <20110915231127.GK28181@thunk.org> <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca> <20110915234131.GL28181@thunk.org> <F48B39D1-7E73-4F3B-AA41-3D419CB5EF61@dilger.ca> <20110916005620.GF12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:50953 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab1IPEDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 00:03:37 -0400
In-Reply-To: <20110916005620.GF12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 6:56 PM, Darrick J. Wong wrote:
> On Thu, Sep 15, 2011 at 06:09:04PM -0600, Andreas Dilger wrote:
>> If you are reading the structure (not modifying it) and trying to verify
>> the checksum, it would be necessary to read-lock the structure, zero
>> the field, compute the checksum, reset the field, unlock, and then
>> compare checksums.  Alternately, one would have to make a copy of the
>> struct to zero out the field and compute the checksum on the copy.  Both
>> are more complex than just doing the checksum on two separate chunks.
> 
> I think a lot of the metadata update code already has locking to prevent
> multiple writers.  I'm not as sure about the locking around the read calls,
> though I suspect that we take some of the same locks before starting the read.
> However, I've yet to audit all those code paths.  Point is, we might already be
> doing most of the necessary locking.  Too bad I'm not sure.
> 
>>>> If we went to a crc32c LSB for filesystems with RO_COMPAT_METADATA_CSUM
>>>> it would be possible to change how it is computed.  Since we have freedom
>>>> to move the checksum field now, why have the added complexity to do
>>>> zeroing of the field or two chunks?
>>> 
>>> Why is zero'ing out the field complex?  It's a single line of code....
>>> It's certainly easier than doing it in two chunks, and there will be
>>> some data structures (the block group descriptors at the very least)
>>> where zero'ing the checksum is definitely going to be the easier way
>>> to go.
>> 
>> No, because for group descriptors, the size is conditional on whether
>> RO_COMPAT_GDT_CSUM is set, so it is just as easy to always compute the
>> first 32-byte crc32 (excluding the bg_checksum field) and then only
>> conditionally compute the second 32-byte checksum.  The same is true
>> of the inode checksum and s_inode_size, if the checksum is at the last
>> field of struct ext2_inode.
> 
> Um.... it looks to me like the size is conditional on
> EXT4_FEATURE_INCOMPAT_64BIT being set and then sb.s_desc_size.

My bad, I was looking at ext4_group_desc_csum() for the flag name, and my
eyes caught the wrong one...

>  Are you
> suggesting that we make the group descriptor checksum a full 32 bits and just
> stuff the upper 16 bits somewhere near the end of the structure?

No, I don't think we need a 32-bit checksum for the group descriptor.  Rather
that the crc32c is so much faster than crc16 that it might make sense to use
the low 16 bits of crc32c for the group descriptor if RO_COMPAT_METADATA_CSUM
is set.

> Incidentally, I have cached versions of the ext4 disk layout and metadata
> checksumming wiki pages mirrored here:
> http://djwong.org/docs/ext4_metadata_checksums.html
> http://djwong.org/docs/ext4_disk_layout.pdf


Cheers, Andreas






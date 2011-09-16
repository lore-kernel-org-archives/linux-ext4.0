From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Thu, 15 Sep 2011 21:57:33 -0600
Message-ID: <036188D0-DA3B-4DD1-A097-F0B6AC4B4BB4@dilger.ca>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu> <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca> <20110915231127.GK28181@thunk.org> <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca> <20110915234131.GL28181@thunk.org> <F48B39D1-7E73-4F3B-AA41-3D419CB5EF61@dilger.ca> <20110916010604.GM28181@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40666 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1IPD5j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 23:57:39 -0400
In-Reply-To: <20110916010604.GM28181@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 7:06 PM, Ted Ts'o wrote:
> On Thu, Sep 15, 2011 at 06:09:04PM -0600, Andreas Dilger wrote:
>> 
>> If you are reading the structure (not modifying it) and trying to verify
>> the checksum, it would be necessary to read-lock the structure, zero
>> the field, compute the checksum, reset the field, unlock, and then
>> compare checksums.  Alternately, one would have to make a copy of the
>> struct to zero out the field and compute the checksum on the copy.  Both
>> are more complex than just doing the checksum on two separate chunks.
> 
> You have to read-lock the structure before calculating the checksum in
> any case, since otherwise when someone else is modifying the
> structure, before they have a chance to update the checksum, you'll
> calculate the checksum and discover that it is incorrect.

Sure, but if the structure is read-locked it shouldn't be modified...

> In practice we would probably be calculating the checksum when the
> inode if first read into memory, before it it is visible to the rest
> of the system, so this shouldn't be an issue.  But if it is visible to
> the rest of the system, even you put the checksum at the end, if
> someone else can modify the data structure while you are calculating
> it, the checksum will be wrong.

True, but at the same time is there a reason _not_ to put the checksum
at the end?  For the superblock in particular it seems easy to do and
simplifies the code either way.

>> No, because for group descriptors, the size is conditional on whether
>> RO_COMPAT_GDT_CSUM is set, so it is just as easy to always compute the
>> first 32-byte crc32 (excluding the bg_checksum field) and then only
>> conditionally compute the second 32-byte checksum.  The same is true
>> of the inode checksum and s_inode_size, if the checksum is at the last
>> field of struct ext2_inode.
> 
> But wouldn't it be faster to zero out the two fields, and then
> caluclate a single 64-byte checksum?  That way we avoid the setup
> costs of the crc32, especially in the case of the crc32c-sby8-[lb]e
> implementation.

Looking at Darrick's performance tests for the checksums, at 32 bytes
the performance is 75%/95% (crc32-sby8-le/crc32-intel) of peak, and
91%/97% of peak for 128 bytes, so the overhead of computing the checksum
in two parts is probably not significant.

Cheers, Andreas






From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Thu, 15 Sep 2011 18:09:04 -0600
Message-ID: <F48B39D1-7E73-4F3B-AA41-3D419CB5EF61@dilger.ca>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu> <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca> <20110915231127.GK28181@thunk.org> <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca> <20110915234131.GL28181@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4898 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935501Ab1IPAJF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 20:09:05 -0400
In-Reply-To: <20110915234131.GL28181@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 5:41 PM, Ted Ts'o wrote:
> On Thu, Sep 15, 2011 at 05:34:41PM -0600, Andreas Dilger wrote:
>> 
>> Darrick and I discussed zeroing the checksum fields, but then there is a
>> race with other threads accessing the same structure.
> 
> What race are you worried about?  The moment you modify some part of
> the data structure, the checksum is going to be wrong.  This is true
> whether you zero out the checksum field before you do the calculations
> or not.

If you are reading the structure (not modifying it) and trying to verify
the checksum, it would be necessary to read-lock the structure, zero
the field, compute the checksum, reset the field, unlock, and then
compare checksums.  Alternately, one would have to make a copy of the
struct to zero out the field and compute the checksum on the copy.  Both
are more complex than just doing the checksum on two separate chunks.

>> If we went to a crc32c LSB for filesystems with RO_COMPAT_CSUM it would
>> be possible to change how it is computed.  Since we have freedom to move
>> the checksum field now, why have the added complexity to do zeroing of
>> the field or two chunks?
> 
> Why is zero'ing out the field complex?  It's a single line of code....
> It's certainly easier than doing it in two chunks, and there will be
> some data structures (the block group descriptors at the very least)
> where zero'ing the checksum is definitely going to be the easier way
> to go.

No, because for group descriptors, the size is conditional on whether
RO_COMPAT_GDT_CSUM is set, so it is just as easy to always compute the
first 32-byte crc32 (excluding the bg_checksum field) and then only
conditionally compute the second 32-byte checksum.  The same is true
of the inode checksum and s_inode_size, if the checksum is at the last
field of struct ext2_inode.

Cheers, Andreas






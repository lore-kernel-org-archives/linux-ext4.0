From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot
	feature flags
Date: Thu, 15 Sep 2011 17:56:20 -0700
Message-ID: <20110916005620.GF12086@tux1.beaverton.ibm.com>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu> <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca> <20110915231127.GK28181@thunk.org> <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca> <20110915234131.GL28181@thunk.org> <F48B39D1-7E73-4F3B-AA41-3D419CB5EF61@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:48244 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1IPA4Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 20:56:25 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Thu, 15 Sep 2011 18:56:25 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8G0uLr2158924
	for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 18:56:21 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8G0tuaT032078
	for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 18:55:56 -0600
Content-Disposition: inline
In-Reply-To: <F48B39D1-7E73-4F3B-AA41-3D419CB5EF61@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 06:09:04PM -0600, Andreas Dilger wrote:
> On 2011-09-15, at 5:41 PM, Ted Ts'o wrote:
> > On Thu, Sep 15, 2011 at 05:34:41PM -0600, Andreas Dilger wrote:
> >> 
> >> Darrick and I discussed zeroing the checksum fields, but then there is a
> >> race with other threads accessing the same structure.
> > 
> > What race are you worried about?  The moment you modify some part of
> > the data structure, the checksum is going to be wrong.  This is true
> > whether you zero out the checksum field before you do the calculations
> > or not.
> 
> If you are reading the structure (not modifying it) and trying to verify
> the checksum, it would be necessary to read-lock the structure, zero
> the field, compute the checksum, reset the field, unlock, and then
> compare checksums.  Alternately, one would have to make a copy of the
> struct to zero out the field and compute the checksum on the copy.  Both
> are more complex than just doing the checksum on two separate chunks.

I think a lot of the metadata update code already has locking to prevent
multiple writers.  I'm not as sure about the locking around the read calls,
though I suspect that we take some of the same locks before starting the read.
However, I've yet to audit all those code paths.  Point is, we might already be
doing most of the necessary locking.  Too bad I'm not sure.
> 
> >> If we went to a crc32c LSB for filesystems with RO_COMPAT_CSUM it would
> >> be possible to change how it is computed.  Since we have freedom to move
> >> the checksum field now, why have the added complexity to do zeroing of
> >> the field or two chunks?
> > 
> > Why is zero'ing out the field complex?  It's a single line of code....
> > It's certainly easier than doing it in two chunks, and there will be
> > some data structures (the block group descriptors at the very least)
> > where zero'ing the checksum is definitely going to be the easier way
> > to go.
> 
> No, because for group descriptors, the size is conditional on whether
> RO_COMPAT_GDT_CSUM is set, so it is just as easy to always compute the
> first 32-byte crc32 (excluding the bg_checksum field) and then only
> conditionally compute the second 32-byte checksum.  The same is true
> of the inode checksum and s_inode_size, if the checksum is at the last
> field of struct ext2_inode.

Um.... it looks to me like the size is conditional on
EXT4_FEATURE_INCOMPAT_64BIT being set and then sb.s_desc_size.  Are you
suggesting that we make the group descriptor checksum a full 32 bits and just
stuff the upper 16 bits somewhere near the end of the structure?  I suppose
that would leave us with very little space in the group descriptor.  On the
other hand the 32-bit format is totally full already and any size increase
depends on 64bit, which means we can make it even bigger with little pain if we
need to.

Incidentally, I have cached versions of the ext4 disk layout and metadata
checksumming wiki pages mirrored here:
http://djwong.org/docs/ext4_metadata_checksums.html
http://djwong.org/docs/ext4_disk_layout.pdf

--D


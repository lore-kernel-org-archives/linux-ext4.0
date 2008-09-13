From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 13 Sep 2008 17:29:03 -0400
Message-ID: <20080913212903.GF26128@mit.edu>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55914 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYIMV3T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 17:29:19 -0400
Content-Disposition: inline
In-Reply-To: <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2008 at 10:17:07PM +0100, Anton Altaparmakov wrote:
> Hi,
>
> Just a quick question (not a criticism of the patches in any way):
>
> Is there a specific reason that the flag FIEMAP_EXTENT_DATA_ENCRYPTED  
> exists?  I am only asking because there isn't a  
> FIEMAP_EXTENT_DATA_COMPRESSED flag yet the effect on the data is the  
> same.  I suppose one could argue that compression is a form of  
> encryption (as one cannot read the data on disk without decompressing  
> it) and thus for compressed files I can just set  
> FIEMAP_EXTENT_DATA_ENCRYPTED, too?

You could, but actually, the interface isn't really set up well to
deal with compressed files.  In order to deal with compressed data you
really would need two fields in struct fiemap_extent:
fe_length_physical, fe_length_logical, like this:

struct fiemap_extent {
	__u64 fe_logical;  /* logical offset in bytes for the start of
			    * the extent from the beginning of the file */
	__u64 fe_physical; /* physical offset in bytes for the start
			    * of the extent from the beginning of the disk */
	__u64 fe_length;   /* length in bytes for this extent */
	__u64 fe_length_physical;   /* length in bytes for this extent as 
	      			     * encoded/compressed on disk */
	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
	__u32 fe_reserved;
};

Part of the problem/frustration as we go around and round fs-devel is
that some people would request new features to support new
filesystems, and other people have been rejecting new features because
it makes the interface more complicated.

In fact, the previous version of the patch had a flag for compression,
but Cristoph Hellwig objected because he claimed there were no users
for it.

I don't care how this interface ends up, at least as far as this point
is concerned, but it's really annoying when some people want to add
features, and other people are objecting and trying to remove
features, and months and months and months go by while the patch
languishes while people play tug of war on the d*mned thing.

Probably the best thing to do is to add a much larger number of
reserved fields, of size __u32 and __u64, appropriately aligned, and
then when someone adds a compressed filesystem, we can add the
structure definition without changing the size of the structure.
Otherwise, the thou-shalt-not-anticipate-the-needs-of-any-future-
users-of-the-interface nazi's will strike again, and more months will
go by with absolutely no progress....

							- Ted

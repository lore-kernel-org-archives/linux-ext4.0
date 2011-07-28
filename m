From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Thu, 28 Jul 2011 11:57:30 -0700
Message-ID: <20110728185730.GJ20655@tux1.beaverton.ibm.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <1302290868.4461.7.camel@mingming-laptop> <20110727082730.GG20655@tux1.beaverton.ibm.com> <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com> <20110728165615.GI20655@tux1.beaverton.ibm.com> <CAOQ4uxiOpwX2-Nfh9wJ7wSmAnbj9bh1+d9C95-N5D-8saRr6ww@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <aedilger@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60601 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab1G1S51 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jul 2011 14:57:27 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiOpwX2-Nfh9wJ7wSmAnbj9bh1+d9C95-N5D-8saRr6ww@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 28, 2011 at 08:07:17PM +0300, Amir Goldstein wrote:
> On Jul 28, 2011 7:56 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> >
> > On Wed, Jul 27, 2011 at 03:16:12AM -0600, Andreas Dilger wrote:
> > > On 2011-07-27, at 2:27 AM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > > > On Fri, Apr 08, 2011 at 12:27:48PM -0700, Mingming Cao wrote:
> > > >> Beyond checksumming the inode itself, it
> > > >> would be more useful to checksum the extent indexing blocks, as the
> ext3
> > > >> corruption actually happen at the indirect block.
> > > >>
> > > >> The idea is to reduce the eh_max (the max # of extents stored in this
> > > >> block) to save some space to store the checksums in the block,
> > > >>
> > > >> /*
> > > >> * Each block (leaves and indexes), even inode-stored has header.
> > > >> */
> > > >> struct ext4_extent_header {
> > > >>        __le16  eh_magic;       /* probably will support different
> > > >> formats */
> > > >>        __le16  eh_entries;     /* number of valid entries */
> > > >>        __le16  eh_max;         /* capacity of store in entries */
> > > >>        __le16  eh_depth;       /* has tree real underlying blocks? */
> > > >>        __le32  eh_generation;  /* generation of the tree */
> > > >
> > > > Does anyone use eh_generation?  Linux 3.0 shows no users and it didn't
> look like
> > > > the snapshot patches do either.  If nobody intends to start using this
> field,
> > > > (part of) it could become eh_checksum
> > >
> > > We use eh_generation in Lustre to detect if the extent tree is being
> changed
> > > while it is unlocked.
> > >
> > > In the past, the discussion about adding checksums to the index and
> extent
> > > blocks was about using an ext4_extent_tail that contained not only the
> > > checksum of the block, but also a back-pointer to the inode/generation
> of the
> > > inode using this block.
> > >
> > > That would allow e2fsck to verify that it is using the correct
> index/extent
> > > blocks and not pointing to a stale block that belonged to some other
> inode.
> > >
> > > Since the header and index/extent entries are always 3 *__u32 in size,
> the
> > > extent tail can always be 4 * __u32 in size yet only consume a single
> slot in
> > > the block. There of course is no reason to put an extent tail inside the
> > > inode itself.
> >
> > Does anybody have any objection to using crc32c (which we can hardware
> > accelerate on new Intel boxen) over crc16?  I think it'll be pretty easy
> to use
> > some of the reserved space in the group descriptor to store checksums of
> the
> > block and inode bitmaps.
> 
> On LSF Ted told me i can use 32bit from the group descriptor for exclude
> bitmap block and that inode and block bitmap checksum would use 16bit each .

I know;  as far as I know there's still 96 bits of free space in the group
descriptor, which could be used to crc32 all three bitmaps.  But then that
leaves the descriptors with no room for further expansion, unless we decide to
expand them sort of like what was done for inodes.  Do we have a strategy for
handling continued expansion of metadata objects in ext4?

Besides "don't" or "use btrfs"? :)

--D

> 
>  Adding tails to the extent tree blocks seems a bit
> > trickier than that, but not a big deal, though I guess I'll have to
> reshuffle
> > the extent tree to free up space at the end of the block.
> >
> > I was also wondering what people think of adding checksums to directory
> files?
> > I think that it's possible to put a checksum in each directory block --
> for
> > blocks containing a linear array of actual directory entries, we could
> zero out
> > the space past the end of the array and put a checksum at the very end of
> the
> > block.  For the dx_node/dx_root blocks, we could probably use the space
> > occupied by the last dx_entry to store the checksum.  Obviously, we'd have
> to
> > move whatever's at the end of the block elsewhere, but then, we have to do
> that
> > for the extent tree too.  Basically, the last 4 bytes become the checksum
> after
> > whatever's occupying the space is relocated. :)
> >
> > It looks like there's sufficient unused space in ext4_xattr_header to add
> a
> > checksum.
> >
> > Also -- should I create separate rocompat feature flags for each metadata
> > object that I add checksums to?  Or just have one flag that covers them
> all?
> >
> > Ok, enough crazy ideas for now...
> >
> > --D
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

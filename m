From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] ext4 metadata checksumming design
Date: Mon, 22 Aug 2011 19:35:04 -0700
Message-ID: <20110823023504.GT20655@tux1.beaverton.ibm.com>
References: <20110817032519.GN20655@tux1.beaverton.ibm.com> <587920A5-66EF-4630-9E02-CA1C5790E0BD@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-fsdevel Devel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Coly Li <colyli@gmail.com>, Andi Kleen <andi@firstfloor.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38303 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1HWCfV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Aug 2011 22:35:21 -0400
Content-Disposition: inline
In-Reply-To: <587920A5-66EF-4630-9E02-CA1C5790E0BD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 22, 2011 at 12:11:25PM -0600, Andreas Dilger wrote:
> On 2011-08-16, at 9:25 PM, Darrick J. Wong wrote:
> > I've created a page on the ext4 wiki outlining the patchset that I'm working on
> > to add metadata checksumming to ext4.  The page can be found at this address:
> > https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> 
> Darrick,
> I just had a look though this document, and it looks pretty good.  It does
> need to be updated to reflect that the inode checksum now covers the full
> inode size, which is already mentioned in the "Extended Attributes" section.

Updated; thank you.

> > For the most part, the metadata objects in ext4 actually have enough space to
> > squeeze in a 32-bit checksum; it was trivially easy to find a spot in the
> > superblock, the extent tree, extended attribute blocks, and the inode.  Those
> > pieces are already done and in my tree, but the patchset as a whole is being
> > held up by the second class of metadata objects.
> 
> For the group descriptor checksum and inode/block bitmap checksums with
> 32-byte group descriptors it makes sense to truncate the CRC32c checksum
> and store the low bits of the checksum in the existing 16-bit fields, and
> the high bits in extended 16-bit fields.

One thing I haven't had the time to do yet is run that monte carlo simulation
that Ted suggested to find out how painful it is to cut off half of a crc32.
Do you know of anyone who has?  (Or for that matter knows anything about my
half-baked idea to crc16(crc32(bitmap))?)

> As a follow on, it probably also makes sense to test with a < 2^32 block
> filesystem with a 64-byte group descriptor.  That would give enough room
> for 32-bit checksums even on smaller filesystems, and would also help
> facilitate resizing filesystems from < 2^32 blocks to > 2^32 blocks in
> the future.  That _may_ just be as easy as formatting with "-O 64bit"
> on a < 2^32 block filesystem, but I don't know how much that has been
> tested.

I've been testing it.  I haven't seen any problems _so_ far.... :)

Thank you for the review!

--D
> 
> > That second class of objects are the ones that required a bit of work:
> > 
> > - Directory blocks have an "unused" 12-byte directory entry at the very end of
> >  the block; 8 bytes of header are followed by a 32-bit checksum.  This can be
> >  taken care of as part of directory rebuilding in e2fsck/rehash.c.
> > 
> > - HTree blocks had to have the dx_entry limit reduced by 1 to accomodate a
> >  checksum.  This is also taken care of during e2fsck directory rebuild.
> > 
> > - Extended attribute blocks that are stored in the inode table -- the h_magic
> >  field is written by the kernel, but neither the kernel nor e2fsprogs ever
> >  actually read this field.  The field could be reused to checksum the extra
> >  space since (as far as I can tell) EAs are the only user of that empty space.
> > 
> > Other miscellany:
> > 
> > - e2fsprogs had to be converted to always work with ext2_inode_large.
> > 
> > - Various bugs in the htree code....
> > 
> > I hope to have a first draft of the kernel/e2fsprogs patches out on the mailing
> > list in a week or two, or at least before LPC next month.  Still on my todo
> > list is superblocks, EAs, changing the jbd2 checksum, and rigorous testing on
> > powerpc.
> > 
> > Please have a look at the design document and please feel free to suggest any
> > changes.
> > 
> > --D
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

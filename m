From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Proposal draft for data checksumming for ext4
Date: Mon, 24 Mar 2014 02:59:30 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403240221350.2047@localhost.localdomain>
References: <alpine.LFD.2.00.1403201736280.8407@localhost.localdomain> <20140320175950.GJ9070@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-610756161-1395626374=:2047"
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaCXB7j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Mar 2014 21:59:39 -0400
In-Reply-To: <20140320175950.GJ9070@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-610756161-1395626374=:2047
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 20 Mar 2014, Darrick J. Wong wrote:

> Date: Thu, 20 Mar 2014 10:59:50 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
> Subject: Re: Proposal draft for data checksumming for ext4
> 
> On Thu, Mar 20, 2014 at 05:40:06PM +0100, Lukáš Czerner wrote:
> > Hi all,
> > 
> > I've started thinking about implementing data checksumming for ext4 file
> > system. This is not meant to be a formal proposal or a definitive design
> > description since I am not that far yet, but just a few ideas to start
> > the discussion and trying to figure out what the best design for data
> > checksumming in ext4 might be.
> > 
> > 
> > 
> > 			   Data checksumming for ext4
> > 				  Version 0.1
> > 				 March 20, 2014
> > 
> > 
> > Goal
> > ====
> > 
> > The goal is to implement data checksumming for ext4 file system in order
> > to improve data integrity and increase protection against silent data
> > corruption while maintaining reasonable performance and usability of the
> > file system.
> > 
> > While data checksums can be certainly used in different ways, for example
> > data deduplication this proposal is very much focused on data integrity.
> > 
> > 
> > Checksum function
> > =================
> > 
> > By default I plan to use crc32c checksum, but I do not see a reason why not
> > not to be able to support different checksum function. Also by default the
> > checksum size should be 32 bits, but the plan is to make the format
> > flexible enough to be able to support different checksum sizes.
> 
> <nod> Were you thinking of allowing the use of different functions for data and
> metadata checksums?

Hi Darrick,

I have not, but I think that this would be very easy to do if we can
agree that it's good to have.


> 
> > Checksumming and Validating
> > ===========================
> > 
> > On write checksums on the data blocks need to be computed right before its
> > bio is submitted and written out as metadata to its position (see bellow)
> > after the bio completes (similarly as we do unwritten extent conversion
> > today).
> > 
> > Similarly on read checksums needs to be computed after the bio completes
> > and compared with the stored values to verify that the data is intact.
> > 
> > All of this should be done using workqueues (Concurrency Managed
> > Workqueues) so we do not block the other operations and to spread the
> > checksum computation and comparison across CPUs. One wq for reads and one
> > for writes. Specific setup of the wq such as priority, or concurrency limits
> > should be decided later based on the performance evaluation.
> > 
> > While we already have ext4 infrastructure to submit bios in
> > fs/ext4/page-io.c where the entry point is ext4_bio_write_page() we would
> > need the same for reads to be able to provide ext4 specific hooks for
> > io completion.
> > 
> > 
> > Where to store the checksums
> > ============================
> > 
> > While the problems above are pretty straightforward when it comes to the
> > design, actually storing and retrieving the data checksums from to/from
> > the ext4 format requires much more thought to be efficient enough and play
> > nicely with the overall ext4 design while trying not to be too intrusive.
> > 
> > I came up with several ideas about where to store and how to access data
> > checksums. While some of the ideas might not be the most viable options,
> > it's still interesting to think about the advantages and disadvantages of
> > each particular solution.
> > 
> > a) Static layout
> > ----------------
> > 
> > This scheme fits perfectly into the ext4 design. Checksum blocks
> > would be preallocated the same way as we do with inode tables for example.
> > Each block group should have it's own contiguous region of checksum blocks
> > to be able to store checksums for bocks from entire block group it belongs
> > to. Each checksum block would contain header including checksum of the
> > checksum block.
> > 
> > We still have unused 4 Bytes in the ext4_group_desc structure, so storing
> > a block number for the checksum table should not be a problem.
> 
> What if you have a 64bit filesystem?  Do you have some strategy in mind to work
> around that?  What about the snapshot exclusion bitmap field?  Afaict that
> never went in, so perhaps that field could be reused?

Yes we can use the exclusion bitmap field. I think that would not be
a problem. We could also use addressing from the start of the block
group and keep the checksum table in the block group.

> 
> > Finding a checksum location of each block in the block group should be done
> > in O(1) time, which is very good. Other advantage is a locality with the
> > data blocks in question since both resides in the same block group.
> > 
> > Big disadvantage is the fact that this solution is not very flexibile which
> > comes from the fact that the location of "checksum table" is statically
> > located at a precise position in the file system at mkfs time.
> 
> Having a big dumb block of checksums would be easier to prefetch from disk for
> fsck and kernel driver, rather than having to dig through some tree structure.
> (More on that below)

I agree, it is also much more robust solution than having a tree.

> 
> > There are also other problems we should be concerned with. Ext4 file system
> > does have support for metadata checksumming so all the metadata does have
> > its own checksum. While we can avoid unnecessarily checksuming inodes, group
> > descriptors and basicall all statically positioned metadata, we still have
> > dynamically allocated metadata blocks such as extent blocks. These block
> > do not have to be checksummed but we would still have space reserved in the
> > checksum table.
> 
> Don't forget directory blocks--they (should) have checksums too, so you can
> skip those.
> 
> I wonder, could we use this table to store backrefs too?  It would make the
> table considerably larger, but then we could (potentially) reconstruct broken
> extent trees.

Definitely, that is one thing I did not discussed here, but I'd like
to have the checksum blocks self descriptive so we can alway know
where it belongs and who is the owner. So yes, having a backrefs is
really good idea.

> 
> > I think that we should be able to make this feature without introducing any
> > incompatibility, but it would make more sense to make it RO compatible only
> > so we can preserve the checksums. But that's up to the implementation.
> 
> I think you'd have to have it be rocompat, otherwise you could write data with
> an old kernel and a new kernel would freak out.

Yes, I think that we could make it not freak out, but we would loose
the checksums, so for that I think that having this rocompat will
probably make more sense.

Thanks!
-Lukas

> 
> > b) Special inode
> > ----------------
> > 
> > This is very "lazy" solution and should not be difficult to implement. The
> > idea is to have a special inode which would store the checksum blocks in
> > it's own data blocks.
> > 
> > The big disadvantage is that we would have to walk the extent tree twice for
> > each read, or write. There is not much to say about this solution other than
> > again we can make this feature without introducing any incompatibility, but
> > it would probably make more sense to make it RO compatible to preserve the
> > checksums.
> > 
> > c) Per inode checksum b-tree
> > ----------------------------
> > 
> > See d)
> > 
> > d) Per block group checksum b-tree
> > ----------------------------------
> > 
> > Those two schemes are very similar in that both would store checksum in a
> > b-tree with a block number (we could use logical block number in per inode
> > tree) as a key. Obviously finding a checksum would be in logarithmic time,
> > while the size of the tree would be possibly much bigger in the per-inode
> > case. In per block group case we will have much smaller boundary of
> > number of checksum blocks stored.
> > 
> > This and the fact that we would have to have at least one checksum block
> > per inode (which would be wasteful in the case of small files) is making per
> > block group solution much more viable. However the major disadvantage of
> > per block group solution is that the checksum tree would create a source of
> > contention when reading/writing from/to a different inodes in the same block
> > group. This might be mitigated by having a worker thread per a range of block
> > groups - but it might still be a bottleneck.
> > 
> > Again we still have 4 Bytes in ext4_group_desc to store the pointer to the
> > root of the tree. While the ext4_inode structure have 4Bytes of
> > i_obso_faddr but that's not enough. So we would have to figure out where to
> > store it - we could possibly abuse i_block to store it along with the extent
> > nodes.
> 
> I think(?) your purpose in using either a special inode or a btree to store the
> checksums is to avoid wasting checksum blocks on things that are already
> checksummed?  I'm not sure that we'd save enough space to justify the extra
> processing.
> 
> --D
> 
> > File system scrub
> > =================
> > 
> > While this is certainly a feature which we want to have in both userspace
> > e2fsprogs and kernel I do not have any design notes at this stage.
> > 
> > 
> > 
> > 
> > I am sure that there are other possibilities and variants of those design
> > ideas, but I think that this should be enough to have a discussion started.
> > As I is not I think that the most viable option is d) that is, per block
> > group checksum tree, which gives us enough flexibility while not being too
> > complex solution.
> > 
> > I'll try to update this description as it will be getting more concrete
> > structure and I hope that we will have some productive discussion about
> > this at LSF.
> > 
> > Thanks!
> > -Lukas
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-610756161-1395626374=:2047--

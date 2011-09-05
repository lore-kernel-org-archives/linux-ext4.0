From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 06/16] ext4: Calculate and verify inode checksums
Date: Mon, 5 Sep 2011 10:57:29 -0700
Message-ID: <20110905175729.GN12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003112.31048.36302.stgit@elm3c44.beaverton.ibm.com> <C1CC4631-3651-4493-A45E-465A620B1FB7@dilger.ca> <20110902193220.GM12086@tux1.beaverton.ibm.com> <E649CC48-DE08-4DCA-8903-B563A6F36755@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53687 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab1IER5c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Sep 2011 13:57:32 -0400
Content-Disposition: inline
In-Reply-To: <E649CC48-DE08-4DCA-8903-B563A6F36755@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 02, 2011 at 04:02:17PM -0600, Andreas Dilger wrote:
> On 2011-09-02, at 1:32 PM, Darrick J. Wong wrote:
> > On Wed, Aug 31, 2011 at 08:30:25PM -0600, Andreas Dilger wrote:
> >> On 2011-08-31, at 6:31 PM, Darrick J. Wong wrote:
> >>> This patch introduces to ext4 the ability to calculate and verify inode
> >>> checksums.  This requires the use of a new ro compatibility flag and some
> >>> accompanying e2fsprogs patches to provide the relevant features in tune2fs and e2fsck.
> >>> 
> >>> 
> >>> +static __le32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
> >>> +{
> >>> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> >>> +	struct ext4_inode_info *ei = EXT4_I(inode);
> >>> +	int offset = offsetof(struct ext4_inode, i_checksum);
> >> 
> >> This could be declared "const int" so that it is not consuming space on
> >> the stack, or just put it inline in the code instead of a stack variable
> >> since it is a compile time constant.
> >> 
> >>> +	__le32 inum = cpu_to_le32(inode->i_ino);
> >>> +	__u32 crc = 0;
> >>> +
> >>> +	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> >>> +	    cpu_to_le32(EXT4_OS_LINUX))
> >> 
> >> This can be marked unlikely() I think.
> > 
> > Ok.
> > 
> >>> +		return 0;
> >>> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		return 0;
> >>> +
> >>> +	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
> >>> +	crc = crc32c_le(crc, (__u8 *)&inum, sizeof(inum));
> >> 
> >> I wonder if it makes sense to pre-compute the crc32c of s_uuid (stored
> >> in sbi) and/or s_uuid+inum (stored in struct ext4_inode_info).  I suspect
> >> precomputing the s_uuid checksum is worthwhile, but I'm not sure whether
> >> precomputing the inode checksum is worthwhile unless it doesn't reduce
> >> the number of ext4_inode_info structs per page in the slab.
> > 
> > Sounds like a good idea, I'll look into it.
> 
> Looking more closely at the cryptoapi code, I'm fairly confident that
> storing the partial crc32c for the uuid+inum+generation into the inode
> is going to be worthwhile, compared to calling crc32c_le() 3 extra times.

Hmm, can the FS UUID change while the FS is mounted?  Or, to look at this from
the other side, does anyone mind if tune2fs -U can tell you to umount before
changing UUID?

I think we need that anyway, to prevent races between tune2fs checksum rewrite
and kernel writing stuff.

I found a bug where if you mount a fs and write to it, then dumpe2fs -h will
complain about superblock checksum errors.  Will have to look into that...

> >>> +	crc = crc32c_le(crc, (__u8 *)raw, offset);
> >>> +	offset += sizeof(raw->i_checksum); /* skip checksum */
> >>> +	crc = crc32c_le(crc, (__u8 *)raw + offset,
> >>> +		    EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize -
> >>> +		    offset);
> >> 
> >> I suspect it would be more efficient to set raw->i_checksum = 0, then
> >> compute the checksum on the whole raw inode buffer, and fill in
> >> raw->i_checksum = cpu_to_le32(crc) at the end.  That would mean the
> >> caller ext4_inode_csum_verify() should save the original checksum for
> >> comparison with the returned value.
> > 
> > You mean to avoid the overhead of the add/store and the second function call?
> 
> Mostly the overhead of the extra calls into crc32c_le() and the cryptoapi.
> There are a lot of extra pointer indirections in that code, and calling
> into cryptoapi for 4-byte values adds (vaguely) 60-100 operations per word
> on top of the actual checksum operations, unless it all disappears at
> compile time (hard to see at first glance).
> 
> >> The one problem with this is that it is racy w.r.t other users
> > 
> > Yeah, I was thinking that if I move the *_csum_set() calls to a jbd2 callback
> > (for journal mode, obviously) then this might clash with that.  Maybe a better
> > approach would be to calculate/verify an entire block's worth of inodes at a
> > time.  Then again, if you only want to touch /one/ inode out of a whole block,
> > that's a lot of unnecessary work.
> 
> However, if you are doing that from the jbd2 callback, the code also has
> exclusive control over the buffer at that time, so computing the checksum
> on the zeroed bytes in a single pass is not racy, and would definitely be
> less overhead for such a small number of bytes.
> 
> >>> +	return cpu_to_le32(crc);
> >>> +}
> >>> +
> >>> +static int ext4_inode_csum_verify(struct inode *inode, struct ext4_inode *raw)
> >>> +{
> >>> +	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os ==
> >>> +	    cpu_to_le32(EXT4_OS_LINUX) &&
> >>> +	    EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
> >>> +	    (raw->i_checksum != ext4_inode_csum(inode, raw)))
> >> 
> >> This check can be marked unlikely(), since the rare case of a checksum
> >> failure can cause a stall in the execution pipeline.  It might make sense
> >> to put the unlikely() at the lone callsite to move the whole function call
> >> overhead out-of-line.
> > 
> > I suppose so, both for this and for all the other _verify() functions.
> 
> Right.
> 
> >>> +		return 0;
> >>> +	return 1;
> >>> +}
> >>> +
> >>> +static void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw)
> >>> +{
> >>> +	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> >>> +	    cpu_to_le32(EXT4_OS_LINUX) ||
> >>> +	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		return;
> >>> +
> >>> +	raw->i_checksum = ext4_inode_csum(inode, raw);
> >>> +}
> >>> +
> >>> static inline int ext4_begin_ordered_truncate(struct inode *inode,
> >>> 					      loff_t new_size)
> >>> {
> >>> @@ -3410,6 +3458,15 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >>> 	if (ret < 0)
> >>> 		goto bad_inode;
> >>> 	raw_inode = ext4_raw_inode(&iloc);
> >>> +
> >>> +	if (!ext4_inode_csum_verify(inode, raw_inode)) {
> >>> +		EXT4_ERROR_INODE(inode, "checksum invalid (0x%x != 0x%x)",
> >>> +		       le32_to_cpu(ext4_inode_csum(inode, raw_inode)),
> >>> +		       le32_to_cpu(raw_inode->i_checksum));
> >>> +		ret = -EIO;
> >>> +		goto bad_inode;
> >>> +	}
> >>> +
> >>> 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
> >>> 	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
> >>> 	inode->i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
> >>> @@ -3490,6 +3547,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >>> 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
> >>> 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
> >>> 		    EXT4_INODE_SIZE(inode->i_sb)) {
> >>> +			EXT4_ERROR_INODE(inode, "bad extra_isize (%u != %u)",
> >>> +				EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize,
> >>> +				EXT4_INODE_SIZE(inode->i_sb));
> >>> 			ret = -EIO;
> >>> 			goto bad_inode;
> >>> 		}
> >>> @@ -3731,6 +3791,8 @@ static int ext4_do_update_inode(handle_t *handle,
> >>> 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
> >>> 	}
> >>> 
> >>> +	ext4_inode_csum_set(inode, raw_inode);
> >> 
> >> This might warrant a comment to always be the last function before
> >> submitting the inode to the journal.
> > 
> > Ok.
> > 
> >>> 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> >>> 	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
> >>> 	if (!err)
> >> 
> >> Also, rather than just making the checksum be updated at commit time, it
> >> makes more sense to have ext4_do_update_inode() only be called once per
> >> commit, since this is an expensive function.
> > 
> > If I made jbd2 responsible for calling back into ext4 to apply checksums just
> > prior to submit_bh()ing metadata blocks, I think that would take care of this.
> 
> Yes, that would be the most desirable case, but it also means that the
> journal code needs to pin all of these inodes in memory until after it
> commits.  Possibly the new ext4 ordered journal mode already does this,
> but not sure about other journal modes.
> 
> I definitely like the idea of using the jbd2 pre-commit callbacks, but
> I don't think it is necessarily needed for the first version of the
> patches.  Better to get the "simple" implementation working correctly
> (so that we are sure it is doing the right thing), and then migrate it
> over to using the commit callbacks so that we can verify it is still
> correct.

I wasn't planning to start on this optimization until I finish addressing all
the other comments/complaints.

--D
> 
> Cheers, Andreas--
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

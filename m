From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] jbd2 metadata checksumming
Date: Fri, 23 Sep 2011 17:47:38 -0700
Message-ID: <20110924004738.GO12086@tux1.beaverton.ibm.com>
References: <20110923225135.GN12086@tux1.beaverton.ibm.com> <4FFF8C58-425B-431C-9144-0A6B7568A39F@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Joel Becker <jlbec@evilplan.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51681 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1IXAro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Sep 2011 20:47:44 -0400
Content-Disposition: inline
In-Reply-To: <4FFF8C58-425B-431C-9144-0A6B7568A39F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 06:07:46PM -0600, Andreas Dilger wrote:
> On 2011-09-23, at 4:51 PM, Darrick J. Wong wrote:
> > While I'm working on adding metadata checksumming to ext4, I figured that I
> > ought to look into the similar feature in jbd2.  At first I thought I'd simply
> > change the default crc algorithm to crc32c and update the field in the commit
> > block, but then it was suggested to me that I move that field into the journal
> > superblock so that during recovery we don't have to scan ahead through the
> > transaction to find the commit block so that we can learn the algorithm type.
> > 
> > Doing that seems to require a format change to the superblock to add that
> > field.  I think that adding the crc-type field to the superblock is a rocompat
> > change since we're not changing existing fields, just adding fields.  It looks
> > like the kernel and e2fsprogs code both reject a journal if they find unknown
> > rocompat bits set.  (Using a journal in ro mode is not useful.)
> 
> The question is whether the "rejected journal" means that it is ignored
> during recovery and not replayed at all, or if it prevents mounting?  If it
> is ignored and not replayed, but mount continues, that would lead to filesystem
> corruption, very bad.
> 
> If it prevents mounting, and needs an updated kernel and/or e2fsprogs to
> clear (presumably the kernel will not enable this itself unless told to
> do so by EXT4_FEATURE_INCOMPAT_METADATA_CSUM), that is not so bad, and
> will still allow downgrading to an older kernel as long as the journal is
> replayed.

rocompat/incompat feature flag mismatches both cause ext4 to error out of
ext4_fill_super.  It doesn't appear to try to replay at all.

I think e2fsck actually tries to fix it, where "fix it" seems to mean "blow it
away"... not sure though.  I'll have a closer look Monday morning.

> > I decided to dig deeper to see what exactly the journal checksum covers.  It
> > appears to me that the superblock, revocation blocks, and commit blocks are not
> > covered by a checksum.  Revocation blocks ought to be checksummed because a
> > lost write involving the second sector of a suitably large revocation block
> > could result in the wrong blocks being skipped during recovery.  It seems like
> > it would be easy to extend the current journal_checksum feature to cover the
> > commit block, and adding a checksum to the superblock seems trivial.
> > 
> > Lastly, if I'm already making change, I might as well bake the journal UUID
> > into the checksum as well.  The transaction ID is already in each metadata
> > block by virtue of the common block header.
> > 
> > So to summarize, I propose:
> > 
> > 1. Adding a JBD2_FEATURE_ROCOMPAT_CHECKSUM_V2 field, which provides:
> > 2. A u8 field at offset 0x50 in the superblock which identifies the checksum
> >   algorithm that's in use;
> > 3. A u32 field at offset 0x54 in the superblock to hold the superblock's
> >   checksum;
> 
> Why not put it at the end of the superblock, so that it can cover the whole
> thing?

There's a s_users field sitting at the end of the structure.  We probably don't
want that structure to grow beyond 1024 bytes for the sake of small-block
filesystems.  Any recommendations?

> > 4. Changing the revocation block code to put a checksum in the 4 bytes
> >   following the revocation data, and to ensure those 4 bytes always exist;
> 
> It would be easier to see the changes if you included the structs.

Too bad the ext4 wiki is still down. :(

/*
 * The journal superblock.  All fields are in big-endian byte order.
 */
typedef struct journal_superblock_s
{
/* 0x0000 */
        journal_header_t s_header;

/* 0x000C */
        /* Static information describing the journal */
        __be32  s_blocksize;            /* journal device blocksize */
        __be32  s_maxlen;               /* total blocks in journal file */
        __be32  s_first;                /* first block of log information */

/* 0x0018 */
        /* Dynamic information describing the current state of the log */
        __be32  s_sequence;             /* first commit ID expected in log */
        __be32  s_start;                /* blocknr of start of log */

/* 0x0020 */
        /* Error value, as set by jbd2_journal_abort(). */
        __be32  s_errno;

/* 0x0024 */
        /* Remaining fields are only valid in a version-2 superblock */
        __be32  s_feature_compat;       /* compatible feature set */
        __be32  s_feature_incompat;     /* incompatible feature set */
        __be32  s_feature_ro_compat;    /* readonly-compatible feature set */
/* 0x0030 */
        __u8    s_uuid[16];             /* 128-bit uuid for journal */

/* 0x0040 */
        __be32  s_nr_users;             /* Nr of filesystems sharing log */

        __be32  s_dynsuper;             /* Blocknr of dynamic superblock copy*/

/* 0x0048 */
        __be32  s_max_transaction;      /* Limit of journal blocks per trans.*/
        __be32  s_max_trans_data;       /* Limit of data blocks per trans. */

/* 0x0050 */
	__u8	s_checksum_type;	/* checksum type */
	__u8	s_char_pad[3];		/* not used */
	__be32	s_checksum;		/* crc32c(superblock) */
        __u32   s_padding[42];

/* 0x0100 */
        __u8    s_users[16*48];         /* ids of all fs'es sharing the log */
/* 0x0400 */
} journal_superblock_t;

> > 5. Adding the journal UUID to each checksum computation;
> > 6. Extend the commit checksum to cover the commit block itself, with the commit
> >   block checksum field zeroed during the computation, of course;
> > 7. Changing the default algorithm to crc32c; and
> > 8. Updating ext4 to enable both checksum fields at journal load time, if the
> >   user supplies the journal_checksum mount option.
> 
> Probably this should also be conditional on the ext4 code using the
> EXT4_FEATURE_INCOMPAT_METADATA_CSUM, so that we know the kernel will
> be able to recover, and the user has explicitly requested this.
> 
> There is a mechanism for the ext4 code to pass features to the jbd2 code
> already, so this shouldn't be a problem.

So you're saying that if metadata_csum is set in ext4 and the user mounts with
journal_checksum, then set the JBD checksum v2 flag?  Probably makes sense.

How about ocfs?

--D
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

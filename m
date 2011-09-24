From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] jbd2 metadata checksumming
Date: Fri, 23 Sep 2011 18:07:46 -0600
Message-ID: <4FFF8C58-425B-431C-9144-0A6B7568A39F@dilger.ca>
References: <20110923225135.GN12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, Joel Becker <jlbec@evilplan.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110923225135.GN12086@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-09-23, at 4:51 PM, Darrick J. Wong wrote:
> While I'm working on adding metadata checksumming to ext4, I figured that I
> ought to look into the similar feature in jbd2.  At first I thought I'd simply
> change the default crc algorithm to crc32c and update the field in the commit
> block, but then it was suggested to me that I move that field into the journal
> superblock so that during recovery we don't have to scan ahead through the
> transaction to find the commit block so that we can learn the algorithm type.
> 
> Doing that seems to require a format change to the superblock to add that
> field.  I think that adding the crc-type field to the superblock is a rocompat
> change since we're not changing existing fields, just adding fields.  It looks
> like the kernel and e2fsprogs code both reject a journal if they find unknown
> rocompat bits set.  (Using a journal in ro mode is not useful.)

The question is whether the "rejected journal" means that it is ignored
during recovery and not replayed at all, or if it prevents mounting?  If it
is ignored and not replayed, but mount continues, that would lead to filesystem
corruption, very bad.

If it prevents mounting, and needs an updated kernel and/or e2fsprogs to
clear (presumably the kernel will not enable this itself unless told to
do so by EXT4_FEATURE_INCOMPAT_METADATA_CSUM), that is not so bad, and
will still allow downgrading to an older kernel as long as the journal is
replayed.

> I decided to dig deeper to see what exactly the journal checksum covers.  It
> appears to me that the superblock, revocation blocks, and commit blocks are not
> covered by a checksum.  Revocation blocks ought to be checksummed because a
> lost write involving the second sector of a suitably large revocation block
> could result in the wrong blocks being skipped during recovery.  It seems like
> it would be easy to extend the current journal_checksum feature to cover the
> commit block, and adding a checksum to the superblock seems trivial.
> 
> Lastly, if I'm already making change, I might as well bake the journal UUID
> into the checksum as well.  The transaction ID is already in each metadata
> block by virtue of the common block header.
> 
> So to summarize, I propose:
> 
> 1. Adding a JBD2_FEATURE_ROCOMPAT_CHECKSUM_V2 field, which provides:
> 2. A u8 field at offset 0x50 in the superblock which identifies the checksum
>   algorithm that's in use;
> 3. A u32 field at offset 0x54 in the superblock to hold the superblock's
>   checksum;

Why not put it at the end of the superblock, so that it can cover the whole
thing?

> 4. Changing the revocation block code to put a checksum in the 4 bytes
>   following the revocation data, and to ensure those 4 bytes always exist;

It would be easier to see the changes if you included the structs.

> 5. Adding the journal UUID to each checksum computation;
> 6. Extend the commit checksum to cover the commit block itself, with the commit
>   block checksum field zeroed during the computation, of course;
> 7. Changing the default algorithm to crc32c; and
> 8. Updating ext4 to enable both checksum fields at journal load time, if the
>   user supplies the journal_checksum mount option.

Probably this should also be conditional on the ext4 code using the
EXT4_FEATURE_INCOMPAT_METADATA_CSUM, so that we know the kernel will
be able to recover, and the user has explicitly requested this.

There is a mechanism for the ext4 code to pass features to the jbd2 code
already, so this shouldn't be a problem.


Cheers, Andreas

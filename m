From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: xattr-in-inode support
Date: Thu, 20 Apr 2017 15:22:46 -0600
Message-ID: <61D86619-018B-4ED3-B0FB-C391F6442315@dilger.ca>
References: <86611BEE-5695-4047-9404-D2D3E232318A@dilger.ca>
 <20170414132720.je5ca2c5fibjn6qq@thunk.org>
 <20170420075823.GA18523@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_973F3C5D-5592-4212-ACB7-276176DD01F7";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        James Simmons <jsimmons@infradead.org>, tahsin@google.com,
        nauman@google.com, tytso@google.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34108 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947486AbdDTVW4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Apr 2017 17:22:56 -0400
Received: by mail-io0-f194.google.com with SMTP id h41so20983747ioi.1
        for <linux-ext4@vger.kernel.org>; Thu, 20 Apr 2017 14:22:56 -0700 (PDT)
In-Reply-To: <20170420075823.GA18523@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_973F3C5D-5592-4212-ACB7-276176DD01F7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 20, 2017, at 1:58 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> On Fri 14-04-17 09:27:20, Ted Tso wrote:
>> To summarize the discussion that we had on this week's ext4
>> teleconference call, while discussing ways in which we might extend
>> ext4's extended attributes to provide better support for Samba.
>>=20
>> Andreas pointed out that we already have an unused field,
>> e_value_block, in ext4_xattr_entry structure:
>>=20
>> struct ext4_xattr_entry {
>> 	__u8	e_name_len;	/* length of name */
>> 	__u8	e_name_index;	/* attribute name index */
>> 	__le16	e_value_offs;	/* offset in disk block of value */
>> 	__le32	e_value_block;	/* disk block attribute is stored on =
(n/i) */
>> 	__le32	e_value_size;	/* size of attribute value */
>> 	__le32	e_hash;		/* hash value of name and value */
>> 	char	e_name[0];	/* attribute name */
>> };
>>=20
>> It's only a 32-bit field, and it was repurposed in a Lustre-specific
>> feature, EXT4_FEATURE_INCOMPAT_EA_INODE as e_value_inum (since inodes
>> are only 32-bit today).  If this feature flag is enabled, then =
kernels
>> which understand the feature will treat e_value_block as an inode
>> number, and if it is non-zero, the value of that extended attribute =
is
>> stored in the inode.  This ends up burning a lot of extra inodes for
>> each extended attribute, which is why there was never much excitement
>> for this patch going upstream.
>>=20
>> However, we could extend this feature (it will almost certainly
>> require a new INCOMPAT feature flag) such that a particular inode
>> could be referenced from multiple strut ext4_xattr_entry's (from
>> multiple inodes or from a single inode), since the inode for the =
xattr
>> body already has a ref count, i_links_count.  And given that on a
>> typical Windows CIFS file system, there will be dozens of unique
>> acl's, the problem of exhausting inodes for xattrs won't be a issue =
in
>> this case.
>>=20
>>=20
>> However, another approach that we discussed on the weekly conference
>> call was to change e_value_size to be an 16-bit field, and to use the
>> high 16 bits for flags, where one of the flags bits (say, the MSB)
>> would mean that e_value_block and e_value_size should be treated as a
>> 48-bit block number, where the block could be stored.
>>=20
>> Thinking about this some more, we can use another 4 bits from the =
high
>> bits of e_value_size as a 16 bit number n, where if n=3D0, the block
>> number is stored in e_Value_block and e_value_size as above, and if n
>>> 1, that there are additional blocks for the xattr value, which will
>> be stored in the place where the xattr value would normally be stored
>> (e.g, in the inline xattr space or in the external xattr block).
>>=20
>> So pictorally, it would look like this:
>>=20
>> +----------------+----------------+
>> | 128-byte inode | in-line xattr  |
>> +----------------+----------------+
>>                /                  \
>>               /                    \
>>              /                      \
>>  +---------------------------------------------+
>>  | XE | XE | XE |               | XV | XV | XV |   XE =3D=3D =
xattr_entry   XV =3D=3D xattr value
>>  +---------------------------------------------+
>>           /      \             /     \
>>          /        \           /       \
>>         /          \         /         \
>>    +--------------------+  +-------------+
>>    |   ...  | blk0 |... |  | blk1 | blk2 |
>>    +--------------------+  +-------------+
>>=20
>> (to those using gmail; please view the above in a fixed-width font, =
or
>> use "show original")
>>=20
>> So in this picture, XE is the ext4_xattr_entry, and in this case, the
>> high bits of e_value_size indicate e_value_block and the low bits of
>> e_value_size indicate the location of the first 4k block where the
>> xattr value is to be stored, and if one were to look at region of
>> memory indicated by e_value_offs, there would be two 8-byte block
>> numbers indicating the location of the 2nd and 3rd file system blocks
>> where the xattr value can be found.
>>=20
>> In the external xattr value blocks, at the beginning of the first
>> block (e.g., at blk0), there will be an ext4_xattr_header, so we can
>> take advantage of h_refcount field, but with the following changes:
>>=20
>> * The low 16 bits of h_blocks will be used for the size of the xattr;
>>  the high bits of h_blocks must be zero (for now).
>>=20
>> * The h_hash field will be a crc32c of the value of the xattr stored
>>  in the external xattr value block(s).
>>=20
>> * The h_checksum field will be calculated so that the crc32c covers
>>  only the ext4_xattr_header, instead of the entire xattrblock.  e.g.,
>>  crc32c(fs uuid || id || xattr header), where id is the inode number
>>  if refcount =3D 1, and blknum otherwise.
>>=20
>> What are the advantages of this approach over the Lustre's
>> xattr-value-in-inode approach?  First, we don't need to burn inodes
>> for the xattr value.  This could potentially be an issue for Windows
>> SID's, since there the number of SID's is roughly equal to number of
>> users plus the number of groups.  And for a large enterprise with
>> O(100,000) employees, we could burn a pretty large number of inodes.
>> The other advantage of this scheme is that h_refcount field is 32
>> bits, where as the inode's i_links_count field is only 16 bits, and
>> there could very easily be more than 64k files that might share the
>> same Windows ACL or Windows SID.  So we would need to figure out some
>> way of dealing with an extended i_links_count field if we went with
>> the xattr-value-in-inode approach.
>=20
> So the proposal seems to have implicit in it that we will be
> "deduplicating" xattr values. Currently we deduplicate only full =
external
> xattr blocks (which possibly contain more xattrs). Any idea how big =
win
> that is going to be over deduplicating only full sets of xattrs?

We discussed storing xattrs to be shared with one-value-per-block so =
that
they could be shared independently of other xattrs that are unique.  In
general, it makes sense to fit unique xattrs into the inode (if =
possible)
and put shared xattrs into a common location (if needed) to reduce space
usage and disk IO.  That said, if everything fits into the inode, even
the shared xattrs are extra overhead (refcounting, lock contention, etc)
that isn't needed.

The good news is that there are still significant benefits if the =
sharing
is not perfect, so this can be done opportunistically (e.g. share up to
N times for an xattr block, look for other identical "under-shared" =
xattrs
in cache to add new references, or create a new one if none are found).

> One idea I had in mind was that one way of supporting larger xattrs =
would
> be to support something like xattr fork - i.e., in the xattr space of =
the
> inode we would have root of an extent tree describing xattr space of =
the
> inode. Then inside the space described by the extent tree would be =
stored
> xattrs - possibly in the same format as they are currently stored in a
> block (we would just redefine that e_value_block+e_value_offs describe =
the
> offset of xattr value inside the xattr space).

Yes, this is what I was trying to get at with my previous email as well.
There isn't much difference between allocating a bunch of blocks =
directly
as the xattr space vs. an inode that is allocating those blocks.  The =
main
difference from the current xattr inode implementation is that this =
packs
multiple xattrs into a single inode, while the current code only stores =
a
single value starting at offset=3D0, without any header.

> =46rom the perspective of "disk reads required to get the xattrs" this
> proposal should be similar as above (xattr space description will =
mostly
> fully fit in the xattr space of the inode) so we will just go and read
> the xattr headers and then value.  It has an advantage that it =
basically
> does not limit xattr size or number of xattrs. It has the disadvantage
> that deduplication possibilities are lower.

If a single xattr inode was referenced by multiple inodes then the =
sharing
could be the same.  IMHO, we'd want to limit the number of inodes =
sharing
the xattr inode anyway, so the 2^16 link count on the inode wouldn't be =
a
real issue.  Storing shared xattrs one-per-block would increase sharing.

The difficulty would be how to distinguish xattrs that are NOT shared by =
a
given inode?  We wouldn't want the unshared xattrs to leak between =
inodes.
One option would be to store the "owning" inode into the xattr entry for
unique xattrs, and the refcount into shared xattrs (distinguished by a =
flag).

Cheers, Andreas






--Apple-Mail=_973F3C5D-5592-4212-ACB7-276176DD01F7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY+SampIg59Q01vtYRAlz6AJ9OW5/vAhbDe9NZjUYDjtX7FEQ1xgCgqNUB
JD/1nb5jqxDX4kikaT0GhOQ=
=5m6r
-----END PGP SIGNATURE-----

--Apple-Mail=_973F3C5D-5592-4212-ACB7-276176DD01F7--

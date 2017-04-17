From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: xattr-in-inode support
Date: Mon, 17 Apr 2017 13:07:45 -0600
Message-ID: <5E0ECF3A-0475-44B4-BE4A-A1B9119DEB9B@dilger.ca>
References: <86611BEE-5695-4047-9404-D2D3E232318A@dilger.ca>
 <20170414132720.je5ca2c5fibjn6qq@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_84A5A953-B16D-4BA9-81DF-4731B6D8D75D";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        James Simmons <jsimmons@infradead.org>, tahsin@google.com,
        nauman@google.com, Theodore Tso <tytso@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35049 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754912AbdDQTHw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Apr 2017 15:07:52 -0400
Received: by mail-io0-f193.google.com with SMTP id d203so26427449iof.2
        for <linux-ext4@vger.kernel.org>; Mon, 17 Apr 2017 12:07:51 -0700 (PDT)
In-Reply-To: <20170414132720.je5ca2c5fibjn6qq@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_84A5A953-B16D-4BA9-81DF-4731B6D8D75D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 14, 2017, at 7:27 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> To summarize the discussion that we had on this week's ext4
> teleconference call, while discussing ways in which we might extend
> ext4's extended attributes to provide better support for Samba.
>=20
> Andreas pointed out that we already have an unused field,
> e_value_block, in ext4_xattr_entry structure:
>=20
> struct ext4_xattr_entry {
> 	__u8	e_name_len;	/* length of name */
> 	__u8	e_name_index;	/* attribute name index */
> 	__le16	e_value_offs;	/* offset in disk block of value */
> 	__le32	e_value_block;	/* disk block attribute is stored on =
(n/i) */
> 	__le32	e_value_size;	/* size of attribute value */
> 	__le32	e_hash;		/* hash value of name and value */
> 	char	e_name[0];	/* attribute name */
> };
>=20
> It's only a 32-bit field, and it was repurposed in a Lustre-specific
> feature, EXT4_FEATURE_INCOMPAT_EA_INODE as e_value_inum (since inodes
> are only 32-bit today).  If this feature flag is enabled, then kernels
> which understand the feature will treat e_value_block as an inode
> number, and if it is non-zero, the value of that extended attribute is
> stored in the inode.  This ends up burning a lot of extra inodes for
> each extended attribute, which is why there was never much excitement
> for this patch going upstream.
>=20
> However, we could extend this feature (it will almost certainly
> require a new INCOMPAT feature flag) such that a particular inode
> could be referenced from multiple strut ext4_xattr_entry's (from
> multiple inodes or from a single inode), since the inode for the xattr
> body already has a ref count, i_links_count.  And given that on a
> typical Windows CIFS file system, there will be dozens of unique
> acl's, the problem of exhausting inodes for xattrs won't be a issue in
> this case.
>=20
>=20
> However, another approach that we discussed on the weekly conference
> call was to change e_value_size to be an 16-bit field, and to use the
> high 16 bits for flags, where one of the flags bits (say, the MSB)
> would mean that e_value_block and e_value_size should be treated as a
> 48-bit block number, where the block could be stored.
>=20
> Thinking about this some more, we can use another 4 bits from the high
> bits of e_value_size as a 16 bit number n, where if n=3D0, the block
> number is stored in e_value_block and e_value_size as above, and if n
>> 1, that there are additional blocks for the xattr value, which will
> be stored in the place where the xattr value would normally be stored
> (e.g, in the inline xattr space or in the external xattr block).
> So pictorally, it would look like this:
>=20
> +----------------+----------------+
> | 128-byte inode | in-line xattr  |
> +----------------+----------------+
>                /                  \
>               /                    \
>              /                      \
>  +---------------------------------------------+
>  | XE | XE | XE |               | XV | XV | XV |   XE =3D=3D =
xattr_entry   XV =3D=3D xattr value
>  +---------------------------------------------+
>           /      \             /     \
>          /        \           /       \
>         /          \         /         \
>    +--------------------+  +-------------+
>    |   ...  | blk0 |... |  | blk1 | blk2 |
>    +--------------------+  +-------------+
>=20
> (to those using gmail; please view the above in a fixed-width font, or
> use "show original")
>=20
> So in this picture, XE is the ext4_xattr_entry, and in this case, the
> high bits of e_value_size indicate e_value_block and the low bits of
> e_value_size indicate the location of the first 4k block where the
> xattr value is to be stored, and if one were to look at region of
> memory indicated by e_value_offs, there would be two 8-byte block
> numbers indicating the location of the 2nd and 3rd file system blocks
> where the xattr value can be found.

Given that this is a new INCOMPAT feature, wouldn't it be a lot more =
clear
to just create a new struct ext4_xattr_entry2 and struct =
ext4_xattr_header2
that had the right fields?  So long as the magic values were in the same
offset we could check at runtime which version of the struct was in use.

Also, IMHO it doesn't make sense to try and address block numbers =
directly
in this case, but rather just reference an inode number and then =
relative
offsets within the inode.  That allows flexibility in how the blocks are
addressed, either block mapped or extent mapped or some future type, and
will save space in the xattr entry since it doesn't need to specify both
the block number and offset.

> In the external xattr value blocks, at the beginning of the first
> block (e.g., at blk0), there will be an ext4_xattr_header, so we can
> take advantage of h_refcount field, but with the following changes:
>=20
> * The low 16 bits of h_blocks will be used for the size of the xattr;
>  the high bits of h_blocks must be zero (for now).
>=20
> * The h_hash field will be a crc32c of the value of the xattr stored
>  in the external xattr value block(s).
>=20
> * The h_checksum field will be calculated so that the crc32c covers
>  only the ext4_xattr_header, instead of the entire xattrblock.  e.g.,
>  crc32c(fs uuid || id || xattr header), where id is the inode number
>  if refcount =3D 1, and blknum otherwise.
>=20
> What are the advantages of this approach over the Lustre's
> xattr-value-in-inode approach?  First, we don't need to burn inodes
> for the xattr value.  This could potentially be an issue for Windows
> SID's, since there the number of SID's is roughly equal to number of
> users plus the number of groups.  And for a large enterprise with
> O(100,000) employees, we could burn a pretty large number of inodes.

Sure, the Lustre case is mostly used for very large files (e.g. hundreds
of GB or TB in size) with complex layouts across thousands of servers,
so there aren't expected to be a large number of such files.

> The other advantage of this scheme is that h_refcount field is 32
> bits, where as the inode's i_links_count field is only 16 bits, and
> there could very easily be more than 64k files that might share the
> same Windows ACL or Windows SID.

IMHO, it isn't necessarily desirable to have a single xattr that is
shared by so many inodes.  In cases where filesystem metadata is shared
so widely it can be reconstructed by e2fsck, but in this case the xattr
would be lost.  It would be fine to have an upper limit like 2^16 for
the number of inodes that reference the shared xattr to limit the data
that would be lost in case of corruption.

Cheers, Andreas

> So we would need to figure out some way of dealing with an extended
> i_links_count field if we went with the xattr-value-in-inode approach.
>=20
>=20
> We don't need to make this to be an either-or choice, of course.  We
> could integrate the Lustre approach as well as this latter approach
> which is more optimized for Windows ACL's.  And I do want to reiterate
> that this is just a rough sketch as a design doc.  I'm sure we may
> want to make changes to it, but hopefully it will serve as a good
> starting point for discussion.
>=20
> Cheers,
>=20
> 						- Ted
>=20
>=20
> On Thu, Apr 13, 2017 at 01:58:56PM -0600, Andreas Dilger wrote:
>> Large xattr support is implemented for =
EXT4_FEATURE_INCOMPAT_EA_INODE.
>>=20
>> If the size of an xattr value is larger than will fit in a single
>> external block, then the xattr value will be saved into the body
>> of an external xattr inode.
>>=20
>> The also helps support a larger number of xattr, since only the =
headers
>> will be stored in the in-inode space or the single external block.
>>=20
>> The inode is referenced from the xattr header via "e_value_inum",
>> which was formerly "e_value_block", but that field was never used.
>> The e_value_size still contains the xattr size so that listing
>> xattrs does not need to look up the inode if the data is not =
accessed.
>>=20
>> struct ext4_xattr_entry {
>> 	__u8	e_name_len;	/* length of name */
>> 	__u8	e_name_index;	/* attribute name index */
>> 	__le16	e_value_offs;	/* offset in disk block of value */
>> 	__le32	e_value_inum;	/* inode in which value is stored */
>> 	__le32	e_value_size;	/* size of attribute value */
>> 	__le32	e_hash;		/* hash value of name and value */
>> 	char	e_name[0];	/* attribute name */
>> };
>>=20
>> The xattr inode is marked with the EXT4_EA_INODE_FL flag and also
>> holds a back-reference to the owning inode in its i_mtime field,
>> allowing the ext4/e2fsck to verify the correct inode is accessed.
>=20
>=20


Cheers, Andreas






--Apple-Mail=_84A5A953-B16D-4BA9-81DF-4731B6D8D75D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY9RKCpIg59Q01vtYRArrQAJwJejhVwXJ088l6e4iXN/wWklADxgCg3cah
lxHK6p+jKeJIK0/OofMBJBg=
=A5IL
-----END PGP SIGNATURE-----

--Apple-Mail=_84A5A953-B16D-4BA9-81DF-4731B6D8D75D--

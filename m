From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 07/28] ext4: call journal revoke when freeing ea_inode
 blocks
Date: Mon, 5 Jun 2017 16:08:19 -0600
Message-ID: <29C355D5-EE41-4942-9EF8-CD249CDE5804@dilger.ca>
References: <20170531081517.11438-1-tahsin@google.com>
 <20170531081517.11438-7-tahsin@google.com>
 <20170531161257.GI4510@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_CEC49A21-C557-4612-B724-2797AFC3B428";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531161257.GI4510@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_CEC49A21-C557-4612-B724-2797AFC3B428
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 31, 2017, at 10:12 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Wed, May 31, 2017 at 01:14:56AM -0700, Tahsin Erdogan wrote:
>> ea_inode contents are treated as metadata, that's why it is journaled
>> during initial writes. Failing to call revoke during freeing could =
cause
>> user data to be overwritten with original ea_inode contents during =
journal
>> replay.
>>=20
>> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
>> ---
>> fs/ext4/extents.c  | 3 ++-
>> fs/ext4/indirect.c | 3 ++-
>> 2 files changed, 4 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 3e36508610b7..e0a8425ff74d 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2488,7 +2488,8 @@ int ext4_ext_index_trans_blocks(struct inode =
*inode, int extents)
>>=20
>> static inline int get_default_free_blocks_flags(struct inode *inode)
>> {
>> -	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
>> +	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
>> +	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
>> 		return EXT4_FREE_BLOCKS_METADATA | =
EXT4_FREE_BLOCKS_FORGET;
>> 	else if (ext4_should_journal_data(inode))
>> 		return EXT4_FREE_BLOCKS_FORGET;
>> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
>> index bc15c2c17633..7ffa290cbb8e 100644
>> --- a/fs/ext4/indirect.c
>> +++ b/fs/ext4/indirect.c
>> @@ -829,7 +829,8 @@ static int ext4_clear_blocks(handle_t *handle, =
struct inode *inode,
>> 	int	flags =3D EXT4_FREE_BLOCKS_VALIDATED;
>> 	int	err;
>>=20
>> -	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
>> +	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
>> +	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
>=20
> I appreciate the thoroughness of doing this even for blockmapped
> ea_inode files, and I'm not complaining about this hunk at all. :)
>=20
> However, please consider requiring the extents feature + format as a
> prerequisite for ea_inodes.  ext4 has traditionally been very ...
> permissive about supporting a diverse range of feature options, but =
the
> cost of that diversity is that the feature support matrix that the
> community has to support is already untestably large.
>=20
> I think it would be wise not to support !extents && ea_inode,
> particularly since blockmaps aren't protected by metadata_csum and so =
in
> the long run it's probably best to minimize the introduction of new
> blockmap files (on ext4 anyway).

Sorry, I have to disagree on this one.

The Lustre code ONLY uses the xattr inode with non-extent (indirect)
mapped inodes on the metadata target.  This is because the MDT only
stores inodes and directories (and a handful of regular files) that
don't benefit from extents at all, but rather are hurt because directory
blocks are typically allocated incrementally over time and result in
fragmented block numbers.  In this case, extents can increase the dir
size by 3x over indirect mapped files without any benefit.

Since the MDT only holds inodes, it never needs to be larger than 16TB
(by default only 2KB/inode gives a max MDT size of 8TB) so there is no
need for more than 2^32 blocks in the filesystem.

Cheers, Andreas

>=20
> --D
>=20
>> 		flags |=3D EXT4_FREE_BLOCKS_FORGET | =
EXT4_FREE_BLOCKS_METADATA;
>> 	else if (ext4_should_journal_data(inode))
>> 		flags |=3D EXT4_FREE_BLOCKS_FORGET;
>> --
>> 2.13.0.219.gdb65acc882-goog


Cheers, Andreas






--Apple-Mail=_CEC49A21-C557-4612-B724-2797AFC3B428
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZNdZVpIg59Q01vtYRAqGCAJ40sEwHphe27COU98lK4Drj8EMiuQCgrezn
Yvi+VJymxCToPKZ1iTrkyPc=
=cCKe
-----END PGP SIGNATURE-----

--Apple-Mail=_CEC49A21-C557-4612-B724-2797AFC3B428--

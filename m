From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Add statx support
Date: Fri, 31 Mar 2017 15:06:57 -0600
Message-ID: <801D09BA-8555-4CAC-AAF3-B5471F8EDC75@dilger.ca>
References: <149097411100.20684.13845539992018531553.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_9B2DC43F-A487-42E8-A5D8-C647878F9A97";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <149097411100.20684.13845539992018531553.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_9B2DC43F-A487-42E8-A5D8-C647878F9A97
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 31, 2017, at 9:28 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> Return enhanced file attributes from the Ext4 filesystem.  This =
includes
> the following:
>=20
> (1) The inode creation time (i_crtime) as stx_btime, setting =
STATX_BTIME.
>=20
> (2) Certain FS_xxx_FL flags are mapped to stx_attribute flags.
>=20
> This requires that all ext4 inodes have a getattr call, not just some =
of
> them, so to this end, split the ext4_getattr() function and only call =
part
> of it where appropriate.
>=20
> Example output:
>=20
> 	[root@andromeda ~]# touch foo
> 	[root@andromeda ~]# chattr +ai foo
> 	[root@andromeda ~]# /tmp/test-statx foo
> 	statx(foo) =3D 0
> 	results=3Dfff
> 	  Size: 0               Blocks: 0          IO Block: 4096    =
regular file
> 	Device: 08:12           Inode: 2101950     Links: 1
> 	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
> 	Access: 2016-02-11 17:08:29.031795451+0000
> 	Modify: 2016-02-11 17:08:29.031795451+0000
> 	Change: 2016-02-11 17:11:11.987790114+0000
> 	 Birth: 2016-02-11 17:08:29.031795451+0000
> 	Attributes: 0000000000000030 (-------- -------- -------- =
-------- -------- -------- -------- --ai----)
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

One minor nit below, but the current patch is OK.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4247d8d25687..5d02b922afa3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5390,11 +5390,40 @@ int ext4_setattr(struct dentry *dentry, struct =
iattr *attr)
> int ext4_getattr(const struct path *path, struct kstat *stat,
> 		 u32 request_mask, unsigned int query_flags)
> {
> -	struct inode *inode;
> -	unsigned long long delalloc_blocks;
> +	struct inode *inode =3D d_inode(path->dentry);
> +	struct ext4_inode *raw_inode;
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	unsigned int flags;
> +
> +	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
> +		stat->result_mask |=3D STATX_BTIME;
> +		stat->btime.tv_sec =3D ei->i_crtime.tv_sec;
> +		stat->btime.tv_nsec =3D ei->i_crtime.tv_nsec;
> +	}
> +
> +	flags =3D ei->i_flags & EXT4_FL_USER_VISIBLE;

Strictly speaking, since the relevant flags are being checked =
individually,
there is no value to masking with EXT4_FL_USER_VISIBLE.  That is only
required if you are returning the whole "flags" value directly.

Cheers, Andreas

> +	if (flags & EXT4_APPEND_FL)
> +		stat->attributes |=3D STATX_ATTR_APPEND;
> +	if (flags & EXT4_COMPR_FL)
> +		stat->attributes |=3D STATX_ATTR_COMPRESSED;
> +	if (flags & EXT4_ENCRYPT_FL)
> +		stat->attributes |=3D STATX_ATTR_ENCRYPTED;
> +	if (flags & EXT4_IMMUTABLE_FL)
> +		stat->attributes |=3D STATX_ATTR_IMMUTABLE;
> +	if (flags & EXT4_NODUMP_FL)
> +		stat->attributes |=3D STATX_ATTR_NODUMP;
>=20
> -	inode =3D d_inode(path->dentry);
> 	generic_fillattr(inode, stat);
> +	return 0;
> +}
> +
> +int ext4_file_getattr(const struct path *path, struct kstat *stat,
> +		      u32 request_mask, unsigned int query_flags)
> +{
> +	struct inode *inode =3D d_inode(path->dentry);
> +	u64 delalloc_blocks;
> +
> +	ext4_getattr(path, stat, request_mask, query_flags);
>=20
> 	/*
> 	 * If there is inline data in the inode, the inode will normally =
not






--Apple-Mail=_9B2DC43F-A487-42E8-A5D8-C647878F9A97
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY3sTzpIg59Q01vtYRAsQDAJwNNBoDng6KoWPft6OI8nxNk5n4tQCfZY24
I+3eSIWF3eITq57FZ4IQKY8=
=p5pD
-----END PGP SIGNATURE-----

--Apple-Mail=_9B2DC43F-A487-42E8-A5D8-C647878F9A97--

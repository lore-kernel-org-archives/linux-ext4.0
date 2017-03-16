From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Add statx support
Date: Thu, 16 Mar 2017 15:46:20 -0600
Message-ID: <E2F29C99-0A2F-4F97-AC1E-863F4821CFB3@dilger.ca>
References: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F87B3221-D8A4-493C-B922-A8190D7DB540";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_F87B3221-D8A4-493C-B922-A8190D7DB540
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 16, 2017, at 5:35 AM, David Howells <dhowells@redhat.com> wrote:
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

> ---
>=20
> fs/ext4/ext4.h    |    1 +
> fs/ext4/file.c    |    2 +-
> fs/ext4/inode.c   |   36 +++++++++++++++++++++++++++++++++---
> fs/ext4/namei.c   |    2 ++
> fs/ext4/symlink.c |    2 ++
> 5 files changed, 39 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f493af666591..fb69ee2388db 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2466,6 +2466,7 @@ extern int  ext4_setattr(struct dentry *, struct =
iattr *);
> extern int  ext4_getattr(const struct path *, struct kstat *, u32, =
unsigned int);
> extern void ext4_evict_inode(struct inode *);
> extern void ext4_clear_inode(struct inode *);
> +extern int  ext4_file_getattr(const struct path *, struct kstat *, =
u32, unsigned int);

(style) should this wrap at 80 columns?

> extern int  ext4_sync_inode(handle_t *, struct inode *);
> extern void ext4_dirty_inode(struct inode *, int);
> extern int ext4_change_inode_journal_flag(struct inode *, int);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 8210c1f43556..cefa9835f275 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -744,7 +744,7 @@ const struct file_operations ext4_file_operations =
=3D {
>=20
> const struct inode_operations ext4_file_inode_operations =3D {
> 	.setattr	=3D ext4_setattr,
> -	.getattr	=3D ext4_getattr,
> +	.getattr	=3D ext4_file_getattr,
> 	.listxattr	=3D ext4_listxattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7385e6a6b6cb..5450e1eade1d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5390,11 +5390,41 @@ int ext4_setattr(struct dentry *dentry, struct =
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
> +	ext4_get_inode_flags(ei);
> +	flags =3D ei->i_flags & EXT4_FL_USER_VISIBLE;
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
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6ad612c576fc..07e5e1405771 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3912,6 +3912,7 @@ const struct inode_operations =
ext4_dir_inode_operations =3D {
> 	.tmpfile	=3D ext4_tmpfile,
> 	.rename		=3D ext4_rename2,
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> @@ -3920,6 +3921,7 @@ const struct inode_operations =
ext4_dir_inode_operations =3D {
>=20
> const struct inode_operations ext4_special_inode_operations =3D {
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index 73b184d161fc..4c6b23a0603e 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -91,11 +91,13 @@ const struct inode_operations =
ext4_encrypted_symlink_inode_operations =3D {
> const struct inode_operations ext4_symlink_inode_operations =3D {
> 	.get_link	=3D page_get_link,
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> };
>=20
> const struct inode_operations ext4_fast_symlink_inode_operations =3D {
> 	.get_link	=3D simple_get_link,
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> };
>=20


Cheers, Andreas






--Apple-Mail=_F87B3221-D8A4-493C-B922-A8190D7DB540
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYywetpIg59Q01vtYRAvUYAJ4pyWQVYQlJymWjPrfmkp+3A4vkfgCeNucZ
RE8o2K5AHgkqf47D0+x9XuE=
=MBZG
-----END PGP SIGNATURE-----

--Apple-Mail=_F87B3221-D8A4-493C-B922-A8190D7DB540--

From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 07/11] ext2: Remove ext2_get_inode_flags()
Date: Wed, 12 Apr 2017 22:05:10 -0600
Message-ID: <09D4377E-DD27-4CC6-A9FC-00CBD8CE3701@dilger.ca>
References: <20170412072611.29017-1-jack@suse.cz>
 <20170412072611.29017-8-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_84CA34E2-43AF-45F5-8B45-E25CC765B1E0";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        reiserfs-devel@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35603 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750755AbdDMEFN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Apr 2017 00:05:13 -0400
Received: by mail-io0-f193.google.com with SMTP id d203so8464292iof.2
        for <linux-ext4@vger.kernel.org>; Wed, 12 Apr 2017 21:05:13 -0700 (PDT)
In-Reply-To: <20170412072611.29017-8-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_84CA34E2-43AF-45F5-8B45-E25CC765B1E0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 12, 2017, at 1:26 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> Now that all places setting inode->i_flags that should be reflected in
> on-disk flags are gone, we can remove ext2_get_inode_flags() call.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext2/ext2.h  |  1 -
> fs/ext2/inode.c | 20 --------------------
> fs/ext2/ioctl.c |  1 -
> 3 files changed, 22 deletions(-)
>=20
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 5e64de9c5093..c7cfe9afa375 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -779,7 +779,6 @@ extern void ext2_evict_inode(struct inode *);
> extern int ext2_get_block(struct inode *, sector_t, struct buffer_head =
*, int);
> extern int ext2_setattr (struct dentry *, struct iattr *);
> extern void ext2_set_inode_flags(struct inode *inode);
> -extern void ext2_get_inode_flags(struct ext2_inode_info *);
> extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info =
*fieinfo,
> 		       u64 start, u64 len);
>=20
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 128cce540645..1e2663fbbc54 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1384,25 +1384,6 @@ void ext2_set_inode_flags(struct inode *inode)
> 		inode->i_flags |=3D S_DAX;
> }
>=20
> -/* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
> -void ext2_get_inode_flags(struct ext2_inode_info *ei)
> -{
> -	unsigned int flags =3D ei->vfs_inode.i_flags;
> -
> -	ei->i_flags &=3D ~(EXT2_SYNC_FL|EXT2_APPEND_FL|
> -			=
EXT2_IMMUTABLE_FL|EXT2_NOATIME_FL|EXT2_DIRSYNC_FL);
> -	if (flags & S_SYNC)
> -		ei->i_flags |=3D EXT2_SYNC_FL;
> -	if (flags & S_APPEND)
> -		ei->i_flags |=3D EXT2_APPEND_FL;
> -	if (flags & S_IMMUTABLE)
> -		ei->i_flags |=3D EXT2_IMMUTABLE_FL;
> -	if (flags & S_NOATIME)
> -		ei->i_flags |=3D EXT2_NOATIME_FL;
> -	if (flags & S_DIRSYNC)
> -		ei->i_flags |=3D EXT2_DIRSYNC_FL;
> -}
> -
> struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
> {
> 	struct ext2_inode_info *ei;
> @@ -1563,7 +1544,6 @@ static int __ext2_write_inode(struct inode =
*inode, int do_sync)
> 	if (ei->i_state & EXT2_STATE_NEW)
> 		memset(raw_inode, 0, EXT2_SB(sb)->s_inode_size);
>=20
> -	ext2_get_inode_flags(ei);
> 	raw_inode->i_mode =3D cpu_to_le16(inode->i_mode);
> 	if (!(test_opt(sb, NO_UID32))) {
> 		raw_inode->i_uid_low =3D cpu_to_le16(low_16_bits(uid));
> diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
> index 191e02b28ce8..087f122cca42 100644
> --- a/fs/ext2/ioctl.c
> +++ b/fs/ext2/ioctl.c
> @@ -29,7 +29,6 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, =
unsigned long arg)
>=20
> 	switch (cmd) {
> 	case EXT2_IOC_GETFLAGS:
> -		ext2_get_inode_flags(ei);
> 		flags =3D ei->i_flags & EXT2_FL_USER_VISIBLE;
> 		return put_user(flags, (int __user *) arg);
> 	case EXT2_IOC_SETFLAGS: {
> --
> 2.12.0
>=20


Cheers, Andreas






--Apple-Mail=_84CA34E2-43AF-45F5-8B45-E25CC765B1E0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY7vj2pIg59Q01vtYRAtj+AKDZyN9S4togsfrmSQIIRRFy2oswUwCfQT+c
2DaXKnpwXqTyJq+6rZSgvJY=
=XyXL
-----END PGP SIGNATURE-----

--Apple-Mail=_84CA34E2-43AF-45F5-8B45-E25CC765B1E0--

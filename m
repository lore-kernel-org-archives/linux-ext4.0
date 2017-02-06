From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] fs: ext3/ext4: increase the protection of nlink dec and
 inode destroy
Date: Mon, 6 Feb 2017 16:43:58 -0700
Message-ID: <9D9B6EEC-7D60-495F-B52A-292370728286@dilger.ca>
References: <1486384513-34971-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C8A3F630-6689-4CA7-B157-DADBB03CAFA2";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, viro@ZenIV.linux.org.uk
To: yi zhang <yi.zhang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486384513-34971-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_C8A3F630-6689-4CA7-B157-DADBB03CAFA2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 6, 2017, at 5:35 AM, yi zhang <yi.zhang@huawei.com> wrote:
>=20
> From: zhangyi <yi.zhang@huawei.com>
>=20
> Because of the disk and hardware issue, the ext3/4 filesystem have
> many errors, the inode->i_nlink of ext3/4 becomes zero abnormally
> but the dentry is still positive, it will cause memory corruption
> after the following process:
>=20
> 1) Due to the inode->i_nlink is 0, this inode will be added into
> the orhpan list,
> 2) ext4_rename() and ext3_rename() cover this inode, and drop_nlink()
> will reverse the inode->i_nlink to 0xFFFFFFFF,
> 3) iput() add this inode to LRU,
> 4) evict() will call destroy_inode() to destroy this inode but
> skip removing it from the orphan list,
> 5) after this, the inode's memory address space will be used by
> other module, when the ext3/4 filesystem change the orphan list, it =
will
> trample other module's data and then may cause oops.
>=20
> Although we cannot avoid hardware and disk errors, we can control the
> softwore error in the ext3/4 module, do not affect other modules and
> increase the difficulty of locating problems.
>=20
> This patch avoid inode->i_nlink underflow and remove the inode from =
the
> orphan list when destroy it if the list is not empty.

Thanks for the patch.  A few comments below.

> Signed-off-by: zhangyi <yi.zhang@huawei.com>
> ---
> fs/ext3/namei.c | 6 ++++++
> fs/ext3/super.c | 1 +
> fs/ext4/namei.c | 6 ++++++
> fs/ext4/super.c | 1 +
> 4 files changed, 14 insertions(+)
>=20
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 4264b9b..a2d5b34 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -2500,6 +2500,12 @@ static int ext3_rename (struct inode * old_dir, =
struct dentry *old_dentry,
> 	}
>=20
> 	if (new_inode) {
> +		if (!new_inode->i_nlink) {
> +			ext3_warning (new_inode->i_sb, "ext3_rename",
> +				"Removing nonexistent file (%lu), %d",
> +				new_inode->i_ino, new_inode->i_nlink);
> +			set_nlink(new_inode, 1);
> +		}
> 		drop_nlink(new_inode);
> 		new_inode->i_ctime =3D CURRENT_TIME_SEC;
> 	}
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index c2870e5..90985f7 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -520,6 +520,7 @@ static void ext3_destroy_inode(struct inode =
*inode)
> 				EXT3_I(inode), sizeof(struct =
ext3_inode_info),
> 				false);
> 		dump_stack();
> +		ext3_orphan_del(NULL, inode);
> 	}
> 	call_rcu(&inode->i_rcu, ext3_i_callback);
> }

The fs/ext3 tree was deleted from the kernel in commit =
v4.2-rc3-25-gc290ea0
so this part of the patch should be dropped.  I'm not sure how far back =
the
"stable" kernels are being maintained, so you may want to submit that in =
a
separate patch.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 03482c01..9852b24 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3697,6 +3697,12 @@ static int ext4_rename(struct inode *old_dir, =
struct dentry *old_dentry,
> 	}
>=20
> 	if (new.inode) {
> +		if (new.inode->i_nlink =3D=3D 0) {
> +			ext4_warning(new.inode->i_sb,
> +				"Removing nonexistent file (%lu), %d",
> +				new.inode->i_ino, new.inode->i_nlink);

There isn't any benefit to printing i_nlink, since we already know from =
the
check above that it is always zero when this message is printed.

This would benefit from using the ext4_warning_inode() helper function, =
since
it will print the inode in a standard format and also rate-limit the =
error.

It would also be useful to also print "new.dentry->d_name" in the =
message:

        ext4_warning_inode(new.inode, "path %pd: removing un-referenced =
inode",
			   new.dentry);

(like __ext4_error_file()) to make this easier to debug, since the inode
itself will have just been deleted as part of this rename operation, so
there won't be much else to use for debugging.

Cheers, Andreas

> +			set_nlink(new.inode, 1);
> +		}
> 		ext4_dec_count(handle, new.inode);
> 		new.inode->i_ctime =3D ext4_current_time(new.inode);
> 	}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 700d520..2772a53 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -934,6 +934,7 @@ static void ext4_destroy_inode(struct inode =
*inode)
> 				EXT4_I(inode), sizeof(struct =
ext4_inode_info),
> 				true);
> 		dump_stack();
> +		ext4_orphan_del(NULL, inode);
> 	}
> 	call_rcu(&inode->i_rcu, ext4_i_callback);
> }
> --
> 2.5.5
>=20


Cheers, Andreas






--Apple-Mail=_C8A3F630-6689-4CA7-B157-DADBB03CAFA2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYmQo+pIg59Q01vtYRAtSXAKCaGi3fkihRjLrew/pe3uaukBAduQCfUJeM
ETWV8K622a43CXCGp+ulGe8=
=gFRJ
-----END PGP SIGNATURE-----

--Apple-Mail=_C8A3F630-6689-4CA7-B157-DADBB03CAFA2--

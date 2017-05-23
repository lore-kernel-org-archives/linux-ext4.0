From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] libext2fs: correctly subtract xattr blocks on bigalloc
 filesystems
Date: Tue, 23 May 2017 10:19:35 -0600
Message-ID: <91D3FA03-A23E-45C4-AA3D-575C52D59408@dilger.ca>
References: <20170521062303.32296-1-ebiggers3@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1A6EE896-4AB6-4E9F-BD00-400F6318EA67";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33766 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936106AbdEWQTq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 May 2017 12:19:46 -0400
Received: by mail-io0-f195.google.com with SMTP id m4so15965479ioe.0
        for <linux-ext4@vger.kernel.org>; Tue, 23 May 2017 09:19:45 -0700 (PDT)
In-Reply-To: <20170521062303.32296-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1A6EE896-4AB6-4E9F-BD00-400F6318EA67
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 21, 2017, at 12:23 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> ext2fs_inode_data_blocks2() calculates an inode's data block count by
> subtracting the external xattr block, if any, from the total blocks.
> But on bigalloc filesystems, the xattr "block" is actually a whole
> cluster, so ext2fs_inode_data_blocks2() would return a too-large =
value.
>=20
> It seems this could have caused several different problems, but the =
one
> I encountered was that xfstest generic/399 failed in the "bigalloc"
> config because e2fsck incorrectly considered a symlink on the =
filesystem
> to be corrupted at the end of the test.  This happened because e2fsck
> incorrectly calculated a nonzero data block count for a "fast" symlink
> with an external xattr block and therefore treated it as a "slow"
> symlink, which failed validation.

I thought we changed this to detect "fast" inodes by i_size < 60 rather
than using the blocks count, because the blocks count was (and =
apparently
continues to be) unreliable for determining fast vs. slow symlinks.

However, ext4_inode_is_fast_symlink() still checks blocks count.  In
"[PATCH] ext4: fix reading new encrypted symlinks on no-journal =
filesystems"
we discussed whether this was safe, and it appears to be OK from my
analysis.

We just continue to hit problems when extrapolating various blocks =
counts
to detect fast symlinks rather than just using the same mechanism we use
at creation time, which is "len > EXT4_N_BLOCKS * 4".

Cheers, Andreas

> Fix this by updating ext2fs_inode_data_blocks2() to subtract the =
cluster
> size rather than the block size.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> lib/ext2fs/blknum.c                          |   2 +-
> tests/f_bigalloc_symlink_with_xattr/expect.1 |   7 +++++++
> tests/f_bigalloc_symlink_with_xattr/image.gz | Bin 0 -> 663 bytes
> tests/f_bigalloc_symlink_with_xattr/name     |   1 +
> tests/f_bigalloc_symlink_with_xattr/script   |   2 ++
> 5 files changed, 11 insertions(+), 1 deletion(-)
> create mode 100644 tests/f_bigalloc_symlink_with_xattr/expect.1
> create mode 100644 tests/f_bigalloc_symlink_with_xattr/image.gz
> create mode 100644 tests/f_bigalloc_symlink_with_xattr/name
> create mode 100644 tests/f_bigalloc_symlink_with_xattr/script
>=20
> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
> index ac808490..aa0e9118 100644
> --- a/lib/ext2fs/blknum.c
> +++ b/lib/ext2fs/blknum.c
> @@ -71,7 +71,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
> 	return (inode->i_blocks |
> 		(ext2fs_has_feature_huge_file(fs->super) ?
> 		 (__u64) inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
> -		(inode->i_file_acl ? fs->blocksize >> 9 : 0);
> +		(inode->i_file_acl ? EXT2_CLUSTER_SIZE(fs->super) >> 9 : =
0);
> }
>=20
> /*
> diff --git a/tests/f_bigalloc_symlink_with_xattr/expect.1 =
b/tests/f_bigalloc_symlink_with_xattr/expect.1
> new file mode 100644
> index 00000000..0e6c199f
> --- /dev/null
> +++ b/tests/f_bigalloc_symlink_with_xattr/expect.1
> @@ -0,0 +1,7 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 12/16 files (0.0% non-contiguous), 112/128 blocks
> +Exit status is 0
> diff --git a/tests/f_bigalloc_symlink_with_xattr/image.gz =
b/tests/f_bigalloc_symlink_with_xattr/image.gz
> new file mode 100644
> index =
0000000000000000000000000000000000000000..cbd125dc25a59e6795363e4228c5c5a2=
4e49eeb2
> GIT binary patch
> literal 663
> zcmb2|=3D3oE;CgvoGjR_(>O@RswM|d61u%&K3pz<I`jg5`9<4$npQ4fK%lpp`?f7mKB
> zD~Iqbn<wa1?0j|$!y{*hw>KRQpDqo#XVdZZrqT3=3D(Xr31@3AsJ44-P=3DE@a^wbLINi
> z`(}08^*)m)9&Bu6S7H3j&dZ=3DIW+=3D8GL1aN~b;H5eeTx~Y<kOUA<lerQq%$w~c3IAu
> zZ(`XRO;L_#7i@cctIU4x=3DbU@>KfIF<y0Y7T37Pt2gNnMUX3+98T$AnOzGTkTZc7nn
> zEBXER4ukI7yGI?CbAdesCoY(X$#0Q(5x@u+0W)TuYkBOqqxR~AyH7qDp6rpHbVYi1
> z-PFgM&)n0T^u~I<$6V7cmFMZlV@eaGUTt2Pxx!d{*}`S-rnl|-eD=3DxS?~~`mUzh$@
> z@7j01Z>Q<(@~rbFR|?ISEj(80?QCnT@v_c&(r5E)|E8?IJwIp3-<$R)zuq(~=3DkXS+
> zpZ{iNO7Z{riBFdPj<5LgaQdcLvH5?Gp7_0KVe~ogZX_2j@Yz(~_36&l&#9H~cAl*B
> z<U7CbY4G`dKQ2Y~+x-4y%&&WU+Lv|TZoNKweSY1mkLmM#vYEd5A1jmmeDOZIM~~IL
> zzWU#PUD%cX&eg&H?LX~U7q5QukJg36C;yih&##I3=3DlGBDC;Jom3H1&L#zNMU_DIfw
> zF*it03GP;Lo%Fv--g3+7H}%U?bbnvFyjsOF=3DjpfW@9JMJ6@ORz?B8;Ez6(xqRS%zv
> l$5;JWSR9`6W9skuRgoQNE`u2gr4w?!8Fp-~GX^F`1^_GgBJThI
>=20
> literal 0
> HcmV?d00001
>=20
> diff --git a/tests/f_bigalloc_symlink_with_xattr/name =
b/tests/f_bigalloc_symlink_with_xattr/name
> new file mode 100644
> index 00000000..f612796f
> --- /dev/null
> +++ b/tests/f_bigalloc_symlink_with_xattr/name
> @@ -0,0 +1 @@
> +fast symlink with external xattr block on bigalloc filesystem
> diff --git a/tests/f_bigalloc_symlink_with_xattr/script =
b/tests/f_bigalloc_symlink_with_xattr/script
> new file mode 100644
> index 00000000..8ab2b9c6
> --- /dev/null
> +++ b/tests/f_bigalloc_symlink_with_xattr/script
> @@ -0,0 +1,2 @@
> +ONE_PASS_ONLY=3D"true"
> +. $cmd_dir/run_e2fsck
> --
> 2.13.0
>=20


Cheers, Andreas






--Apple-Mail=_1A6EE896-4AB6-4E9F-BD00-400F6318EA67
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZJGEZpIg59Q01vtYRAkDmAKDulLKgMyXsh5d9EfC7ESIjChfUzgCfRkTw
FfHS0hOha6m4H9CYmQ3gZtg=
=xz3F
-----END PGP SIGNATURE-----

--Apple-Mail=_1A6EE896-4AB6-4E9F-BD00-400F6318EA67--

From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] EXT4: optimizing group serch for inode allocation
Date: Mon, 21 Dec 2015 10:27:37 -0700
Message-ID: <9CF60D02-FF10-44FF-A31E-D4E99F627AF2@dilger.ca>
References: <CAKJOkCr-O+37QfFFJgtkRUZfo_-U=qmYy=Ooc7oqtqcVrz1HWQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_1CA89E7E-22C9-4A60-ADA4-08EAF00096F1"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: lokesh jaliminche <lokesh.jaliminche@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33517 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbbLUR1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Dec 2015 12:27:45 -0500
Received: by mail-io0-f177.google.com with SMTP id 186so163325910iow.0
        for <linux-ext4@vger.kernel.org>; Mon, 21 Dec 2015 09:27:44 -0800 (PST)
In-Reply-To: <CAKJOkCr-O+37QfFFJgtkRUZfo_-U=qmYy=Ooc7oqtqcVrz1HWQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1CA89E7E-22C9-4A60-ADA4-08EAF00096F1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 18, 2015, at 4:32 PM, lokesh jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>=20
> =46rom 9e09fef78b2fa552c883bf8124af873abfde0805 Mon Sep 17 00:00:00 =
2001
> From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@seagate.com>

In the patch summary there is a typo - s/serch/search/

Also, it appears your email client has mangled the whitespace in the
patch.  Please use "git send-email" to send your patch to the list:

  git send-email --to tytso@mit.edu --cc linux-ext4@vger.kernel.org =
HEAD~1

so that it arrives intact.  You probably need to set it up in =
~/.gitconfig:

[sendemail]
        confirm =3D compose
        smtpdomain =3D {your client hostname}
        smtpserver =3D {your SMTP server hostname}

Cheers, Andreas

> Added a check at the start of group search loop to
> avoid looping unecessarily in case of empty group.
> This also allow group search to jump directly to
> "found_flex_bg" with "stats" and "group" already set,
> so there is no need to go through the extra steps of
> setting "best_desc" and "best_group" and then break
> out of the loop just to set "stats" and "group" again.
>=20
> Signed-off-by: Lokesh N Jaliminche <lokesh.jaliminche@gmail.com>
> ---
> fs/ext4/ialloc.c |    8 ++++++++
> 1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 1b8024d..588bf8e 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -446,6 +446,8 @@ static int find_group_orlov(struct super_block
> *sb, struct inode *parent,
>  struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>  ext4_group_t real_ngroups =3D ext4_get_groups_count(sb);
>  int inodes_per_group =3D EXT4_INODES_PER_GROUP(sb);
> + unsigned int inodes_per_flex_group;
> + long unsigned int blocks_per_clustre;
>  unsigned int freei, avefreei, grp_free;
>  ext4_fsblk_t freeb, avefreec;
>  unsigned int ndirs;
> @@ -470,6 +472,8 @@ static int find_group_orlov(struct super_block
> *sb, struct inode *parent,
>  percpu_counter_read_positive(&sbi->s_freeclusters_counter));
>  avefreec =3D freeb;
>  do_div(avefreec, ngroups);
> + inodes_per_flex_group =3D inodes_per_group * flex_size;
> + blocks_per_clustre =3D sbi->s_blocks_per_group * flex_size;
>  ndirs =3D percpu_counter_read_positive(&sbi->s_dirs_counter);
>=20
>  if (S_ISDIR(mode) &&
> @@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block
> *sb, struct inode *parent,
>  for (i =3D 0; i < ngroups; i++) {
>  g =3D (parent_group + i) % ngroups;
>  get_orlov_stats(sb, g, flex_size, &stats);
> + /* the group can't get any better than empty */
> + if (inodes_per_flex_group =3D=3D stats.free_inodes &&
> + blocks_per_clustre =3D=3D stats.free_clusters)
> + goto found_flex_bg;
>  if (!stats.free_inodes)
>  continue;
>  if (stats.used_dirs >=3D best_ndir)
> --
> 1.7.1
> <0001-EXT4-optimizing-group-serch-for-inode-allocation.patch>


Cheers, Andreas






--Apple-Mail=_1CA89E7E-22C9-4A60-ADA4-08EAF00096F1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVng2inKl2rkXzB/gAQjUzhAArpCHDR3n4YoSGnNrOruGBPJWl7a1102N
f5pIdKrCP1e29/DR05hKEGXJGQYCuBw5XpN1/0t4EE4DinmxKGZxaDa+Tk7W6Lg0
W6560TezRBwhe2kjkQ4VsG3Mw6jyHLbj3J3H85AXttmkJA8H9avQWCVDSN4/17Uj
wTWDvHsvqfUaH56kILrRcemqRjUVq3aIucUnJpk3j3PmqGg/7iQgl8YaLFh+8je8
kzgUmvGBB/guAgPSpfSr96dBBkFVCpk02q+jkpnKYFouSwAsJKL1xWSWJxrfFAGD
V/6WzP2N/UNm+ecs+xhyBp6GXzP/z68NS7p1IrMQhQYnlcvNdTIn+wzgDCkOjx6F
nqmq1Pc5wN8GX1dA4XGQ+u3XojH75aTNrbd52DS/PHmABc+J9NlKhiBuodSwLGs/
TTxSrMjJU2rBQEn35MpUSfEoMajEyTqjB7rtQxaV5f9kb/g34yBn6FkIi4w5NQaT
t7hpcaovSxiHJfw0ni+2DdvK6iCb2FT6xIZQGPUCpU9aRfkOnVX5ubSS1ZQqBEFa
/NXI5EZ4YV/i847k9iBPpouoaE1hkk+FwKEe1SnRqI/fIWq6QQUOdKw45hRVhFqm
SpxiN3MkBSirYHOkoIXIodNPE+GNd1IBxevD8OX70+xkihuStM9O/jIazy0sjA5O
nV1Ha8I1TR8=
=IVAv
-----END PGP SIGNATURE-----

--Apple-Mail=_1CA89E7E-22C9-4A60-ADA4-08EAF00096F1--

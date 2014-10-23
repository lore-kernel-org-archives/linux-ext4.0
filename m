From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] xfstests-bld: Split system images in two parts
Date: Thu, 23 Oct 2014 15:25:38 +0400
Message-ID: <87d29j10zx.fsf@openvz.org>
References: <1413990417-18285-1-git-send-email-dmonakhov@openvz.org> <20141022212535.GC6295@thunk.org> <20141023004812.GA7841@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, root <root@deb7build.openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39846 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbaJWLZr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2014 07:25:47 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so3343041wiv.3
        for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 04:25:46 -0700 (PDT)
In-Reply-To: <20141023004812.GA7841@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Wed, Oct 22, 2014 at 05:25:35PM -0400, Theodore Ts'o wrote:
>> So what I suggest instead is that we have a new script, update-image,
>> which takes an existing root_fs.img, and installs the updated
>> xfstests, the configuration files, and startup files, leaving the
>> existing debian base image intact.
>
> Here's an enhancement to the gen-image script which adds a new
> --update option.
Yes. This one looke much than mine, than you.
>
> 					- Ted
>
> commit debd9734bc23108f37c6f62914cb5f9e16da20cc
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Wed Oct 22 20:42:32 2014 -0400
>
>     test-appliance: add --update option to the gen-image script
>=20=20=20=20=20
>     This allows gen-image to to update the xfstests.tar.gz tarball and the
>     xfstests driver scripts into an existing root_fs.img file, keeping the
>     original operating systems files unchanged.  This takes less than 15
>     seconds, compared to about 90 seconds to do a full gen-image build
>     using a local disk debian mirror.  It also allows a xfstests developer
>     to generate new versions of the root_fs.img more simply on a system
>     that does not have debootstrap installed or has access to a Debian
>     archive or mirror.
>=20=20=20=20=20
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> diff --git a/kvm-xfstests/test-appliance/gen-image b/kvm-xfstests/test-ap=
pliance/gen-image
> index 550d070..27f9d96 100755
> --- a/kvm-xfstests/test-appliance/gen-image
> +++ b/kvm-xfstests/test-appliance/gen-image
> @@ -12,6 +12,7 @@ ROOT_FS=3D$DIR/root_fs.img
>  COMPAT=3D"-o compat=3D0.10"
>  SAVE_RAW_ROOT=3Dno
>  DO_GCE=3Dno
> +DO_UPDATE=3Dno
>=20=20
>  if test -r config.custom ; then
>     . $(pwd)/config.custom
> @@ -29,8 +30,11 @@ while [ "$1" !=3D "" ]; do
>        DO_GCE=3Dyes
>        SAVE_RAW_ROOT=3Dyes;
>        ;;
> +    --update)
> +      DO_UPDATE=3Dyes
> +      ;;
>      *)
> -      echo "usage: gen-image [--save_raw_root] [--do_gce] [--mirror MIRR=
OR_LOC]"
> +      echo "usage: gen-image [--save_raw_root] [--do_gce] [--update] [--=
mirror MIRROR_LOC]"
>        exit 1
>        ;;
>    esac
> @@ -42,6 +46,31 @@ then
>      RAW_ROOT_FS=3D/tmp/root_fs.raw.$$
>  fi
>=20=20
> +update_xfstests()
> +{
> +   tar -C $ROOTDIR/root -xf ../../xfstests.tar.gz
> +   rsync -avH files/* $ROOTDIR
> +}
> +
> +finalize_rootfs()
> +{
> +   e2fsck -fyD $RAW_ROOT_FS
> +   e2fsck -fy -E discard $RAW_ROOT_FS
> +   qemu-img convert -f raw -O qcow2 $COMPAT -c $RAW_ROOT_FS $ROOT_FS
> +}
> +
> +mkdir -p $ROOTDIR
> +if test $DO_UPDATE =3D "yes" ; then
> +   qemu-img convert -f qcow2 -O raw $ROOT_FS $RAW_ROOT_FS
> +   mount -t ext4 -o loop $RAW_ROOT_FS $ROOTDIR
> +   rm -rf $ROOTDIR/xfstests
> +   update_xfstests
> +   umount $ROOTDIR
> +   rmdir $ROOTDIR
> +   finalize_rootfs
> +   exit 0
> +fi
> +
>  mkdir -p gce
>  if test $DO_GCE =3D "yes" ; then
>      sh get-gce-debs
> @@ -51,7 +80,6 @@ else
>      variant=3Dxfstests
>  fi
>=20=20
> -mkdir -p $ROOTDIR
>  mkdir -p var.cache.apt.archives
>  mkdir -p var.lib.apt.lists
>  mkdir -p debs
> @@ -69,9 +97,7 @@ mount --bind gce $ROOTDIR/gce
>  mkdir -p $ROOTDIR/imgdir
>  mount --bind $(dirname $RAW_ROOT_FS) $ROOTDIR/imgdir
>  debootstrap --variant=3D$variant $ARCH $SUITE $ROOTDIR $MIRROR $DIR/kvm-=
xfstest.script
> -cp -r files/* rootdir
> -echo "untaring xfstests"
> -tar -C rootdir/root -xf ../../xfstests.tar.gz
> +update_xfstests
>  for i in vda vdb vdc vdd vde vdf results
>  do
>  	mkdir $ROOTDIR/$i
> @@ -139,9 +165,7 @@ rmdir $ROOTDIR
>=20=20
>  if test $DO_GCE !=3D "yes" ; then
>     tune2fs -O has_journal $RAW_ROOT_FS
> -   e2fsck -fyD $RAW_ROOT_FS
> -   e2fsck -fy -E discard $RAW_ROOT_FS
> -   qemu-img convert -f raw -O qcow2 $COMPAT -c $RAW_ROOT_FS $ROOT_FS
> +   finalize_rootfs
>  fi
>=20=20
>  if test "$SAVE_RAW_ROOT" =3D "yes" ; then

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSOWyAAoJEFzOBSYIXfvegMAP/2EiI1baXyxt3qM5XV/j1o/E
6Q/f4DNILLCMkqHkK0DEY2JpNkol64MLYXrSm56cEHUHFhzPcjGDlKEsnGPgrC70
3ggb8k9OKiXshZTQ+ha1qXnzqdkfR2hXIK78BWhz2b8QnmUJPPN8z76lhEvuRrXw
qalhBlLoMD+8UJo3/EfQWl+DdFx6/XZd+Nup5G4rQLfmrDkptgeV6xtKh5Hgrn2y
uvhdIbmL7XgTqvrXEsxMJp7f1oul/mUE8j7wcdB7DdttGGGtrCn2wyHZ5Sj1FRgb
Q6raDK1q15rwgfEwMy/gi8P/sEoycrRuAbpEkNm/JMFOj26YSV5ja7gzW4pv/mjO
+vBX8lI48lwBMV48dxQfzSFyVo2s5jTOMccOf0t6io+tZcpBgC0W0bJ/YDFvhnKd
8HSjGSzRdjeXbUhzQMqQPB6eKNC63E0dmgjVnL2jfZ1oMyvkli0olZ+idmrlAFqs
Vg4sf/7P0oS83HEd/TaYwL41XtzLWTsz1rQh3HNd/RGnmBeYq0iERj+S+4nQvi3S
P5yM1jFi3qTb14Leo31ucTgZVZAl7v3qJ+/Dp+La2Go9cn7YfoWZPHhC2kP48MfS
Igjcr43Nz43rHXKBALAGO0Pm6wxIiC60yyczxgT853z29eH3vXx2wk35TJ0hzZEs
3HJsN5twH0znV+G/JvnL
=cb9P
-----END PGP SIGNATURE-----
--=-=-=--

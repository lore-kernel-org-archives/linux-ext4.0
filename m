From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2] tune2fs: edit dire warning about check intervals
Date: Wed, 19 Jul 2017 11:29:13 -0600
Message-ID: <76C2FAF0-F275-4567-8153-E3D43AAF75D9@dilger.ca>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
 <3d574f21-a93c-e1ae-2b92-d4b1d1156fb4@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DB4530D9-FF5E-4171-991A-C82C32437FF4";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        =?utf-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36747 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753847AbdGSR3U (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jul 2017 13:29:20 -0400
Received: by mail-io0-f195.google.com with SMTP id k71so401757iod.3
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 10:29:20 -0700 (PDT)
In-Reply-To: <3d574f21-a93c-e1ae-2b92-d4b1d1156fb4@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DB4530D9-FF5E-4171-991A-C82C32437FF4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jul 19, 2017, at 11:26 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>=20
> Time & mount-count based checks have been off by default for quite =
some
> time now, but the dire warning about disabling them remains in the
> tune2fs manpage, which is confusing.  We did "strongly consider
> the consequences" and disabled it by default, no need to scare the
> user about it now.  Inform the user of the consequences in a more
> measured tone.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> V2: explain that the default of no-check is a tradeoff.
>    Edit the -i section as well.
>=20
>=20
> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> index 5c885f9..eccf277 100644
> --- a/misc/tune2fs.8.in
> +++ b/misc/tune2fs.8.in
> @@ -134,7 +134,9 @@ Staggering the mount-counts at which filesystems =
are forcibly
> checked will avoid all filesystems being checked at one time
> when using journaled filesystems.
> .sp
> -You should strongly consider the consequences of disabling
> +Mount-count-dependent checking is disabled by default to avoid
> +unanticipated long reboots while e2fsck does its work.  However,
> +you may wish to consider the consequences of disabling
> mount-count-dependent checking entirely.  Bad disk drives, cables,
> memory, and kernel bugs could all corrupt a filesystem without
> marking the filesystem dirty or in error.  If you are using
> @@ -289,15 +291,10 @@ as months, and
> .B w
> as weeks.  A value of zero will disable the time-dependent checking.
> .sp
> -It is strongly recommended that either
> +There are pros and cons to disabling these periodic checks; see the
> +discussion under the
> .B \-c
> -(mount-count-dependent) or
> -.B \-i
> -(time-dependent) checking be enabled to force periodic full
> -.BR e2fsck (8)
> -checking of the filesystem.  Failure to do so may lead to filesystem
> -corruption (due to bad disks, cables, memory, or kernel bugs) going
> -unnoticed, ultimately resulting in data loss or corruption.
> +(mount-count-dependent check) option for details.
> .TP
> .B \-I
> Change the inode size used by the file system.   This requires =
rewriting
>=20
>=20


Cheers, Andreas






--Apple-Mail=_DB4530D9-FF5E-4171-991A-C82C32437FF4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZb5brpIg59Q01vtYRAhmSAKDWE4pyj0UDR1hspk/BQ5zjUOIBjgCgwJk4
EGyoQNSlWElHZts3i41lRp0=
=dhFC
-----END PGP SIGNATURE-----

--Apple-Mail=_DB4530D9-FF5E-4171-991A-C82C32437FF4--

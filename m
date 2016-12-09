From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Filesystem size problem.
Date: Fri, 9 Dec 2016 13:29:48 -0700
Message-ID: <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com> <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9537550F-2A32-4B45-A833-63A508E6E910"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35236 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752316AbcLIU3z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2016 15:29:55 -0500
Received: by mail-io0-f178.google.com with SMTP id h30so76930161iod.2
        for <linux-ext4@vger.kernel.org>; Fri, 09 Dec 2016 12:29:55 -0800 (PST)
In-Reply-To: <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9537550F-2A32-4B45-A833-63A508E6E910
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 8, 2016, at 10:40 PM, Simon Matthews <simon.d.matthews@gmail.com> =
wrote:
>=20
> I have an ext3 filesystem that will not mount under newer versions of
> the kernel and I hope someone here can help.
>=20
> Obviously, one solution is "backup and re-create from scratch". I have
> the backups, but I hope that there may be a quicker method to fix the
> issues.
>=20
> The root issue is that the filesystem is very slightly smaller than
> the allocated space. The filesystem exists on a MDRAID device and I
> think that when I converted the MDRAID to a newer metadata version, it
> truncated the available size, slightly. However, how I got here isn't
> really important, fixing it now is.

Running "e2fsck -fy" should fix this.  I'd recommend to use the latest
version of e2fsck.

Cheers, Andreas

>=20
> With an slightly older kernel (4.0.5), the filesystem can be mounted.
> With 4.4.26, the ext3 support is provided by the ext4 subsystem and it
> appears that it will not accept the size issues. dmesg showed this
> from the mount attempt:
>=20
> md5: detected capacity change from 0 to 2839999799296
> [ 1162.508338] EXT4-fs (md5): mounting ext3 file system using the ext4 =
subsystem
> [ 1162.508560] EXT4-fs (md5): bad geometry: block count 693359344
> exceeds size of device (693359326 blocks)
>=20
> As I stated, the difference is very small, so it was working OK for a =
long time.
>=20
> My attempts to re-size the filesystem did not work. I don't have the
> error messages available. Getting the system up and running was more
> important at the time.
>=20
> Apart from "backup and re-create", how can I fix this? What would be
> the correct options to use with resize2fs (if that is the correct
> approach)? fsck gave me some serious warnings about possibly
> destroying the filesystem, so I did not want to do this without
> advice.
>=20
> Simon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_9537550F-2A32-4B45-A833-63A508E6E910
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWEsUPXKl2rkXzB/gAQgcgQ/+PoR9a4NqbQmpnOYcN50/u8OAVnJ6OXyV
6sWOGQkuzIGW0zn57Sp0IV9OhZwPpjx+gsUgTGLQQN+kJx3dLsQtCe2IzdLM0ADn
ziDhl/JdlNAJvi0TNOwZd+76qZ3wG9vYnT+ciHpjfZIspdsHr0I8RZ/+yUM/mKE7
1taivvq3dbB7A5JAK/PmeUd2PIblIFh+ddwQMIyB2ilQSqXWs/d0OsWGyEEd16+O
t8A+J/udWVjMRTlxRU7ROUAQ8bEMXq5hSYgo8Ru+NJiZmuZxVB2pwy9jcxXJnYls
COGTiH4INQH+R4u1UYN7nks7E5zBYjtHnIXVes/XrTsuXCpf133b1M20T6LuPrQT
WfDyCdOYS54mFgmNcM1oNqHj7wwd7pPf03bOKlivc0coe+FRrnNixATRCBzvie51
TqLYnlFuK1q2kMsSzQlZC2CwZf/qm5z9PtN/1h+d4/n39A0UJv0A3wvNl2u5OeE5
xAl99+M6jFuUCrhdkSXUf2UMnlZUtkNHV2xgOtiy0bQOSmsshsFzgY85Nbi7Mx+X
WuIbpDAF+MPGz8iZ+mkaW/qYYxv+lOCoq8lXZXDjonAPa4VXx2Jc30SVXeIEFhqz
tfXrWlP95KpvFqKHAIjWWxLASXU//9GGiWVVl7vSY+ECRv1nXXFhq/ziM4GNAtAR
5S/13WrJ8Fc=
=W6qq
-----END PGP SIGNATURE-----

--Apple-Mail=_9537550F-2A32-4B45-A833-63A508E6E910--

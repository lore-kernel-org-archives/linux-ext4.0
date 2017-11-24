From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Fri, 24 Nov 2017 17:28:19 -0500
Message-ID: <1511562499.4182.13.camel@HansenPartnership.com>
References: <20171123203330.GN2482@two.firstfloor.org>
         <20171123222317.bq2v26zm5i2jspui@thunk.org>
         <20171123233101.GP2482@two.firstfloor.org>
         <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
         <20171124020435.GQ2482@two.firstfloor.org>
         <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
         <20171124165102.GS2482@two.firstfloor.org>
         <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-zehMWejDzM6ka0CeOBAn"
Cc: Theodore Ts'o <tytso@mit.edu>, Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>,
        Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34584 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753730AbdKXW21 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 24 Nov 2017 17:28:27 -0500
In-Reply-To: <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-zehMWejDzM6ka0CeOBAn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-24 at 15:03 -0700, Andreas Dilger wrote:
> On Nov 24, 2017, at 9:51 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >=20
> >=20
> > >=20
> > > We checked old kernels, and old e2fsprogs, and didn't see any
> > > cases
> > > where fast (<=3D 60 chars) symlinks were created using external
> > > blocks.
> > > It seems that _something_ did create them, and it would be good
> > > to
> > > figure that out so we can determine if it is a widespread problem
> >=20
> > I assume it was the original kernel.
> >=20
> > >=20
> > >=20
> > > I think e2fsck can fix this quite easily, and there really isn't
> > > an easy way to revert to the old method if the large xattr
> > > feature
> > > is enabled.=C2=A0=C2=A0If you are willing to run a new kernel, you sh=
ould
> > > also
> > > be willing to run a new e2fsck.
> >=20
> > It's obviously not enabled on ext3.
> >=20
> > >=20
> > > We could probably add a fallback to the old mechanism (and print
> > > a one-time warning to upgrade to a newer e2fsck) if an external
> > > fast symlink is found and the large xattr=C2=A0=C2=A0feature is not
> > > enabled, which would give more time to fix this (hopefully rare
> > > in the wild) case.
> >=20
> > If the old kernel created it, then likely all the
> > /lib{,64}/ld-linux.so.2 symlinks have that, which breaks all ELF
> > executables. I suspect in these old file systems it's not
> > particularly rare.
>=20
> Sure, but not many people are going to be running a 4.14 kernel with
> a 2007 system.=C2=A0

I really disagree on this ... most of us who are doing kernel testing
will be running with older systems. =C2=A0It's true, some of us do install
from scratch and then test, but most of us upgrade (which doesn't
necessarily modify the symlinks). =C2=A0On your creation test, this is my
cloud system:

bedivere:~# dumpe2fs -h $(df -P / | awk '/dev/ { print $1 }') 2>&1 | grep c=
reated
Filesystem created:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Tue Mar 24 20:=
21:35 2009

Your find command turns up nothing untoward.

My older system is the home entertainment system, but that has an xfs
root dating back to 2005.

I bet I have a laptop even older (currently travelling, so can't
check).

James

--=-zehMWejDzM6ka0CeOBAn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJaGJ0GAAoJEAVr7HOZEZN49SMQAJVe+6NQzpcdGSKb5fM8y3bn
u+A/GhQCm6F+S2pr2K+pWXoSKH60PzBWfWuJantEtmPcQ190SrKxYb6OdPVfVyzl
R5lOQ5yUZglqZlXK+B4yHPw4yJCM1O6la28hYK+MtKBzEkapX2frzUc+/pZ9jIYw
P6M18rxUBf39pR8+afE3IFk5JHT+qzd3qg9CgoZOA7zfZDrYsPZXtXsbFdtqb7E9
Fdiqrcvxnh73vq/7t8/k7umVq8IMTITbA2wctmvNyhdJP4KdNE7CtV3NN92KrSVk
0FtXvrn0R5EMD9BVH9MTgWkOt8nfkUAj7Q5pYkXlV8PuhDnihVJWtI1R0jvYIeOH
aPIm+6FOnrtHrF2tWDNWgrlgV+YruO0ur6xcCZyCyvOhepHSAcshf4rP6sGEn9ng
CrC+QklmD9w+BvTPMFIK9WmI+T+Qq6wDz88bRX/6tdOv5kLVWnp793WtGOHtXQrk
sJjXzlHavmv0IIUmwmL7FngRnPf33dC52FOGCn5QeNi3YnSb2mvDWsdSyvFtG7BL
yGX2agfSBDkXky0FL2bjcVnIUIOHxiQoA+n41CKObyjvrD5mxtMDM//q1eGdnvXZ
ae8bDO5HD5q4QtIN8bKQGZJySq4DGKVfE4tQq1oM0wSPgv2e9rGzGVands+xtQm8
ZqAEIo6RTbovn5KeNK3E
=ZBJf
-----END PGP SIGNATURE-----

--=-zehMWejDzM6ka0CeOBAn--

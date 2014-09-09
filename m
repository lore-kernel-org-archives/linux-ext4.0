From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: dumpe2fs: only print 'unused inodes' once
Date: Tue, 9 Sep 2014 12:47:46 -0700
Message-ID: <20140909194746.GF10351@birch.djwong.org>
References: <BAY179-W101B94761503C2D6FBA0CBFDCE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34101 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaIITru (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 15:47:50 -0400
Content-Disposition: inline
In-Reply-To: <BAY179-W101B94761503C2D6FBA0CBFDCE0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2014 at 03:32:56PM -0400, TR Reardon wrote:
> just a minor nit...and I don't think fixing this harms any existing t=
ests.

Running 'make check' will tell you.

This also needs a Signed-off-by.

--D
>=20
> +Reardon
>=20
>=20
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index a1c5ba2..d30cf87 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -205,8 +205,6 @@ static void list_desc (ext2_filsys fs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(" =A0Checksu=
m 0x%04x"), csum);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (csum !=3D exp_csu=
m)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print=
f(_(" (EXPECTED 0x%04x)"), exp_csum);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(", unused inod=
es %u\n"),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_b=
g_itable_unused(fs, i));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 has_super =3D ((i=3D=3D0) || super_bl=
k);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (has_super) {
>=20
>=20
>  		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

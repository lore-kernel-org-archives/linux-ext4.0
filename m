From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 6 Apr 2012 22:47:42 +0300
Message-ID: <20120406194742.GB8816@sli.dy.fi>
References: <20120330125726.GA26221@amd.home.annexia.org>
 <20120330131936.GB26221@amd.home.annexia.org>
 <4F760BC2.4070401@redhat.com>
 <20120406191401.GA8816@sli.dy.fi>
 <4F7F41C1.9010208@redhat.com>
 <4F7F448D.5040808@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:56801 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2DFTrv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:47:51 -0400
Content-Disposition: inline
In-Reply-To: <4F7F448D.5040808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 06, 2012 at 12:31:25PM -0700, Eric Sandeen wrote:
> However, there seems to be some unstated (?) naming convention about foo_bmap
> (for 64-bit bitmaps) vs. foo_bitmap (for 32-bit bitmaps), and "bitmap2"
> functions which seem to take 64-bit args, etc.  I'm not sure if this new
> function needs to follow similar conventions...

I guess... I thought I had figured those out when I sent the patch,
but I'm not so sure anymore :-)

> My patch is probably overkill, so I won't bother to send it unless Ted
> thinks something like that is necessary.  Documenting the api preservation
> framework for 64-bit bitmaps would be really helpful, I think.

Yeah, I'm sorry it took me a while to look at this and for causing you
extra work.

	Sami

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPf0heAAoJEKLT589SE0a0E7gQAKgVkYmcejB4+9tFV71TVx+M
5zJp9FQeytHbM5VNXUhwlNIAVhfagODiLntvRbTGd7oDiDPu80SyR3X2N7JS/Xr1
VPLCuhXHoJ357t82+skeSXhUNynggKA1qahnrYZ0guLsSPIn/+X42ZgiRBHP/wkl
93FWIbyqykVaFRq0QR5m+tDe+7ZP4FxZzQe7BNXwO0FGWLjt87QYeCq7Fhknr071
76LJ+doMOcV7HeZvLf9ptdfQf8C5KwGktELb/IG3SVjjT0SqhXxwNaf48e86IR6Q
HFHI/oRb87Pi3v7gg1GQCgtlKX/SlVqifRJ3krAD7c98a+uMCH5dPu6uSyBgGiXz
oyGwaLfw7NAWkF4jzuDVAUEUIRxDvB0vaMtVjiLCXGYstvHp3fID31+V8pjRIWH3
lmwCZzwm7L2zC/V97mAJwEC2m0h34vHyQLIXJY4bXp/rw1O0DKs40u0nAomee1Es
ZJdPratKOMz5mARETNp7JupOCvpupYHtHvlRkgtnK2cxpd08V/SPQrOj8QdCfnYq
/UH0FejR6cY/aX+W15rSOH3yC5E3ZcThILI6H4mqlEV6lHiuLtbeBXhRv9d5bPtC
d/tatlifsMiyFveL0aWbnJfNm9w9orWTQO+GD4lbq5aJR1rZolBridRwJqRAB8A3
wntQw2k96mZwWuzHZYP2
=vF2t
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--

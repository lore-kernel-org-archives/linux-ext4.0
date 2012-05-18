From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 0/4] do not use s_dirt in ext4
Date: Fri, 18 May 2012 13:25:37 +0300
Message-ID: <1337336737.2483.16.camel@sauron.fi.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tNRrMboxeLp9eoriN0/y"
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026Ab2ERKWI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 May 2012 06:22:08 -0400
In-Reply-To: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-tNRrMboxeLp9eoriN0/y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

the merge window is about to open and I am getting worried about this
patch-set - I won't have time to fix it if you indicate an issue...

On Mon, 2012-04-02 at 14:45 +0300, Artem Bityutskiy wrote:
> This patch-set makes ext4 independent of the VFS superblock management
> services. Namely, ext4 does not require to register the 'write_super()' V=
FS
> call-back.
>=20
> The reason of this exercises is to get rid of the 'sync_supers()' kernel =
thread
> which wakes up every 5 seconds (by default) even if all superblocks are c=
lean.
> This is wasteful from power management POW (unnecessary wake-ups).
>=20
> Version 1 of this patch-set can be found here:
> https://lkml.org/lkml/2012/3/20/220
>=20
> Changes between v1 and v2.
>   * Rake different strategy - instead of pushing 's_dirt' down "as-is" an=
d
>     emulating old behavior, we now just submit the superblock for writing
>     straight away, either via the journal or directly. Thank to Jan Kara
>     for helping with this.
>   * Ted picked some of the patches already, which made this series shorte=
r
>     - thanks!
>   * This time I've tested the changes using xfstests.
>   * Rebased to 3.4-rc1.
>=20
> Note: Ted, you merged the "mm: export dirty_writeback_interval", but it l=
ooks
> like we won't need this for ext[23]. However, for other file-systems we w=
ill
> need this change.
>=20
> Thanks,
> Artem.

--=20
Best Regards,
Artem Bityutskiy

--=-tNRrMboxeLp9eoriN0/y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtiOhAAoJECmIfjd9wqK00RQP/3y650jca1m4NDL7G21oDiZA
CGZS19VrteBJHBILlNwNm+gkSC70e4WknFakfbyvNJJlwbdmwRX02oPvPtXSe8gd
zwv9c4+PQZwU9ZETV8Be3BMJ12GUE2p4t1il/bBqxXljhd2Tk63DjvktrBlhEovq
qLggiBmeEkul9iUkcyCDTyZXMQlhL0CNChypB2Mdiy7v+LzXqln8N18/G8ROrTR+
rFW4WJHK7r8tl309GWK+wglL5mvZLp6msUJzz9c2EYetRaLoMCWN3fT7WPvYP3Va
4vYmQd8251mW2lZ8ZrPGzvc7KqHL3j2tHj+BHdmGHYhKhwyY8XiMAmJ6gSATcsbm
C5k9azSQYmv7xl/gaImsuOIw8ClqThatJTmW4SjW8qeYaK5WxsT8SdduNA9ab4wR
rpWTD4ufzi3fpVd7iXXP6aZDJz2AWSmlBHZkdgaDSscWKkcWnSc29eCzWxIZqL4p
52kEmBnN2sH8EPS5Z8wLtNKevkQkRp+k/YfGusBT3tUvY4tCR55FCbNiJqnIr1hG
ETdDv0+0h8C+3yzXcuURYSViNnUA7P7oKx3c/CRO/p5V9DVNRVhe7l2LiDqX8vNP
99BvwvJ8LB00+wgcHP6q14cZVdPQQhYjMv1NiYc3oahvR1+k1+Azlpg6dujATb90
ewOZnU49/k9O5S47qn0h
=drwO
-----END PGP SIGNATURE-----

--=-tNRrMboxeLp9eoriN0/y--


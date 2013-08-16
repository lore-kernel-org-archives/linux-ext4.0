From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH next] fix unused variable compiler warning
Date: Fri, 16 Aug 2013 17:19:32 +1000
Message-ID: <20130816171932.1906a8be5caa7f89756b3c06@canb.auug.org.au>
References: <1376635714.2642.6.camel@ThinkPad-T5421>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Aug_2013_17_19_32_+1000_=/MrA5047P17eVT+"
Cc: linux-next list <linux-next@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: lizhongfs@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:55816 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3HPHTf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Aug 2013 03:19:35 -0400
In-Reply-To: <1376635714.2642.6.camel@ThinkPad-T5421>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Signature=_Fri__16_Aug_2013_17_19_32_+1000_=/MrA5047P17eVT+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

You should probably have cc'd the ext4 maintainers (cc'd).

On Fri, 16 Aug 2013 14:48:34 +0800 Li Zhong <lizhongfs@gmail.com> wrote:
>
> fs/ext4/extents_status.c:950:6: warning: unused variable
> 'ret' [-Wunused-variable]
>=20
> Signed-off-by: Li Zhong <lizhongfs@gmail.com>
> ---
>  fs/ext4/extents_status.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index dc709e1..6708257 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -947,7 +947,7 @@ static int __ext4_es_shrink(struct ext4_sb_info *sbi,=
 int nr_to_scan,
>  	struct ext4_inode_info *ei;
>  	struct list_head *cur, *tmp;
>  	LIST_HEAD(skipped);
> -	int ret, nr_shrunk =3D 0;
> +	int nr_shrunk =3D 0;
>  	int retried =3D 0, skip_precached =3D 1, nr_skipped =3D 0;
> =20
>  	spin_lock(&sbi->s_es_lru_lock);
>=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Aug_2013_17_19_32_+1000_=/MrA5047P17eVT+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSDdKEAAoJEECxmPOUX5FEz6sQAIHF4w4EUN715tV+HiC6fVzc
CG8QJ6Ziz9+vFHqJWQud5sxDQz2K2WmnhuEg9MKoL4X/VDIjJB7XkPR4unbYFch9
pOofCFTRzLr8OqHkXbKdrXpvTaMrlwfKMDwtsEGQcWJ6rhlsLobdGMxIIqub1fQV
w274YYzsNhP84v4c3Xf7crKyjD8bta585U/5E69lY9z9z9XJOO0t1z608mDEy6KH
PY5Fbuab0WBPeDP2xmLYkPL9tOzNIbVy+Y2xgwdLkd51889Zsf/eZghJ7QJ1snod
DUAzY2W3ajoQbGIh7HR6GEu+MwcGOuzORGOCO3GK9XVAEQ7UqcsIx2MpSGPqDLrl
wjAHlbvCl098ibK3lkawVPyms4I5pBLuJbmI57k3h2ocup6zZY8r5usKZcklrtgk
mz2Ji/9FzjZ58qvD8/12AD9Qxa9EyGp7lGgLPRMH0UaGe1koTdXYjcYgRdioXIwY
vAmCtHZZKRlW2M0Zpxi3JJxIUDYUVhdXqJe28QmRK547IN46zcbbUveNmMN+BPSI
SJyr/C4oU839DGCMbUAqkTZ+Ds87UHhJigLrct5tQ2L4a3hukbQVBf+EtpLxW25k
SmHDmZyT1utpQCK4xEPDEMSztKdY/wpa/bbLNfxA6QFFzzTc+gTiu+manfza6F6W
qeHokcnpyqLVHfHuC6D8
=oVwv
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Aug_2013_17_19_32_+1000_=/MrA5047P17eVT+--

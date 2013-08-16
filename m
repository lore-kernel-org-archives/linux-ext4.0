From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH next] fix unused variable compiler warning
Date: Fri, 16 Aug 2013 17:21:12 +1000
Message-ID: <20130816172112.ad4c82b6a1e84f3f29744495@canb.auug.org.au>
References: <1376635714.2642.6.camel@ThinkPad-T5421>
	<20130816171932.1906a8be5caa7f89756b3c06@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Aug_2013_17_21_12_+1000_kwrzHJEkgwFg3u/z"
Cc: linux-next list <linux-next@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: lizhongfs@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:37087 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab3HPHVP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Aug 2013 03:21:15 -0400
In-Reply-To: <20130816171932.1906a8be5caa7f89756b3c06@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Signature=_Fri__16_Aug_2013_17_21_12_+1000_kwrzHJEkgwFg3u/z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 16 Aug 2013 17:19:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> You should probably have cc'd the ext4 maintainers (cc'd).

And I should probably check my own tree :-)

Andrew already has a patch that does this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Aug_2013_17_21_12_+1000_kwrzHJEkgwFg3u/z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSDdLoAAoJEECxmPOUX5FED/wP/08nd28ye9jbfquWvJzNblxO
4/X7oDu9obF6KBsR4pcBAyd6dZp0SYm8HrT2Vce5tky4tnk0eTa4WITx7GLmtmh1
y2lhBtto/zB6i9WDcV0LBB0St4E8GSi5sQuSaQ864hi+BPySzCf/xxwoQvZ/9U6D
wDDcvmHmEoSxJc3zU0aDErEhInP+VxBhBW/yF+9ILRnFSj9+qr+Zi3gItPoSNocT
Hy9ElqiVUlmgmWqe3p4chFmlPLpC+vtgBXI5H0V1S/XxSCe03doNtMel2jZCT7An
ISULsrPqkKDmIMUAqcygYKjNm7uub2+BG3BowuzNxMOLNuqVvmGYyI3qN8nJ7k8G
Ec4O3SqgDoFkqmHdr4zXSiPFRH16WvYMLmTViIk+x3tbp0JVHyG2hLrCM9PT4Evf
G8McxWgmAezbr37CydSUdtseHFpYXWWlSMRA3dkqryQbcVXYPQ6NLzCWxdwk36Bs
U1Z2k4sQnM+vfbzlFiYn0Ae2jDYntUUtyM+2Nj99S5qWlZTNwfZCEFw8gbD0QMms
/z5/40i3R0LuMd+ZqLT77UqepqVmSBhymXEnEfXaKPfx2kDOS8XN6TT9AGBMGTAD
WJZdmTuR+WjWJcXo1YiJE5xntN31fJybcvixtmwpZuXgFnVo+yY9ins/FbJeMuyZ
CHtG0NnBAZ3ClMIlQwCC
=Q33i
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Aug_2013_17_21_12_+1000_kwrzHJEkgwFg3u/z--

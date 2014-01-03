From: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] e4defrag: choose the best available posix_fadvise variant
Date: Fri, 3 Jan 2014 06:57:48 +0200
Message-ID: <20140103045747.GM6589@tarshish>
References: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
 <20140103004710.GA31411@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:44936 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaACE5x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jan 2014 23:57:53 -0500
Content-Disposition: inline
In-Reply-To: <20140103004710.GA31411@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Thu, Jan 02, 2014 at 07:47:10PM -0500, Theodore Ts'o wrote:
> On Thu, Jan 02, 2014 at 08:43:54AM +0200, Baruch Siach wrote:
> > Use posix_fadvise64() when available. This allows 64bit offsets on =
32bit
> > systems.
> >=20
> > Rename the internal posix_fadvise() implementation to avoid collisi=
on with the
> > C library signature that is sometimes present event when the implem=
entation
> > itself is not. This fixes build errors like:
> >=20
> > e4defrag.c:189:2: warning: #warning Using locally defined posix_fad=
vise interface. [-Wcpp
> > e4defrag.c:203:12: error: conflicting types for =E2=80=98posix_fadv=
ise=E2=80=99
> >=20
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>=20
> Thanks, applied.

Thanks. You seem to have applied v1 of this patch without the #else com=
ment=20
fix. I'll fix this up in a follow up patch. Please push your tree so I =
can=20
reference this commit in the log.

Another problem with this patch is that it doesn't takes into account t=
he=20
problem of passing 64bit values on 32bit architectures. See the discuss=
ion=20
under NOTES in the syscall(2) man page for more information on that. I'=
ll try=20
to address this in another patch if you think it's worth it. The soluti=
on is=20
likely to look quite ugly when taking the arch specific alignment requi=
rements=20
also into account. The alternative is to require C library support for=20
fadvise64_64 on 32bit architectures.

What do you think?

baruch

--=20
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Sy=
stems
=3D}------------------------------------------------ooO--U--Ooo--------=
----{=3D
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

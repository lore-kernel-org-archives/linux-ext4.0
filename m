From: Ingo Molnar <mingo@elte.hu>
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Date: Thu, 28 Oct 2010 19:17:01 +0200
Message-ID: <20101028171701.GA18368@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
 <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
 <20101028163854.GA15450@elte.hu>
 <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:54979 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933943Ab0J1RRP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 13:17:15 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 28, 2010 at 9:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Point taken in any case, i'll read your edited changelog and will c=
hange the
> > template accordingly.
> >
> > Would this:
> >
> > =C2=A0Upstream commit 5dabfc7 ("ext4: rename {exit,init}_ext4_*() t=
o
> > =C2=A0ext4_{exit,init}_*()"), breaks the build on all[yes/mod]confi=
g with
> > =C2=A0CONFIG_EXT4_FS_XATTR disabled:
> >
> > =C2=A0...
> >
> > have been better?
>=20
> Yes. Except for the kernel the default git commit abbreviation is bor=
derline too=20
> short. Seven hex-chars can easily alias with a few more pulls from me=
: git will=20
> not give aliases at the time it gives a shorthand, but a month or two=
 later the=20
> abbreviated commit may no longer be unique.
>=20
> So I suggest using --abbrev=3D12 or similar.

ok. A helper script i use does this:

   git log --pretty=3Dformat:"%h: %s" $@

I have added --abbrev=3D12. Might make sense to lengthen the %h default=
 in upstream=20
Git as well?

> What I ended up writing your commit as was this:
>=20
>     ext4: fix compile with CONFIG_EXT4_FS_XATTR disabled
>=20
>     Commit 5dabfc78dced ("ext4: rename {exit,init}_ext4_*() to
>     ext4_{exit,init}_*()") causes
>=20
>       fs/ext4/super.c:4776: error: implicit declaration of function =E2=
=80=98ext4_init_xattr=E2=80=99
>=20
>     when CONFIG_EXT4_FS_XATTR is disabled.
>=20
>     It renamed init_ext4_xattr to ext4_init_xattr but forgot to updat=
e the
>     dummy definition in fs/ext4/xattr.h.
>=20
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Acked-by: "Theodore Ts'o" <tytso@mit.edu>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> but that's just me.

Ok, this indeed is much nicer to read.

Thanks,

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

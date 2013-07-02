From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Date: Tue, 2 Jul 2013 20:04:47 +0200
Message-ID: <20130702180447.GB16282@quack.suse.cz>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
 <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab3GBSEv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jul 2013 14:04:51 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-07-13 10:18:32, Linus Torvalds wrote:
> Hmm I'm getting this compiler warning:
>=20
>   fs/ext4/inode.c: In function =E2=80=98ext4_writepages=E2=80=99:
>   fs/ext4/inode.c:2219:6: warning: =E2=80=98err=E2=80=99 may be used =
uninitialized in
> this function [-Wmaybe-uninitialized]
>=20
> and I think the compiler is right to warn. The 'err' variable is set
> inside a whilte() and an if() statement, and it is not at all obvious
> that those codepaths are always taken.
>=20
> Maybe that "map->m_len" is always guaranteed to be nonzero, and the
> "while()" statement could be a "do { } while()" one. But if so, make
> it so, don't write code as if it might never be executed, when the
> return value seems to *depend* on it being executed.
  That's caused by my patches (only for certain gcc versions). map->m_l=
en
is guaranteed to be > 0 in the first iteration (the function is called =
from
under if (map->m_len > 0)). I though Ted silenced that warning but
apparently he did not. The cleanest fix is likely to make a do-while lo=
op
from that one. I'll send Ted a patch for that.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] Reiserfs & ext3 changes for 3.16-rc1
Date: Wed, 11 Jun 2014 19:37:30 +0200
Message-ID: <20140611173730.GA9511@quack.suse.cz>
References: <20140604202758.GC22927@quack.suse.cz>
 <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 07-06-14 16:52:49, Linus Torvalds wrote:
> On Wed, Jun 4, 2014 at 1:27 PM, Jan Kara <jack@suse.cz> wrote:
> >   Hello Linus,
> >
> >   could you please pull from
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for=
_linus
> >
> > to get big reiserfs cleanup from Jeff, an ext3 deadlock fix, and so=
me small
> > cleanups.
>=20
> This does not work at all for me:
>=20
>   fs/reiserfs/do_balan.c: In function =E2=80=98balance_leaf_new_nodes=
=E2=80=99:
>   fs/reiserfs/do_balan.c:1248:3: error: implicit declaration of
> function =E2=80=98format_bh=E2=80=99 [-Werror=3Dimplicit-function-dec=
laration]
>      RFALSE(!buffer_journaled(tb->S_new[i])
>      ^
>=20
> Hmm? "format_bh()"?
  Bah, so I screwed up and apparently didn't push out my for_next branc=
h
after merging patches from Jeff so various build bots didn't catch the
problem and I only compiled kernels without CONFIG_REISERFS_DEBUG_CHECK=
 so
I didn't see the problem either. Anyway, I've added commit fixing this =
to
my for_next & for_linus branches (things now compile fine) and I'll sen=
d
you new pull request. I'm sorry for the mess.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR

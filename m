From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V5 1/5] quota: Add reservation support for delayed
	block allocation
Date: Tue, 13 Jan 2009 20:09:31 +0100
Message-ID: <20090113190931.GI10064@duck.suse.cz>
References: <1231216808.9267.22.camel@mingming-laptop> <20090106100645.GH10705@duck.suse.cz> <1231805946.6752.17.camel@mingming-laptop> <20090113153748.GE10064@duck.suse.cz> <1231872797.8719.6.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1231872797.8719.6.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 13-01-09 10:53:17, Mingming Cao wrote:
> =E5=9C=A8 2009-01-13=E4=BA=8C=E7=9A=84 16:37 +0100=EF=BC=8CJan Kara=E5=
=86=99=E9=81=93=EF=BC=9A
> > On Mon 12-01-09 16:19:06, Mingming Cao wrote:
> > > Thanks for your review and suggestions. All points are taken. I h=
ave
> > > updated the quota patches.I am attaching the updated patch here j=
ust for
> > > your review.
> > >=20
> > > I am waiting for the ext4 tree to updated to rebase the whole ser=
ies
> > > against 2.6.29-rc1 plus ext4 patch queue. =20
> > >=20
> >   <snip>
> > > Quota: Add quota reservation support
> > >=20
> > > Delayed allocation defers the block allocation at the dirty pages
> > > flush-out time, doing quota charge/check at that time is too late=
=2E
> > > But we can't charge the quota blocks until blocks are really allo=
cated,
> > > otherwise users could get overcharged after reboot from system cr=
ash.
> > >=20
> > > This patch adds quota reservation for delayed llocation. Quota bl=
ocks
> > > are reserved in memory, inode and quota won't gets dirtied until =
later
> > > block allocation time.
> > >=20
> > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> >   The patch is fine. You can add
> >=20
> >   Acked-by: Jan Kara <jack@suse.cz>
> >=20
> >   How do you want to merge the patches? Via ext4 patch queue?
> > There's one generic quota patch that I also need to push to fix som=
e OCFS2
> > issue and it collides with your patchset. And also there're further
> > cleanups in quota code which are long overdue which I want to base =
on all
> > other patches. So I've decided to setup quota git tree. I'll pull i=
n your
> > two VFS quota patches. Will that work for you?
>=20
> I think a quota tree is the best place to hold all these quota change=
s.
> The ext4 part probably make sense to stay together with the vfs chang=
es,
> but it will need to coordinate with Ted's ext4 tree.  Ted, what do yo=
u
> think?
  Yes. The best would be if could pull quota changes from my tree but y=
ou
could also just carry your two patches and only leave merging them with
vanilla to me.

> BTW, there are other two quota cleanup patches that you have already
> acked. I will sent the 2.6.29-rc1 based version.
  Yes. Thanks.

> >   The tree should be soon at:
> > git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git
> >   The branch you can pull from is for_next (or for_mm if there'll b=
e
> > some more long term experimental stuff but I'm not aware of anythin=
g like
> > that now).

									Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

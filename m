From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO
	whentry_to_release_page fails
Date: Wed, 06 Aug 2008 15:57:57 -0700
Message-ID: <1218063477.6383.41.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
	 <1217953055.7899.11.camel@think.oraclecorp.com>
	 <1217971027.7516.20.camel@mingming-laptop>
	 <1218029114.15342.58.camel@think.oraclecorp.com>
	 <20080806135337.GA3615@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Mason <chris.mason@oracle.com>,
	Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080806135337.GA3615@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


=E5=9C=A8 2008-08-06=E4=B8=89=E7=9A=84 15:53 +0200=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> On Wed 06-08-08 09:25:13, Chris Mason wrote:
> > On Tue, 2008-08-05 at 14:17 -0700, Mingming Cao wrote:
> > > =E5=9C=A8 2008-08-05=E4=BA=8C=E7=9A=84 12:17 -0400=EF=BC=8CChris =
Mason=E5=86=99=E9=81=93=EF=BC=9A
> > > > On Tue, 2008-08-05 at 13:51 +0900, Hisashi Hifumi wrote:
> > > > > >> >=20
> > > > > >> > diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c=20
> > > > > >linux-2.6.27-rc1/fs/jbd/transaction.c
> > > > > >> > --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29=
=20
> > > > > >19:28:47.000000000 +0900
> > > > > >> > +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:=
40:12.000000000 +0900
> > > > > >> > @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(j=
ournal_
> > > > > >> >  	*/
> > > > > >> >  	if (ret =3D=3D 0 && (gfp_mask & __GFP_WAIT) && (gfp_ma=
sk & __GFP_FS)) {
> > > > > >> >  		journal_wait_for_transaction_sync_data(journal);
> > > > > >> > +
> > > > > >> > +		bh =3D head;
> > > > > >> > +		do {
> > > > > >> > +			while (atomic_read(&bh->b_count))
> > > > > >> > +				schedule();
> > > > > >> > +		} while ((bh =3D bh->b_this_page) !=3D head);
> > > > > >> >  		ret =3D try_to_free_buffers(page);
> > > > > >> >  	}
> > > > > >>=20
> > > > > >> The loop is problematic.  If the scheduler decides to keep=
 running this
> > > > > >> task then we have a busy loop.  If this task has realtime =
policy then
> > > > > >> it might even lock up the kernel.
> > > > > >>=20
> > > > > >
> > > > > >ocfs2 calls journal_try_to_free_buffers too, looping on b_co=
unt might
> > > > > >not be the best idea there either.
> > > > > >
> > > > > >This code gets called from releasepage, which is used other =
places than
> > > > > >the O_DIRECT invalidation paths, I'd be worried about perfor=
mance
> > > > > >problems here.
> > > > > >
> > > > >=20
> > > > > try_to_release_page has gfp_mask parameter. So when try_to_re=
leasepage
> > > > > is called from performance sensitive part, gfp_mask should no=
t be set.
> > > > > b_count check loop is inside of (gfp_mask & __GFP_WAIT) && (g=
fp_mask & __GFP_FS) check.
> > > >=20
> > > > Looks like try_to_free_pages will go into releasepage with wait=
 & fs
> > > > both set.  This kind of change would make me very nervous.
> > > >=20
> > >=20
> > > Hi Chris,
> > >=20
> > > The gfp_mask try_to_free_pages() takes from it's caller will past=
 it
> > > down to try_to_release_page().  Based on the meaning of __GFP_WAI=
T and
> > > GFP_FS, if the upper level caller set these two flags,  I assume =
the
> > > upper level caller expect delay and wait for fs to finish?
> > >=20
> > >=20
> > > But I agree that using a loop in journal_try_to_free_buffers() to=
 wait
> > > for the busy bh release the counter is expensive...
> >=20
> > I rediscovered your old thread about trying to do this in a launder=
_page
> > call ;)
>   Yes, we thought about using launder_page() before :).
>=20
> > Does it make more sense to fix do_launder_page to call into the FS =
on
> > every page, and let the FS check for PageDirty on its own?  That wa=
y
> > invalidate_inode_pages2_range basically gets its own private call i=
nto
> > the FS that says wait around until this page is really free.
>   That would certainly work as well. But IMHO waiting for ->writepage=
()
> call to finish isn't really a big deal even in try_to_release_page() =
if
> __GFP_FS (and __GFP_WAIT) is set. The only problem is that there is n=
o
> effective way to do so and so Hisashi used that "wait for b_count to =
drop"
> which looks really scary and I don't like it as well.
>=20

I was  looking at the comment in invalidate_complete_page2(), which is
now only called from DIO path, it saids

/*
 * This is like invalidate_complete_page(), except it ignores the page'=
s
 * refcount.  We do this because invalidate_inode_pages2() needs
stronger
 * invalidation guarantees, and cannot afford to leave pages behind
because
 * shrink_page_list() has a temp ref on them, or because they're
transiently
 * sitting in the lru_cache_add() pagevecs.
 */


I am wondering why we need stronger invalidate hurantees for DIO->
invalidate_inode_pages_range(),which force the page being removed from
page cache? In case of bh is busy due to ext3 writeout,
journal_try_to_free_buffers() could return different error number(EBUSY=
)
to try_to_releasepage() (instead of EIO).  In that case,  could we just
leave the page in the cache, clean pageuptodate() (to force later buffe=
r
read to read from disk) and then invalidate_complete_page2() return
successfully? Any issue with this way?

Mingming




> 									Honza

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

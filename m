From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd jbd2: fix dio
	writereturningEIOwhentry_to_release_page fails
Date: Tue, 12 Aug 2008 13:06:39 -0700
Message-ID: <1218571599.6423.22.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
	 <1217953055.7899.11.camel@think.oraclecorp.com>
	 <1217971027.7516.20.camel@mingming-laptop>
	 <1218029114.15342.58.camel@think.oraclecorp.com>
	 <20080806135337.GA3615@duck.suse.cz>
	 <1218063477.6383.41.camel@mingming-laptop>
	 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
	 <1218104494.15342.171.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
	 <1218200055.15342.230.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
	 <1218547706.15342.305.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zach Brown <zach.brown@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1218547706.15342.305.camel@think.oraclecorp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


=E5=9C=A8 2008-08-12=E4=BA=8C=E7=9A=84 09:28 -0400=EF=BC=8CChris Mason=E5=
=86=99=E9=81=93=EF=BC=9A=20
> On Mon, 2008-08-11 at 15:25 +0900, Hisashi Hifumi wrote:
> > >> >> >I am wondering why we need stronger invalidate hurantees for=
 DIO->
> > >> >> >invalidate_inode_pages_range(),which force the page being re=
moved from
> > >> >> >page cache? In case of bh is busy due to ext3 writeout,
> > >> >> >journal_try_to_free_buffers() could return different error n=
umber(EBUSY)
> > >> >> >to try_to_releasepage() (instead of EIO).  In that case,  co=
uld we just
> > >> >> >leave the page in the cache, clean pageuptodate() (to force =
later buffer
> > >> >> >read to read from disk) and then invalidate_complete_page2()=
 return
> > >> >> >successfully? Any issue with this way?
> > >> >>=20
> > >> >> My idea is that journal_try_to_free_buffers returns EBUSY if =
it fails due to
> > >> >> bh busy, and dio write falls back to buffered write. This is =
easy to fix.
> > >> >>=20
> > >> >>=20
> > >> >
> > >> >What about the invalidates done after the DIO has already run
> > >> >non-buffered?
> > >>=20
> > >> Dio write falls back to buffered IO when writing to a hole on ex=
t3, I=20
> > >think. I want to=20
> > >> apply this mechanism to fix this issue. When try_to_release_page=
 fails on=20
> > >a page=20
> > >> due to bh busy, dio write does buffered write, sync_page_range, =
and=20
> > >> wait_on_page_writeback, imvalidates page cache to preserve dio s=
emantics.=20
> > >> Even if page invalidation that is carried out after=20
> > >wait_on_page_writeback fails,=20
> > >> there is no inconsistency between HDD and page cache.
> > >>=20
> > >
> > >Sorry, I'm sure I wasn't very clear, I was referencing this code f=
rom
> > >mm/filemap.c:
> > >
> > >        written =3D mapping->a_ops->direct_IO(WRITE, iocb, iov, po=
s, *nr_segs);
> > >
> > >        /*
> > >         * Finally, try again to invalidate clean pages which migh=
t have been
> > >         * cached by non-direct readahead, or faulted in by get_us=
er_pages()
> > >         * if the source of the write was an mmap'ed region of the=
 file
> > >         * we're writing.  Either one is a pretty crazy thing to d=
o,
> > >         * so we don't support it 100%.  If this invalidation
> > >         * fails, tough, the write still worked...
> > >         */
> > >        if (mapping->nrpages) {
> > >                invalidate_inode_pages2_range(mapping,
> > >                                              pos >> PAGE_CACHE_SH=
IFT, end);
> > >        }
> > >
> > >If this second invalidate fails during a DIO write, we'll have up =
to
> > >date pages in cache that don't match the data on disk.  It is unli=
kely
> > >to fail because the conditions that make jbd unable to free a buff=
er are
> > >rare, but it can still happen with the write combination of mmap u=
sage.
> > >
> > >The good news is the second invalidate doesn't make O_DIRECT retur=
n
> > >-EIO.  But, it sounds like fixing do_launder_page to always call i=
nto
> > >the FS can fix all of these problems.  Am I missing something?
> > >
> >=20
> > My approach is not implementing do_launder_page for ext3.
> > It is needed to modify VFS.
> >=20
> > My patch is as follows:
>=20
> Sorry, I'm still not sure why the do_launder_page implementation is a
> bad idea.  Clearly Mingming spent quite some time on it in the past, =
but
> given that it could provide a hook for the FS to do expensive operati=
ons
> to make the page really go away, why not do it?
>=20

> As far as I can tell, the only current users afs, nfs and fuse.  Push=
ing
> down the PageDirty check to those filesystems should be trivial.
>=20
>=20

I thought about your suggestion before, there should be no problem to
push down the pagedirty check to underlying fs.=20

 My concern is  even if we wait for  page writeback cleared  (from
ext3_ordered_writepage() )in the launder_page() ,  (which the wait
actually already done in previous DIO ->filemap_write_wait()),
ext3_ordered_writepage()  still possibly hold the ref to the bh and
later journal_try_to_free_buffers() could still fail due to that.

>        ->ext3_ordered_writepage()
>          walk_page_buffers() <- take a bh ref
>          block_write_full_page() <- unlock_page
>               : <- end_page_writeback
>                 : <- race! (dio write->try_to_release_page fails)

 here is the  window.
>                  walk_page_buffers() <-release a bh ref


And we need someway to notify DIO code from ext3_ordered_writepage() to
indicating they are done with those buffers. That's the hard way, as Ja=
n
mentioned.

> With that said, I don't have strong feelings against falling back to
> buffered IO when the invalidate fails. =20
>=20
>=20
It seems a little odd that we have to back to buffered IO in this case.
The pages are all flushed,  DIO just want to make sure the
journaltransactions who still keep those buffers are removed from their
list. It did that, the only reason to keep DIO fail is someone else
hasn't release the bh.

Current code enforce all the buffers have to be freed and pages are
removed from page cache, in order to force later read are from disk.  I
am not sure why can't we just leave the page in the cache, just clear i=
t
uptodate flag, without reduce the page ref count?   I think DIO should
proceed it's IO in this case...


--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

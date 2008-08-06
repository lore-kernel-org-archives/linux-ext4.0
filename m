From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO when
	try_to_release_page fails
Date: Wed, 6 Aug 2008 14:47:29 +0200
Message-ID: <20080806124728.GC9233@duck.suse.cz>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2> <1217970194.7516.13.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jack@suse.cz,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1217970194.7516.13.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

On Tue 05-08-08 14:03:14, Mingming Cao wrote:
> =E5=9C=A8 2008-08-04=E4=B8=80=E7=9A=84 20:10 +0900=EF=BC=8CHisashi Hi=
fumi=E5=86=99=E9=81=93=EF=BC=9A
> > Hi
> >=20
> > Dio write returns EIO when try_to_release_page fails because bh is
> > still referenced.
> > The patch=20
> > "commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
> > Author: Mingming Cao <cmm@us.ibm.com>
> > Date:   Fri Jul 25 01:46:22 2008 -0700
> >=20
> >     jbd: fix race between free buffer and commit transaction
> > "=20
> > was merged into 2.6.27-rc1, but I noticed that this patch is not en=
ough
> > to fix the race.
> > I did fsstress test heavily to 2.6.27-rc1, and found that dio write=
 still=20
> > sometimes got EIO through this test.
>=20
> :(  thought we beat that race pretty hard already.T
>=20
> Could you send me the fsstree command to reproduce the race?
  It is a part of ext3-tools package Andrew has somewhere and also LTP =
has
it I think.

> > The patch above fixed race between freeing buffer(dio) and committi=
ng=20
> > transaction(jbd) but I discovered that there is another race,=20
> > freeing buffer(dio) and ext3/4_ordered_writepage.
> > : background_writeout()
> >      ->write_cache_pages()
> >        ->ext3_ordered_writepage()
> >      	   walk_page_buffers() <- take a bh ref
> >  	   block_write_full_page() <- unlock_page
> > 		: <- end_page_writeback
> >                 : <- race! (dio write->try_to_release_page fails)
> >       	   walk_page_buffers() <-release a bh ref
> >=20
> > ext3_ordered_writepage holds bh ref and does unlock_page remaining=20
> > taking a bh ref, so this causes the race and failure of=20
> > try_to_release_page.
> >=20
>=20
> I thought about this before, the race seems unlikely to me. Perhaps I
> missed something, but DIO code already waiting for all the pending IO=
 to
> finish before calling try_to_release_page which eventually called
> journal_try_to_free_buffers(). During this call, the inode mutx is ho=
ld
> to prevent the new writer (buffered/DIO) to re-dirty the pages. If th=
ere
> is background writeout happens when DIO is kicked in, DIO will wait f=
or
> all the pages writeback bit clear first. here is the stack
  Yes, but in principle, nothing assures that writeback of buffers does=
 not
finish even before block_write_full_page() returns. So there is possibl=
y a
window after PageWriteback is cleared (and thus filemap_fdatawait()
finishes) and before buffer references are dropped.
  Now what is more likely in practice is that all buffers of the page a=
re
written during transaction commit. So they are clean but the page remai=
ns
dirty. Now background writeback happens, sees dirty page, calls:
  ext3_ordered_writepage()
    block_write_full_page()
      - finds all buffers are clean -> end_page_writeback()
- and at this point direct IO happens which happily proceeds upto a poi=
nt
  where try_to_release_page() fails because ext3_ordered_writepage() ha=
s
  not yet dropped its references to buffers. Nasty.

  So we really need some nice and effective way in which ->writepage()
calls (and possibly others) could synchronize with try_to_release_page(=
)
(which has __GFP_WAIT and __GFP_FS and is thus willing to wait a bit). =
But
I don't have a good candidate...

								Honza
> generic_file_aio_write()
>   -> mutex_lock(&inode->i_mutex);
>   -> __generic_file_aio_write_nolock()
>      -> generic_file_direct_IO()
>         ->filemap_write_and_wait()
>            -> filemap_fdatawait()
>               -> wait_on_page_writeback_range()
>                                                 (=3D=3D=3D=3D waiting=
 for
> pending IO to finish =3D=3D=3D=3D)
>       ->invalidate_inode_pages2_range()
>           ->invalidate_inode_pages2()
>              ->try_to_releasepage()
>                 ->ext3_releasepage()
>                     ->journal_try_to_free_buffers()
>=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

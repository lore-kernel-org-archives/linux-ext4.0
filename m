From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO when
	try_to_release_page fails
Date: Tue, 05 Aug 2008 14:03:14 -0700
Message-ID: <1217970194.7516.13.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50365 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762062AbYHEVDc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Aug 2008 17:03:32 -0400
In-Reply-To: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-04=E4=B8=80=E7=9A=84 20:10 +0900=EF=BC=8CHisashi Hifu=
mi=E5=86=99=E9=81=93=EF=BC=9A
> Hi
>=20
> Dio write returns EIO when try_to_release_page fails because bh is
> still referenced.
> The patch=20
> "commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
> Author: Mingming Cao <cmm@us.ibm.com>
> Date:   Fri Jul 25 01:46:22 2008 -0700
>=20
>     jbd: fix race between free buffer and commit transaction
> "=20
> was merged into 2.6.27-rc1, but I noticed that this patch is not enou=
gh
> to fix the race.
> I did fsstress test heavily to 2.6.27-rc1, and found that dio write s=
till=20
> sometimes got EIO through this test.

:(  thought we beat that race pretty hard already.T

Could you send me the fsstree command to reproduce the race?

> The patch above fixed race between freeing buffer(dio) and committing=
=20
> transaction(jbd) but I discovered that there is another race,=20
> freeing buffer(dio) and ext3/4_ordered_writepage.
> : background_writeout()
>      ->write_cache_pages()
>        ->ext3_ordered_writepage()
>      	   walk_page_buffers() <- take a bh ref
>  	   block_write_full_page() <- unlock_page
> 		: <- end_page_writeback
>                 : <- race! (dio write->try_to_release_page fails)
>       	   walk_page_buffers() <-release a bh ref
>=20
> ext3_ordered_writepage holds bh ref and does unlock_page remaining=20
> taking a bh ref, so this causes the race and failure of=20
> try_to_release_page.
>=20

I thought about this before, the race seems unlikely to me. Perhaps I
missed something, but DIO code already waiting for all the pending IO t=
o
finish before calling try_to_release_page which eventually called
journal_try_to_free_buffers(). During this call, the inode mutx is hold
to prevent the new writer (buffered/DIO) to re-dirty the pages. If ther=
e
is background writeout happens when DIO is kicked in, DIO will wait for
all the pages writeback bit clear first. here is the stack

generic_file_aio_write()
  -> mutex_lock(&inode->i_mutex);
  -> __generic_file_aio_write_nolock()
     -> generic_file_direct_IO()
        ->filemap_write_and_wait()
           -> filemap_fdatawait()
              -> wait_on_page_writeback_range()
                                                (=3D=3D=3D=3D waiting f=
or
pending IO to finish =3D=3D=3D=3D)
      ->invalidate_inode_pages2_range()
          ->invalidate_inode_pages2()
             ->try_to_releasepage()
                ->ext3_releasepage()
                    ->journal_try_to_free_buffers()

> Following patch fixes this race.
> Thanks.
>=20
> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>=20
> diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c linux-2.6.27-rc1=
/fs/jbd/transaction.c
> --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 19:28:47.000=
000000 +0900
> +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.0000000=
00 +0900
> @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
>  	*/
>  	if (ret =3D=3D 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS=
)) {
>  		journal_wait_for_transaction_sync_data(journal);
> +
> +		bh =3D head;
> +		do {
> +			while (atomic_read(&bh->b_count))
> +				schedule();
> +		} while ((bh =3D bh->b_this_page) !=3D head);
>  		ret =3D try_to_free_buffers(page);
>  	}
>=20
> diff -Nrup linux-2.6.27-rc1.org/fs/jbd2/transaction.c linux-2.6.27-rc=
1/fs/jbd2/transaction.c
> --- linux-2.6.27-rc1.org/fs/jbd2/transaction.c	2008-07-29 19:28:47.00=
0000000 +0900
> +++ linux-2.6.27-rc1/fs/jbd2/transaction.c	2008-07-29 20:56:42.000000=
000 +0900
> @@ -1583,6 +1583,12 @@ int jbd2_journal_try_to_free_buffers(jou
>  	*/
>  	if (ret =3D=3D 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS=
)) {
>  		jbd2_journal_wait_for_transaction_sync_data(journal);
> +
> +		bh =3D head;
> +		do {
> +			while (atomic_read(&bh->b_count))
> +				schedule();
> +		} while ((bh =3D bh->b_this_page) !=3D head);
>  		ret =3D try_to_free_buffers(page);
>  	}
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

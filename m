From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO
	whentry_to_release_page fails
Date: Tue, 05 Aug 2008 14:35:54 -0700
Message-ID: <1217972154.7516.25.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <6.0.0.20.2.20080805104519.03c9b3d8@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20080805104519.03c9b3d8@172.19.0.2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


=E5=9C=A8 2008-08-05=E4=BA=8C=E7=9A=84 11:36 +0900=EF=BC=8CHisashi Hifu=
mi=E5=86=99=E9=81=93=EF=BC=9A
> >>=20
> >> diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c=20
> >linux-2.6.27-rc1/fs/jbd/transaction.c
> >> --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29=20
> >19:28:47.000000000 +0900
> >> +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.0000=
00000 +0900
> >> @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
> >>  	*/
> >>  	if (ret =3D=3D 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP=
_FS)) {
> >>  		journal_wait_for_transaction_sync_data(journal);
> >> +
> >> +		bh =3D head;
> >> +		do {
> >> +			while (atomic_read(&bh->b_count))
> >> +				schedule();
> >> +		} while ((bh =3D bh->b_this_page) !=3D head);
> >>  		ret =3D try_to_free_buffers(page);
> >>  	}
> >
> >The loop is problematic.  If the scheduler decides to keep running t=
his
> >task then we have a busy loop.  If this task has realtime policy the=
n
> >it might even lock up the kernel.
> >=20
> >Perhaps we can use wait_on_page_writeback()?
> >
>=20
> We cannot use wait_on_page_writeback() to wait for releasing bh ref b=
ecause
> in ext3_ordered_writepage() bh ref is grabbed and released through wa=
lk_page_buffers
> so between both walk_page_buffers, it remains taking a bh ref even if=
 end_page_writeback
> is performed.
>       ->ext3_ordered_writepage()
>      	   walk_page_buffers() <- take a bh ref
>  	   block_write_full_page() <- unlock_page
> 		: <- end_page_writeback
>                 : <- race! (dio write->try_to_release_page fails): --=
-> remains taking a bh ref
>       	   walk_page_buffers() <-release a bh ref
>=20

Okay, I see the race window, DIO could come in before
walk_page_buffers() release the bh reference. So far I don't see a nice=
r
way to sync between background  writeout with DIO path yet...

Mingming

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

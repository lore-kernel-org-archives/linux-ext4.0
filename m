From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4: Fix clear_buffer_dirty() call for mblk_io_submit writepages path
Date: Mon, 31 Jan 2011 16:15:33 -0800
Message-ID: <AANLkTikk-ngjGfWDwryPtMdQ6+660YC3ScpXTHLkKx_A@mail.gmail.com>
References: <AANLkTi=Mzjqoo_QWNLSjhS5CKt9JdTQB6iHEWp_NPuw_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:32616 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1BAAPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Jan 2011 19:15:54 -0500
Received: from kpbe11.cbf.corp.google.com (kpbe11.cbf.corp.google.com [172.25.105.75])
	by smtp-out.google.com with ESMTP id p110FrJs015196
	for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 16:15:53 -0800
Received: from qwe4 (qwe4.prod.google.com [10.241.194.4])
	by kpbe11.cbf.corp.google.com with ESMTP id p110EZRK017593
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 16:15:52 -0800
Received: by qwe4 with SMTP id 4so6276278qwe.35
        for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 16:15:52 -0800 (PST)
In-Reply-To: <AANLkTi=Mzjqoo_QWNLSjhS5CKt9JdTQB6iHEWp_NPuw_@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry:  I forgot to mention that I tested this on 2.6.37 under KVM
with the postgresql script specified by Ted in
1449032be17abb69116dbc393f67ceb8bd034f92 -- without this commit, and
hence by default using the multiblock writepages submittal code.

Without the patch, I'd hit the corruption problem about 50-70% of the
time.  With the patch, I executed the script > 100 times with no
corruption seen.

Curt

On Mon, Jan 31, 2011 at 12:44 PM, Curt Wohlgemuth <curtw@google.com> wr=
ote:
> The ext4 code path to bundle multiple pages for writeback in
> ext4_bio_write_page() had a bug: =A0we should be clearing buffer head=
 dirty
> flags before we submit the bio, not in the completion routine.
>
> Also don't deference the bio in ext4_end_bio() after the bio_put() ca=
ll.
>
> (I also added a blank line in ext4_bio_write_page(), 'cause my eyes
> constantly confused the complex 'for' conditions from the first state=
ment
> in the block.)
>
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>
> ---
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 6e0e99b..c3d490f 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -193,6 +193,7 @@ static void ext4_end_bio(struct bio *bio, int err=
or)
> =A0 =A0 =A0 =A0struct inode *inode;
> =A0 =A0 =A0 =A0unsigned long flags;
> =A0 =A0 =A0 =A0int i;
> + =A0 =A0 =A0 sector_t bi_sector =3D bio->bi_sector;
>
> =A0 =A0 =A0 =A0BUG_ON(!io_end);
> =A0 =A0 =A0 =A0bio->bi_private =3D NULL;
> @@ -210,9 +211,7 @@ static void ext4_end_bio(struct bio *bio, int err=
or)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (error)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SetPageError(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(!head);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (head->b_size =3D=3D PAGE_CACHE_SIZE=
)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_dirty(head=
);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (head->b_size !=3D PAGE_CACHE_SIZE) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t io_end_offset =3D=
 io_end->offset + io_end->size;
>
> @@ -224,7 +223,6 @@ static void ext4_end_bio(struct bio *bio, int err=
or)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0if (error)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0buffer_io_error(bh);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 clear_buffer_dirty(bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (bu=
ffer_delay(bh))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0partial_write =3D 1;
> @@ -260,7 +258,7 @@ static void ext4_end_bio(struct bio *bio, int err=
or)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned lon=
g long) io_end->offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (long) io_end=
->size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned lon=
g long)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio->bi_sect=
or >> (inode->i_blkbits - 9));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bi_sector >>=
 (inode->i_blkbits - 9));
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* Add the io_end to per-inode completed io list*/
> @@ -383,6 +381,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io=
,
>
> =A0 =A0 =A0 =A0blocksize =3D 1 << inode->i_blkbits;
>
> + =A0 =A0 =A0 BUG_ON(!PageLocked(page));
> =A0 =A0 =A0 =A0BUG_ON(PageWriteback(page));
> =A0 =A0 =A0 =A0set_page_writeback(page);
> =A0 =A0 =A0 =A0ClearPageError(page);
> @@ -400,12 +399,14 @@ int ext4_bio_write_page(struct ext4_io_submit *=
io,
> =A0 =A0 =A0 =A0for (bh =3D head =3D page_buffers(page), block_start =3D=
 0;
> =A0 =A0 =A0 =A0 =A0 =A0 bh !=3D head || !block_start;
> =A0 =A0 =A0 =A0 =A0 =A0 block_start =3D block_end, bh =3D bh->b_this_=
page) {
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_end =3D block_start + blocksize;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (block_start >=3D len) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_buffer_dirty(bh)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_buffer_uptodate(bh=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_dirty(bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D io_submit_add_bh(io, io_page, =
inode, wbc, bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: bio_add_page rw mode check by merge_bvec_fn
Date: Thu, 21 Nov 2013 19:08:25 +0100
Message-ID: <528E4C19.70507@itwm.fraunhofer.de>
References: <528E4A50.7040609@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kent Overstreet <kmo@daterainc.com>, NeilBrown <neilb@suse.de>,
	Jens Axboe <axboe@kernel.dk>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:38321 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KUSI2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Nov 2013 13:08:28 -0500
In-Reply-To: <528E4A50.7040609@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[CCing linux-fsdevel instead of accidental fhgfs cc]

On 11/21/2013 07:00 PM, Bernd Schubert wrote:
> Hi all,
>
> raid5_mergeable_bvec() (q->merge_bvec_fn) checks for the rw-type and
> makes decisions based on that if the bio is mergable or not. But so far
> this value is only initialized on calling submit_bio(),
> at least not by ext4 and xfs. I have not checked other file system so far.
>
> Question 1: merge_bvec_fn is supposed to be removed, is is
> still worth to fix the usage of merge_bvec_fn?
>
> Question 2: If it is still supposed to be fixed, how do want to have
> it? So far I have two patches for xfs and ext4 to set the rw type
> directly there, but maybe bio_add_page should get an int rw_type
> parameter and set bio->bi_rw itself?
>
>
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index d488f80..4cddc15 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -370,6 +370,7 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
>          bio->bi_bdev = bh->b_bdev;
>          bio->bi_end_io = ext4_end_bio;
>          bio->bi_private = ext4_get_io_end(io->io_end);
> +       bio->bi_rw |= io->io_op;
>          io->io_bio = bio;
>          io->io_next_block = bh->b_blocknr;
>          return 0;
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 71c8c9d..b48048f 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -401,7 +401,8 @@ xfs_submit_ioend_bio(
>
>   STATIC struct bio *
>   xfs_alloc_ioend_bio(
> -       struct buffer_head      *bh)
> +       struct buffer_head      *bh,
> +       struct writeback_control *wbc)
>   {
>          int                     nvecs = bio_get_nr_vecs(bh->b_bdev);
>          struct bio              *bio = bio_alloc(GFP_NOIO, nvecs);
> @@ -409,6 +410,7 @@ xfs_alloc_ioend_bio(
>          ASSERT(bio->bi_private == NULL);
>          bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>          bio->bi_bdev = bh->b_bdev;
> +       bio->bi_rw |= (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
>          return bio;
>   }
>
> @@ -511,7 +513,8 @@ xfs_submit_ioend(
>
>                          if (!bio) {
>    retry:
> -                               bio = xfs_alloc_ioend_bio(bh);
> +                               bio = xfs_alloc_ioend_bio(bh, wbc);
> +
>                          } else if (bh->b_blocknr != lastblock + 1) {
>                                  xfs_submit_ioend_bio(wbc, ioend, bio);
>                                  goto retry;
>
>
>
> Thanks,
> Bernd
>


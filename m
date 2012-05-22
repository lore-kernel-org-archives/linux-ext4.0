From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [RFC 1/3] block: Context support
Date: Tue, 22 May 2012 09:52:43 +0530
Message-ID: <CAKLKtzeB4vP41FNxUk87KV_d7+KxpYwM33eWYrFspnFN+9TtZw@mail.gmail.com>
References: <1337182230-11839-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arnd.bergmann@linaro.org, venkat@linaro.org,
	Deepak Saxena <deepak.saxena@linaro.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:32841 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2EVEWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2012 00:22:44 -0400
Received: by qcro28 with SMTP id o28so3709749qcr.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 May 2012 21:22:43 -0700 (PDT)
In-Reply-To: <1337182230-11839-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Group,

Will you please provide some feedback on the following RFC patches,

[RFC 1/3] block: Context support
[RFC 2/3] ext4: Context support


Regards
Saugata


On 16 May 2012 21:00, Saugata Das <saugata.das@stericsson.com> wrote:
> From: Saugata Das <saugata.das@linaro.org>
>
> On eMMC and UFS devices there is a new feature of setting context wit=
h each
> read or write. The idea is to classify the data from different files =
and
> apply the realibility on the complete file instead of individual writ=
es,
> which helps in performance. A new address space operation has been a =
added
> to get the context from file system and set up the bi_context field i=
n bio.
> Then we need to ensure that bio from different contexts are not merge=
d. The
> context is then passed to the underlying driver as part of the read o=
r write
> request. Since the number of MMC contexts is limited, multiple file s=
ystem
> contexts are mapped to single MMC context.
>
> Signed-off-by: Saugata Das <saugata.das@linaro.org>
> ---
> =A0block/blk-core.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
> =A0block/blk-merge.c =A0 =A0 =A0 =A0 =A0 | =A0 =A03 +++
> =A0fs/mpage.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 12 +++++++++++=
+
> =A0include/linux/blk_types.h =A0 | =A0 =A01 +
> =A0include/linux/blkdev.h =A0 =A0 =A0| =A0 =A01 +
> =A0include/linux/buffer_head.h | =A0 =A02 ++
> =A0include/linux/fs.h =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
> =A07 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1f61b74..274e05d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1309,6 +1309,7 @@ void init_request_from_bio(struct request *req,=
 struct bio *bio)
> =A0 =A0 =A0 =A0req->errors =3D 0;
> =A0 =A0 =A0 =A0req->__sector =3D bio->bi_sector;
> =A0 =A0 =A0 =A0req->ioprio =3D bio_prio(bio);
> + =A0 =A0 =A0 req->context =3D bio->bi_context;
> =A0 =A0 =A0 =A0blk_rq_bio_prep(req->q, req, bio);
> =A0}
>
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 160035f..ed70d56 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -497,6 +497,9 @@ bool blk_rq_merge_ok(struct request *rq, struct b=
io *bio)
> =A0 =A0 =A0 =A0if (bio_integrity(bio) !=3D blk_integrity_rq(rq))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return false;
>
> + =A0 =A0 =A0 if (bio->bi_context !=3D rq->bio->bi_context)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> +
> =A0 =A0 =A0 =A0return true;
> =A0}
>
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 0face1c..4889842 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -293,6 +293,12 @@ alloc_new:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto confused;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (page && page->mapping && page->mapping->a_ops &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page->mapping->a_ops->get_context)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_context =3D page->mapping->a_op=
s->get_context(page);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_context =3D 0;
> +
> =A0 =A0 =A0 =A0length =3D first_hole << blkbits;
> =A0 =A0 =A0 =A0if (bio_add_page(bio, page, length, 0) < length) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio =3D mpage_bio_submit(READ, bio);
> @@ -581,6 +587,12 @@ alloc_new:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto confused;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (page && page->mapping && page->mapping->a_ops &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page->mapping->a_ops->get_context)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_context =3D page->mapping->a_op=
s->get_context(page);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_context =3D 0;
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Must try to add the page before marking the buffer =
clean or
> =A0 =A0 =A0 =A0 * the confused fail path above (OOM) will be very con=
fused when
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 4053cbd..f3ac448 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -42,6 +42,7 @@ struct bio {
>
> =A0 =A0 =A0 =A0unsigned short =A0 =A0 =A0 =A0 =A0bi_vcnt; =A0 =A0 =A0=
 =A0/* how many bio_vec's */
> =A0 =A0 =A0 =A0unsigned short =A0 =A0 =A0 =A0 =A0bi_idx; =A0 =A0 =A0 =
=A0 /* current index into bvl_vec */
> + =A0 =A0 =A0 unsigned long =A0 =A0 =A0 =A0 =A0 bi_context; =A0 =A0 /=
* context of this bio */
>
> =A0 =A0 =A0 =A0/* Number of segments in this BIO after
> =A0 =A0 =A0 =A0 * physical address coalescing is performed.
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2aa2466..0dd9a08 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -167,6 +167,7 @@ struct request {
> =A0 =A0 =A0 =A0struct list_head timeout_list;
> =A0 =A0 =A0 =A0unsigned int timeout;
> =A0 =A0 =A0 =A0int retries;
> + =A0 =A0 =A0 unsigned long context; =A0/* context of this request */
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * completion callback.
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.=
h
> index 13bba17..0776564 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -72,6 +72,8 @@ struct buffer_head {
> =A0 =A0 =A0 =A0struct list_head b_assoc_buffers; /* associated with a=
nother mapping */
> =A0 =A0 =A0 =A0struct address_space *b_assoc_map; =A0 =A0 =A0/* mappi=
ng this buffer is
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 associated with */
> + =A0 =A0 =A0 unsigned long =A0 b_context; /* context for this buffer=
 within the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 storage device */
> =A0 =A0 =A0 =A0atomic_t b_count; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* users=
 using this buffer_head */
> =A0};
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8de6755..4b379d8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -626,6 +626,7 @@ struct address_space_operations {
> =A0 =A0 =A0 =A0int (*is_partially_uptodate) (struct page *, read_desc=
riptor_t *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0unsigned long);
> =A0 =A0 =A0 =A0int (*error_remove_page)(struct address_space *, struc=
t page *);
> + =A0 =A0 =A0 int (*get_context)(struct page *);
> =A0};
>
> =A0extern const struct address_space_operations empty_aops;
> --
> 1.7.4.3
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

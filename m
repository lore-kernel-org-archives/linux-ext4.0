From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH v2 1/2] block: add BH_Meta flag
Date: Tue, 22 May 2012 09:48:24 +0530
Message-ID: <CAKLKtzeRNLho7MTM_w2h2+P6gehC4PvkP9VohOJL0+7kAn9VTQ@mail.gmail.com>
References: <1337257290-28547-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	patches@linaro.org, arnd.bergmann@linaro.org, venkat@linaro.org,
	lporzio@micron.com, adilger@dilger.ca, bharrosh@panasas.com,
	deepak.saxena@linaro.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1337257290-28547-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted, Christoph

Will you please provide your feedback for these patch set,
[PATCH v2 1/2] block: add BH_Meta flag
[PATCH v2 2/2] ext4: annotate all meta data requests

If there is no comment then will you please merge them.


Regards
Saugata


On 17 May 2012 17:51, Saugata Das <saugata.das@stericsson.com> wrote:
> From: Saugata Das <saugata.das@linaro.org>
>
> Today, storage devices like eMMC has special features like data taggi=
ng
> (introduced in MMC-4.5 version) in order to improve performance of so=
me
> specific writes. On MMC stack, data tagging is used for all writes wh=
ich
> has REQ_META flag set. This patch adds the capability to add REQ_META=
 flag
> during meta data write.
>
> Signed-off-by: Saugata Das <saugata.das@linaro.org>
>
> changes in v2:
> =A0 =A0 =A0 =A0Replaced the conditionals around submit_bh as suggeste=
d in the review
> =A0 =A0 =A0 =A0comments from Boaz
> ---
> =A0fs/buffer.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A06 ++++--
> =A0include/linux/buffer_head.h | =A0 =A02 ++
> =A02 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 36d6665..942c75b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1685,7 +1685,8 @@ static int __block_write_full_page(struct inode=
 *inode, struct page *page,
> =A0 =A0 =A0 =A0do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *next =3D bh->b_thi=
s_page;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (buffer_async_write(bh)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op, bh)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (buffer=
_meta(bh) << __REQ_META), bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_underway++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =3D next;
> @@ -1739,7 +1740,8 @@ recover:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *next =3D bh->b_thi=
s_page;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (buffer_async_write(bh)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_buffer_dirty(bh)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op, bh)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (buffer=
_meta(bh) << __REQ_META), bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_underway++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =3D next;
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.=
h
> index 458f497..13bba17 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -34,6 +34,7 @@ enum bh_state_bits {
> =A0 =A0 =A0 =A0BH_Write_EIO, =A0 /* I/O error on write */
> =A0 =A0 =A0 =A0BH_Unwritten, =A0 /* Buffer is allocated on disk but n=
ot written */
> =A0 =A0 =A0 =A0BH_Quiet, =A0 =A0 =A0 /* Buffer Error Prinks to be qui=
et */
> + =A0 =A0 =A0 BH_Meta, =A0 =A0 =A0 =A0/* Is meta */
>
> =A0 =A0 =A0 =A0BH_PrivateStart,/* not a state bit, but the first bit =
available
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * for private allocat=
ion by other entities
> @@ -124,6 +125,7 @@ BUFFER_FNS(Delay, delay)
> =A0BUFFER_FNS(Boundary, boundary)
> =A0BUFFER_FNS(Write_EIO, write_io_error)
> =A0BUFFER_FNS(Unwritten, unwritten)
> +BUFFER_FNS(Meta, meta)
>
> =A0#define bh_offset(bh) =A0 =A0 =A0 =A0 =A0((unsigned long)(bh)->b_d=
ata & ~PAGE_MASK)
> =A0#define touch_buffer(bh) =A0 =A0 =A0 mark_page_accessed(bh->b_page=
)
> --
> 1.7.4.3
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

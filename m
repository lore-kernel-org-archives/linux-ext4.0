From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH 1/2] block: add BH_Meta flag
Date: Wed, 16 May 2012 17:27:29 +0530
Message-ID: <CAKLKtzeQ6agVs1rDhfYa33+fgzW3A7BF6apYinaRqXjhcjGrVQ@mail.gmail.com>
References: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger@whamcloud.com, arnd.bergmann@linaro.org, venkat@linaro.org,
	Deepak Saxena <dsaxena@linaro.org>,
	Saugata Das PURKAYASTHA <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: tytso@mit.edu, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted, Christoph

Will you please comment on the following patch set,
[PATCH 1/2] block: add BH_Meta flag
[PATCH 2/2] ext4: annotate all meta data requests

If there is no remark, then will you please merge them to the next vers=
ion.


Thanks,
Saugata


On 11 May 2012 20:32, Saugata Das <saugata.das@stericsson.com> wrote:
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
> ---
> =A0fs/buffer.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 10 ++++++++--
> =A0include/linux/buffer_head.h | =A0 =A02 ++
> =A02 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 36d6665..688b38b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1685,7 +1685,10 @@ static int __block_write_full_page(struct inod=
e *inode, struct page *page,
> =A0 =A0 =A0 =A0do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *next =3D bh->b_thi=
s_page;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (buffer_async_write(bh)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op, bh)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_meta(bh))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_=
bh(write_op | REQ_META, bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_=
bh(write_op, bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_underway++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =3D next;
> @@ -1739,7 +1742,10 @@ recover:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *next =3D bh->b_thi=
s_page;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (buffer_async_write(bh)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_buffer_dirty(bh)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op, bh)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_meta(bh))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_=
bh(write_op | REQ_META, bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_=
bh(write_op, bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_underway++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =3D next;
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.=
h
> index ef26043..0776564 100644
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
> @@ -126,6 +127,7 @@ BUFFER_FNS(Delay, delay)
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

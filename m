From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH 1/2] block: add BH_Meta flag
Date: Mon, 14 May 2012 10:24:39 +0530
Message-ID: <CAKLKtzfp1pue1f6Ht9vEUS4mv0sOZhrjaS4b_ONgO8j1TsGMTw@mail.gmail.com>
References: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
	<87wr4f1qsm.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, adilger@whamcloud.com, hch@infradead.org,
	arnd.bergmann@linaro.org, venkat@linaro.org
To: Namhyung Kim <namhyung.kim@lge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64885 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2ENEyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2012 00:54:40 -0400
Received: by qabj40 with SMTP id j40so4192833qab.1
        for <linux-ext4@vger.kernel.org>; Sun, 13 May 2012 21:54:39 -0700 (PDT)
In-Reply-To: <87wr4f1qsm.fsf@sejong.aot.lge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 14 May 2012 07:12, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Hi,
>
> On Fri, 11 May 2012 20:32:56 +0530, Saugata Das wrote:
>> From: Saugata Das <saugata.das@linaro.org>
>>
>> Today, storage devices like eMMC has special features like data tagg=
ing
>> (introduced in MMC-4.5 version) in order to improve performance of s=
ome
>> specific writes. On MMC stack, data tagging is used for all writes w=
hich
>> has REQ_META flag set. This patch adds the capability to add REQ_MET=
A flag
>> during meta data write.
>>
>
> AFAIK, the REQ_META is only for marking a bio/req to be recognized wh=
en
> using blktrace or something. You can use REQ_PRIO for the purpose but=
 it
> applies only if your ioscheduler is CFQ.
>
> But I'm not aware how the MMC stack works, so I might be missing some=
thing.
>

Today on ext4, REQ_META or REQ_PRIO are only used during read
operation. For meta-data writes, no special flag (REQ_META or
REQ_PRIO) is set.

On eMMC, we depend on REQ_META flag to implement the "reliable write"
and "data tag" feature, which are linked with additional reliability
and performance for file system meta-data writes.


> Thanks,
> Namhyung
>
>
>> Signed-off-by: Saugata Das <saugata.das@linaro.org>
>> ---
>> =A0fs/buffer.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 10 ++++++++--
>> =A0include/linux/buffer_head.h | =A0 =A02 ++
>> =A02 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 36d6665..688b38b 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1685,7 +1685,10 @@ static int __block_write_full_page(struct ino=
de *inode, struct page *page,
>> =A0 =A0 =A0 do {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *next =3D bh->b_this_=
page;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_async_write(bh)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op, bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_meta(bh))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(=
write_op | REQ_META, bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(=
write_op, bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_underway++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D next;
>> @@ -1739,7 +1742,10 @@ recover:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *next =3D bh->b_this_=
page;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_async_write(bh)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_dirty(bh);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(write_op, bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_meta(bh))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(=
write_op | REQ_META, bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_bh(=
write_op, bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_underway++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D next;
>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head=
=2Eh
>> index ef26043..0776564 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -34,6 +34,7 @@ enum bh_state_bits {
>> =A0 =A0 =A0 BH_Write_EIO, =A0 /* I/O error on write */
>> =A0 =A0 =A0 BH_Unwritten, =A0 /* Buffer is allocated on disk but not=
 written */
>> =A0 =A0 =A0 BH_Quiet, =A0 =A0 =A0 /* Buffer Error Prinks to be quiet=
 */
>> + =A0 =A0 BH_Meta, =A0 =A0 =A0 =A0/* Is meta */
>>
>> =A0 =A0 =A0 BH_PrivateStart,/* not a state bit, but the first bit av=
ailable
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* for private allocat=
ion by other entities
>> @@ -126,6 +127,7 @@ BUFFER_FNS(Delay, delay)
>> =A0BUFFER_FNS(Boundary, boundary)
>> =A0BUFFER_FNS(Write_EIO, write_io_error)
>> =A0BUFFER_FNS(Unwritten, unwritten)
>> +BUFFER_FNS(Meta, meta)
>>
>> =A0#define bh_offset(bh) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((unsigned l=
ong)(bh)->b_data & ~PAGE_MASK)
>> =A0#define touch_buffer(bh) =A0 =A0 mark_page_accessed(bh->b_page)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

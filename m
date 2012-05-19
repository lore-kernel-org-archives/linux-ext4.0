From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [RFC 3/3] mmc: Context support
Date: Sat, 19 May 2012 11:00:00 +0530
Message-ID: <CAKLKtzcbr0j8BV_xJ_y7kTYHyAur6tAS_OxFxwJkf=tGp7UhRw@mail.gmail.com>
References: <1337182230-11839-1-git-send-email-saugata.das@stericsson.com>
	<1337182230-11839-3-git-send-email-saugata.das@stericsson.com>
	<000001cd34f9$e5be2fc0$b13a8f40$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, arnd.bergmann@linaro.org,
	venkat@linaro.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <000001cd34f9$e5be2fc0$b13a8f40$@codeaurora.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 18 May 2012 18:56, Subhash Jadavani <subhashj@codeaurora.org> wrote:
> Hi Sougata,
>
> Please find few comments inline below.
>

Many thanks for your time and comments,


> Regards,
> Subhash
>
>> -----Original Message-----
>> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
>> owner@vger.kernel.org] On Behalf Of Saugata Das
>> Sent: Wednesday, May 16, 2012 9:01 PM
>> To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux=
-
>> mmc@vger.kernel.org
>> Cc: arnd.bergmann@linaro.org; venkat@linaro.org; saugata.das@linaro.=
org
>> Subject: [RFC 3/3] mmc: Context support
>>
>> From: Saugata Das <saugata.das@linaro.org>
>>
>> This patch implements the context ID support at MMC layer. From file
>> system (ext4), the context is passed in the request structure. At MM=
C
> layer
>> the context is retrieved from the request structure and then used in=
 the
>> CMD23 argument. Since number of MMC contexts is limited, multiple fi=
le
>> system contexts are mapped to single MMC contexts. When the REQ_SYNC
>> or REQ_FLUSH flag is set, the context is flushed or sync'ed, in whic=
h the
>> context is closed so that the data blocks are safely written out to =
non-
>> volatile memory and then the context is opened again.
>>
>> Signed-off-by: Saugata Das <saugata.das@linaro.org>
>> ---
>> =A0drivers/mmc/card/block.c | =A0 35 +++++++++++++++++++++-
>> =A0drivers/mmc/core/core.c =A0| =A0 72
>> ++++++++++++++++++++++++++++++++++++++++++++++
>> =A0drivers/mmc/core/mmc.c =A0 | =A0 28 ++++++++++++++++++
>> =A0include/linux/mmc/card.h | =A0 =A04 ++
>> =A0include/linux/mmc/core.h | =A0 =A04 ++
>> =A0include/linux/mmc/host.h | =A0 =A01 +
>> =A0include/linux/mmc/mmc.h =A0| =A0 =A03 ++
>> =A07 files changed, 145 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c ind=
ex
>> dabec55..914f942 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -958,6 +958,15 @@ static int mmc_blk_issue_flush(struct mmc_queue
>> *mq, struct request *req)
>> =A0 =A0 =A0 struct mmc_card *card =3D md->queue.card;
>> =A0 =A0 =A0 int ret =3D 0;
>>
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* The flush command is a synchronization point from fil=
e system.
>> + =A0 =A0 =A0* The contexts are flushed here to ensure that the data=
 written
>> + =A0 =A0 =A0* in the open contexts are saved reliably in non-volati=
le media
>> + =A0 =A0 =A0*/
>> + =A0 =A0 ret =3D mmc_flush_contexts(card);
>
> This is called unconditionally. Shouldn't we check if context is real=
ly
> enabled or not and host have asked (by defining MMC_CAP2_CONTEXT) for=
 it or
> not.

I think the best approach will be to set max_context_id to 0 in
mmc_read_ext_csd, if MMC_CAP2_CONTEXT is not enabled. Then, we do not
have to add a check for MMC_CAP2_CONTEXT, wherever we want to use the
context.

>
> Also shouln't this mmc_flush_contexts() be called after the
> __blk_end_request_all() in this same function?
>

I do not think so. This is in line with how mmc_flush_cache is done
today, i.e. we complete the closing/flushing all pending operations on
the device before  __blk_end_request_all.


>> + =A0 =A0 if (ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EIO;
>> +
>> =A0 =A0 =A0 ret =3D mmc_flush_cache(card);
>> =A0 =A0 =A0 if (ret)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EIO;
>> @@ -1207,11 +1216,16 @@ static void mmc_blk_rw_rq_prep(struct
>> mmc_queue_req *mqrq,
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if ((md->flags & MMC_BLK_CMD23) && mmc_op_multi(brq-
>> >cmd.opcode) &&
>> =A0 =A0 =A0 =A0 =A0 (do_rel_wr || !(card->quirks & MMC_QUIRK_BLK_NO_=
CMD23) ||
>> - =A0 =A0 =A0 =A0 =A0do_data_tag)) {
>> + =A0 =A0 =A0 =A0 =A0do_data_tag || (card->ext_csd.max_context_id > =
0))) {
>
> card->ext_csd.max_context_id can be non-zero even if host has not ena=
bled
> MMC_CAP2_CONTEXT cap. =A0So you should add proper check here before t=
agging
> the context id.
>

I will set max_context_id to 0 in mmc_read_ext_csd if MMC_CAP2_CONTEXT
is not set as mentioned above.

>> + =A0 =A0 =A0 =A0 =A0 =A0 int context_id =3D (req->context &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 card->ext_csd.max_context_=
id) ?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (req->context % card->ext_=
csd.max_context_id + 1) :
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 brq->sbc.opcode =3D MMC_SET_BLOCK_COUNT;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 brq->sbc.arg =3D brq->data.blocks |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (do_rel_wr ? (1 << 31) :=
 0) |
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (do_data_tag ? (1 << 29) :=
 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (do_data_tag ? (1 << 29) :=
 0) |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (!do_data_tag ? (context_i=
d << 25) : 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 brq->sbc.flags =3D MMC_RSP_R1 | MMC_CMD_=
AC;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 brq->mrq.sbc =3D &brq->sbc;
>> =A0 =A0 =A0 }
>> @@ -1440,6 +1454,23 @@ static int mmc_blk_issue_rq(struct mmc_queue
>> *mq, struct request *req)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mmc_blk_issue_rw_rq(mq, =
NULL);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D mmc_blk_issue_flush(mq, req);
>> =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (req && (req->cmd_flags & REQ_SYNC) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req->context && card->ext_=
csd.max_context_id) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int context_cfg_id =3D (re=
q->context) ?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req->conte=
xt % card-
>> >ext_csd.max_context_id : 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The SYNC command is a=
 synchronization point
>> from
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* file system. The rele=
vent context is sync'ed here
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to ensure that the da=
ta written in the open
>> context
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* are saved reliably in=
 non-volatile media
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (card->host->areq)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mmc_blk_is=
sue_rw_rq(mq, NULL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mmc_sync_context(card, con=
text_cfg_id);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* this write will go with=
out context to ensure
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that it is reliably=
 written */
>
> Use multiline comments format.

Ok

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req->context =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D mmc_blk_issue_rw_rq(mq, req);
>> =A0 =A0 =A0 }
>>
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c index
>> ba821fe..728145a 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -2262,6 +2262,78 @@ int mmc_cache_ctrl(struct mmc_host *host, u8
>> enable) =A0} =A0EXPORT_SYMBOL(mmc_cache_ctrl);
>>
>> +/*
>> + * Synchronize a context by first closing the context and then
>> + * opening it
>> + */
>> +int mmc_sync_context(struct mmc_card *card, int context_id) {
>> + =A0 =A0 int err =3D 0;
>> +
>> + =A0 =A0 err =3D mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 EXT_CSD_CONTEXT_CONF + context_id,
>> + =A0 =A0 =A0 =A0 =A0 =A0 0x0, card->ext_csd.generic_cmd6_time);
>> +
>> + =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return err;
>> +
>> + =A0 =A0 err =3D mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 EXT_CSD_CONTEXT_CONF + context_id,
>
> Value of context_id passed to this function can range from 1 to 15. I=
f it's
> 15 then (EXT_CSD_CONTEXT_CONF + context_id) would be 52 which is beyo=
nd the
> CONTEXT_CONF [51:37].
> So basically the index value passed to mmc_switch() should be
> (EXT_CSD_CONTEXT_CONF + context_id - 1).
>

In mmc_blk_issue_rq,  we do a "req->context %
card->ext_csd.max_context_id", which will set the context_cfg_id
between 0 and 14. We use this context_cfg_id for the mmc_sync_context.
It should fall within the range.

But in the call from mmc_flush_contexts, I should set the loop i from
0 to (max_context_id-1).

May be, it is good idea to call the parameter context_id as
context_cfg_id within mmc_sync_context to avoid confusion.

>> + =A0 =A0 =A0 =A0 =A0 =A0 0x3, card->ext_csd.generic_cmd6_time);
>> +
>> + =A0 =A0 return err;
>> +}
>> +EXPORT_SYMBOL(mmc_sync_context);
>> +
>> +int mmc_flush_contexts(struct mmc_card *card) {
>> + =A0 =A0 int i;
>
> One line space after the declaration missing.
>

Ok

>> + =A0 =A0 for (i =3D 1; i <=3D card->ext_csd.max_context_id; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int err =3D mmc_sync_context(card, i);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>
> Shouldn't we try to flush other contexts even if flush for other cont=
ext
> fails?
>

Ok. Will do. But this function will still return an error.

>> + =A0 =A0 }
>> + =A0 =A0 return 0;
>> +}
>> +EXPORT_SYMBOL(mmc_flush_contexts);
>> +
>> +/*
>> + * Initialize all the MMC contexts in read-write and non-LU mode =A0=
*/
>> +int mmc_init_context(struct mmc_card *card) {
>> + =A0 =A0 int i, err =3D 0;
>> +
>> + =A0 =A0 for (i =3D 0; i < card->ext_csd.max_context_id; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D mmc_switch(card, EXT_CSD_CMD_SET_N=
ORMAL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT_CSD_CONTEXT_CONF + i,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0x3, card-
>> >ext_csd.generic_cmd6_time);
>
> I would suggest a separate function which takes the context index,
> activation mode, large unit context as it's arguments and writes the
> activation mode in appropriate context configuration offset. So in fu=
ture if
> we want to add enable other contexts, we can use the same function.
>
> Also, let's have macro for 0x03 to indicate what it really means (rea=
d/write
> context).
>

Ok

>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_warning("%s: Activating=
 of context %d failed
>> [%x]\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mmc=
_hostname(card->host), i, err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (!err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Close the opened contexts
>> + =A0 =A0 =A0*/
>
> Why should we close the already opened contexts? Rather we can still =
use the
> opened contexts. Right?
>

Ok. We can set max_context_id to (1 + the context id we could
successfully opened).


>> + =A0 =A0 for (i =3D i-1; i >=3D 0; i--) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int err =3D mmc_switch(card, EXT_CSD_CMD_S=
ET_NORMAL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT_CSD_CONTEXT_CONF + i,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0x0, card-
>> >ext_csd.generic_cmd6_time);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_warning("%s: Closing of=
 context %d failed
>> [%x]\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mmc=
_hostname(card->host), i, err);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return err;
>> +}
>> +EXPORT_SYMBOL(mmc_init_context);
>> +
>> =A0#ifdef CONFIG_PM
>>
>> =A0/**
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c index
>> 54df5ad..84bec43 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -533,6 +533,20 @@ static int mmc_read_ext_csd(struct mmc_card *ca=
rd,
>> u8 *ext_csd)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 card->ext_csd.data_tag_u=
nit_size =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* LU size in 512 byt sectors */
>
> Typo here. s/byt/byte
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 card->ext_csd.lu_size =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ext_csd[EXT_CSD_LARGE_UNI=
T_SIZE_M1] + 1) *
>> 0x800;
>
> In this patch you are not using the large unit context anywhere then =
better
> not to read the large unit size as part of this patch. Let it be comp=
letely
> handled separately when someone adds the large unit context in future=
=2E
>

Ok

>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 card->ext_csd.max_context_id =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_csd[EXT_CSD_CONTEXT_CA=
PABILITIES] & 0x0f;
>
> This is what spec says: " The mandatory minimum value for this field =
is 5
> plus the default ID #0 (MAX_CONTEXT_ID shall be 5 or higher) ". Can y=
ou add
> check for this? And if card violates this, we at least should print a
> warning.
>

Ok

>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (card->ext_csd.max_context_id >
>> MAX_MMC_CONTEXT_ID) {
>
> Is this check required? You are already &ing with 0x0f which means th=
e
> max_context_id will never be more than MAX_MMC_CONTEXT_ID (which is 1=
5).
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_warning("%s: card has i=
nvalid number of contexts
>> [%d]\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mmc_hostna=
me(card->host),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 card->ext_=
csd.max_context_id);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 card->ext_csd.max_context_=
id =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> =A0out:
>> @@ -1267,6 +1281,20 @@ static int mmc_init_card(struct mmc_host *hos=
t,
>> u32 ocr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 if (host->caps2 & MMC_CAP2_CONTEXT) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (card->ext_csd.max_context_id > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D mmc_init_context(c=
ard);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err && err !=3D -EBADM=
SG)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto free_=
card;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_warning=
("%s: failed to activate context
>> (%x)\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 mmc_hostname(card->host),
>> err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 card->ext_=
csd.max_context_id =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 if (!oldcard)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 host->card =3D card;
>>
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h ind=
ex
>> 629b823..adf2c84 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -74,6 +74,8 @@ struct mmc_ext_csd {
>> =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0hpi_cmd; =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0/* cmd used as HPI
> */
>> =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0data_sector_size; =A0=
 =A0 =A0 /* 512 bytes or 4KB
> */
>> =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0data_tag_unit_size; =
=A0 =A0 /* DATA TAG UNIT
> size */
>> + =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0lu_size;
>> + =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0max_context_id;
>> =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0boot_ro_lock; =A0 =A0=
 =A0 =A0 =A0 /* ro lock support
> */
>> =A0 =A0 =A0 bool =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0boot_ro_lock=
able;
>> =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0raw_partit=
ion_support; =A0/* 160 */
>> @@ -184,6 +186,8 @@ struct sdio_func_tuple;
>> =A0#define MMC_NUM_PHY_PARTITION =A0 =A0 =A0 =A06
>> =A0#define MAX_MMC_PART_NAME_LEN =A0 =A0 =A0 =A020
>>
>> +#define MAX_MMC_CONTEXT_ID =A0 =A0 =A0 =A0 =A0 15
>> +
>> =A0/*
>> =A0 * MMC Physical partitions
>> =A0 */
>> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h ind=
ex
>> 1b431c7..a4e6bc9 100644
>> --- a/include/linux/mmc/core.h
>> +++ b/include/linux/mmc/core.h
>> @@ -179,6 +179,10 @@ extern int mmc_try_claim_host(struct mmc_host
>> *host);
>>
>> =A0extern int mmc_flush_cache(struct mmc_card *);
>>
>> +extern int mmc_sync_context(struct mmc_card *card, int context_id);
>> +extern int mmc_flush_contexts(struct mmc_card *card); extern int
>> +mmc_init_context(struct mmc_card *card);
>> +
>> =A0extern int mmc_detect_card_removed(struct mmc_host *host);
>>
>> =A0/**
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h ind=
ex
>> 0707d22..688348f 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -233,6 +233,7 @@ struct mmc_host {
>> =A0#define MMC_CAP2_NO_SLEEP_CMD =A0 =A0 =A0 =A0(1 << 4) =A0 =A0 =A0=
 =A0/* Don't allow sleep
>> command */
>> =A0#define MMC_CAP2_HS200_1_8V_SDR =A0 =A0 =A0(1 << 5) =A0 =A0 =A0 =A0=
/* can support */
>> =A0#define MMC_CAP2_HS200_1_2V_SDR =A0 =A0 =A0(1 << 6) =A0 =A0 =A0 =A0=
/* can support */
>> +#define MMC_CAP2_CONTEXT =A0 =A0 (1<<7) =A0/* Context ID supported =
*/
>> =A0#define MMC_CAP2_HS200 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (MMC_CAP2_HS20=
0_1_8V_SDR | \
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MMC_C=
AP2_HS200_1_2V_SDR)
>> =A0#define MMC_CAP2_BROKEN_VOLTAGE =A0 =A0 =A0(1 << 7) =A0 =A0 =A0 =A0=
/* Use the broken
>> voltage */
>> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h index
>> b822a2c..8f8d958 100644
>> --- a/include/linux/mmc/mmc.h
>> +++ b/include/linux/mmc/mmc.h
>> @@ -274,6 +274,7 @@ struct _mmc_csd {
>> =A0#define EXT_CSD_FLUSH_CACHE =A0 =A0 =A0 =A0 =A032 =A0 =A0 =A0/* W=
 */
>> =A0#define EXT_CSD_CACHE_CTRL =A0 =A0 =A0 =A0 =A0 33 =A0 =A0 =A0/* R=
/W */
>> =A0#define EXT_CSD_POWER_OFF_NOTIFICATION =A0 =A0 =A0 34 =A0 =A0 =A0=
/* R/W */
>> +#define EXT_CSD_CONTEXT_CONF =A0 =A0 =A0 =A0 37 =A0 =A0 =A0/* R/W *=
/
>> =A0#define EXT_CSD_DATA_SECTOR_SIZE =A0 =A0 61 =A0 =A0 =A0/* R */
>> =A0#define EXT_CSD_GP_SIZE_MULT =A0 =A0 =A0 =A0 143 =A0 =A0 /* R/W *=
/
>> =A0#define EXT_CSD_PARTITION_ATTRIBUTE =A0156 =A0 =A0 /* R/W */
>> @@ -316,6 +317,8 @@ struct _mmc_csd {
>> =A0#define EXT_CSD_POWER_OFF_LONG_TIME =A0247 =A0 =A0 /* RO */
>> =A0#define EXT_CSD_GENERIC_CMD6_TIME =A0 =A0248 =A0 =A0 /* RO */
>> =A0#define EXT_CSD_CACHE_SIZE =A0 =A0 =A0 =A0 =A0 249 =A0 =A0 /* RO,=
 4 bytes */
>> +#define EXT_CSD_LARGE_UNIT_SIZE_M1 =A0 495 =A0 =A0 /* RO */
>> +#define EXT_CSD_CONTEXT_CAPABILITIES 496 =A0 =A0 /* RO */
>> =A0#define EXT_CSD_TAG_UNIT_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0498 =
=A0 =A0 /* RO */
>> =A0#define EXT_CSD_DATA_TAG_SUPPORT =A0 =A0 499 =A0 =A0 /* RO */
>> =A0#define EXT_CSD_HPI_FEATURES =A0 =A0 =A0 =A0 503 =A0 =A0 /* RO */
>> --
>> 1.7.4.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc"=
 in
> the
>> body of a message to majordomo@vger.kernel.org More majordomo info a=
t
>> http://vger.kernel.org/majordomo-info.html
>

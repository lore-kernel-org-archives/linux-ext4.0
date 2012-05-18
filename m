From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [RFC 3/3] mmc: Context support
Date: Fri, 18 May 2012 18:56:52 +0530
Message-ID: <000001cd34f9$e5be2fc0$b13a8f40$@codeaurora.org>
References: <1337182230-11839-1-git-send-email-saugata.das@stericsson.com> <1337182230-11839-3-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <arnd.bergmann@linaro.org>, <venkat@linaro.org>,
	<saugata.das@linaro.org>
To: "'Saugata Das'" <saugata.das@stericsson.com>,
	<linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1337182230-11839-3-git-send-email-saugata.das@stericsson.com>
Content-language: en-us
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Sougata,

Please find few comments inline below.

Regards,
Subhash

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Saugata Das
> Sent: Wednesday, May 16, 2012 9:01 PM
> To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-
> mmc@vger.kernel.org
> Cc: arnd.bergmann@linaro.org; venkat@linaro.org; saugata.das@linaro.org
> Subject: [RFC 3/3] mmc: Context support
> 
> From: Saugata Das <saugata.das@linaro.org>
> 
> This patch implements the context ID support at MMC layer. From file
> system (ext4), the context is passed in the request structure. At MMC
layer
> the context is retrieved from the request structure and then used in the
> CMD23 argument. Since number of MMC contexts is limited, multiple file
> system contexts are mapped to single MMC contexts. When the REQ_SYNC
> or REQ_FLUSH flag is set, the context is flushed or sync'ed, in which the
> context is closed so that the data blocks are safely written out to non-
> volatile memory and then the context is opened again.
> 
> Signed-off-by: Saugata Das <saugata.das@linaro.org>
> ---
>  drivers/mmc/card/block.c |   35 +++++++++++++++++++++-
>  drivers/mmc/core/core.c  |   72
> ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/core/mmc.c   |   28 ++++++++++++++++++
>  include/linux/mmc/card.h |    4 ++
>  include/linux/mmc/core.h |    4 ++
>  include/linux/mmc/host.h |    1 +
>  include/linux/mmc/mmc.h  |    3 ++
>  7 files changed, 145 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c index
> dabec55..914f942 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -958,6 +958,15 @@ static int mmc_blk_issue_flush(struct mmc_queue
> *mq, struct request *req)
>  	struct mmc_card *card = md->queue.card;
>  	int ret = 0;
> 
> +	/*
> +	 * The flush command is a synchronization point from file system.
> +	 * The contexts are flushed here to ensure that the data written
> +	 * in the open contexts are saved reliably in non-volatile media
> +	 */
> +	ret = mmc_flush_contexts(card);

This is called unconditionally. Shouldn't we check if context is really
enabled or not and host have asked (by defining MMC_CAP2_CONTEXT) for it or
not.

Also shouln't this mmc_flush_contexts() be called after the
__blk_end_request_all() in this same function?

> +	if (ret)
> +		ret = -EIO;
> +
>  	ret = mmc_flush_cache(card);
>  	if (ret)
>  		ret = -EIO;
> @@ -1207,11 +1216,16 @@ static void mmc_blk_rw_rq_prep(struct
> mmc_queue_req *mqrq,
>  	 */
>  	if ((md->flags & MMC_BLK_CMD23) && mmc_op_multi(brq-
> >cmd.opcode) &&
>  	    (do_rel_wr || !(card->quirks & MMC_QUIRK_BLK_NO_CMD23) ||
> -	     do_data_tag)) {
> +	     do_data_tag || (card->ext_csd.max_context_id > 0))) {

card->ext_csd.max_context_id can be non-zero even if host has not enabled
MMC_CAP2_CONTEXT cap.  So you should add proper check here before tagging
the context id.

> +		int context_id = (req->context &&
> +			card->ext_csd.max_context_id) ?
> +			(req->context % card->ext_csd.max_context_id + 1) :
> +			0;
>  		brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
>  		brq->sbc.arg = brq->data.blocks |
>  			(do_rel_wr ? (1 << 31) : 0) |
> -			(do_data_tag ? (1 << 29) : 0);
> +			(do_data_tag ? (1 << 29) : 0) |
> +			(!do_data_tag ? (context_id << 25) : 0);
>  		brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
>  		brq->mrq.sbc = &brq->sbc;
>  	}
> @@ -1440,6 +1454,23 @@ static int mmc_blk_issue_rq(struct mmc_queue
> *mq, struct request *req)
>  			mmc_blk_issue_rw_rq(mq, NULL);
>  		ret = mmc_blk_issue_flush(mq, req);
>  	} else {
> +		if (req && (req->cmd_flags & REQ_SYNC) &&
> +			req->context && card->ext_csd.max_context_id) {
> +			int context_cfg_id = (req->context) ?
> +				req->context % card-
> >ext_csd.max_context_id : 0;
> +			/*
> +			 * The SYNC command is a synchronization point
> from
> +			 * file system. The relevent context is sync'ed here
> +			 * to ensure that the data written in the open
> context
> +			 * are saved reliably in non-volatile media
> +			 */
> +			if (card->host->areq)
> +				mmc_blk_issue_rw_rq(mq, NULL);
> +			mmc_sync_context(card, context_cfg_id);
> +			/* this write will go without context to ensure
> +			   that it is reliably written */

Use multiline comments format.

> +			req->context = 0;
> +		}
>  		ret = mmc_blk_issue_rw_rq(mq, req);
>  	}
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c index
> ba821fe..728145a 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2262,6 +2262,78 @@ int mmc_cache_ctrl(struct mmc_host *host, u8
> enable)  }  EXPORT_SYMBOL(mmc_cache_ctrl);
> 
> +/*
> + * Synchronize a context by first closing the context and then
> + * opening it
> + */
> +int mmc_sync_context(struct mmc_card *card, int context_id) {
> +	int err = 0;
> +
> +	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +		EXT_CSD_CONTEXT_CONF + context_id,
> +		0x0, card->ext_csd.generic_cmd6_time);
> +
> +	if (err)
> +		return err;
> +
> +	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +		EXT_CSD_CONTEXT_CONF + context_id,

Value of context_id passed to this function can range from 1 to 15. If it's
15 then (EXT_CSD_CONTEXT_CONF + context_id) would be 52 which is beyond the
CONTEXT_CONF [51:37].
So basically the index value passed to mmc_switch() should be
(EXT_CSD_CONTEXT_CONF + context_id - 1).

> +		0x3, card->ext_csd.generic_cmd6_time);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(mmc_sync_context);
> +
> +int mmc_flush_contexts(struct mmc_card *card) {
> +	int i;

One line space after the declaration missing.

> +	for (i = 1; i <= card->ext_csd.max_context_id; i++) {
> +		int err = mmc_sync_context(card, i);
> +		if (err)
> +			return err;

Shouldn't we try to flush other contexts even if flush for other context
fails?

> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(mmc_flush_contexts);
> +
> +/*
> + * Initialize all the MMC contexts in read-write and non-LU mode  */
> +int mmc_init_context(struct mmc_card *card) {
> +	int i, err = 0;
> +
> +	for (i = 0; i < card->ext_csd.max_context_id; i++) {
> +		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +					EXT_CSD_CONTEXT_CONF + i,
> +					0x3, card-
> >ext_csd.generic_cmd6_time);

I would suggest a separate function which takes the context index,
activation mode, large unit context as it's arguments and writes the
activation mode in appropriate context configuration offset. So in future if
we want to add enable other contexts, we can use the same function.

Also, let's have macro for 0x03 to indicate what it really means (read/write
context).

> +		if (err) {
> +			pr_warning("%s: Activating of context %d failed
> [%x]\n",
> +				   mmc_hostname(card->host), i, err);
> +			break;
> +		}
> +	}
> +
> +	if (!err)
> +		return 0;
> +
> +	/*
> +	 * Close the opened contexts
> +	 */

Why should we close the already opened contexts? Rather we can still use the
opened contexts. Right?

> +	for (i = i-1; i >= 0; i--) {
> +		int err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +					EXT_CSD_CONTEXT_CONF + i,
> +					0x0, card-
> >ext_csd.generic_cmd6_time);
> +		if (err)
> +			pr_warning("%s: Closing of context %d failed
> [%x]\n",
> +				   mmc_hostname(card->host), i, err);
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(mmc_init_context);
> +
>  #ifdef CONFIG_PM
> 
>  /**
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c index
> 54df5ad..84bec43 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -533,6 +533,20 @@ static int mmc_read_ext_csd(struct mmc_card *card,
> u8 *ext_csd)
>  		} else {
>  			card->ext_csd.data_tag_unit_size = 0;
>  		}
> +
> +		/* LU size in 512 byt sectors */

Typo here. s/byt/byte

> +		card->ext_csd.lu_size =
> +			(ext_csd[EXT_CSD_LARGE_UNIT_SIZE_M1] + 1) *
> 0x800;

In this patch you are not using the large unit context anywhere then better
not to read the large unit size as part of this patch. Let it be completely
handled separately when someone adds the large unit context in future.

> +
> +		card->ext_csd.max_context_id =
> +			ext_csd[EXT_CSD_CONTEXT_CAPABILITIES] & 0x0f;

This is what spec says: " The mandatory minimum value for this field is 5
plus the default ID #0 (MAX_CONTEXT_ID shall be 5 or higher) ". Can you add
check for this? And if card violates this, we at least should print a
warning.

> +
> +		if (card->ext_csd.max_context_id >
> MAX_MMC_CONTEXT_ID) {

Is this check required? You are already &ing with 0x0f which means the
max_context_id will never be more than MAX_MMC_CONTEXT_ID (which is 15). 

> +			pr_warning("%s: card has invalid number of contexts
> [%d]\n",
> +				mmc_hostname(card->host),
> +				card->ext_csd.max_context_id);
> +			card->ext_csd.max_context_id = 0;
> +		}
>  	}
> 
>  out:
> @@ -1267,6 +1281,20 @@ static int mmc_init_card(struct mmc_host *host,
> u32 ocr,
>  		}
>  	}
> 
> +	if (host->caps2 & MMC_CAP2_CONTEXT) {
> +		if (card->ext_csd.max_context_id > 0) {
> +			err = mmc_init_context(card);
> +			if (err && err != -EBADMSG)
> +				goto free_card;
> +			if (err) {
> +				pr_warning("%s: failed to activate context
> (%x)\n",
> +						mmc_hostname(card->host),
> err);
> +				card->ext_csd.max_context_id = 0;
> +				err = 0;
> +			}
> +		}
> +	}
> +
>  	if (!oldcard)
>  		host->card = card;
> 
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h index
> 629b823..adf2c84 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -74,6 +74,8 @@ struct mmc_ext_csd {
>  	unsigned int		hpi_cmd;		/* cmd used as HPI
*/
>  	unsigned int            data_sector_size;       /* 512 bytes or 4KB
*/
>  	unsigned int            data_tag_unit_size;     /* DATA TAG UNIT
size */
> +	unsigned int		lu_size;
> +	unsigned int		max_context_id;
>  	unsigned int		boot_ro_lock;		/* ro lock support
*/
>  	bool			boot_ro_lockable;
>  	u8			raw_partition_support;	/* 160 */
> @@ -184,6 +186,8 @@ struct sdio_func_tuple;
>  #define MMC_NUM_PHY_PARTITION	6
>  #define MAX_MMC_PART_NAME_LEN	20
> 
> +#define MAX_MMC_CONTEXT_ID		15
> +
>  /*
>   * MMC Physical partitions
>   */
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h index
> 1b431c7..a4e6bc9 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -179,6 +179,10 @@ extern int mmc_try_claim_host(struct mmc_host
> *host);
> 
>  extern int mmc_flush_cache(struct mmc_card *);
> 
> +extern int mmc_sync_context(struct mmc_card *card, int context_id);
> +extern int mmc_flush_contexts(struct mmc_card *card); extern int
> +mmc_init_context(struct mmc_card *card);
> +
>  extern int mmc_detect_card_removed(struct mmc_host *host);
> 
>  /**
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h index
> 0707d22..688348f 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -233,6 +233,7 @@ struct mmc_host {
>  #define MMC_CAP2_NO_SLEEP_CMD	(1 << 4)	/* Don't allow sleep
> command */
>  #define MMC_CAP2_HS200_1_8V_SDR	(1 << 5)        /* can support */
>  #define MMC_CAP2_HS200_1_2V_SDR	(1 << 6)        /* can support */
> +#define MMC_CAP2_CONTEXT	(1<<7)	/* Context ID supported */
>  #define MMC_CAP2_HS200		(MMC_CAP2_HS200_1_8V_SDR | \
>  				 MMC_CAP2_HS200_1_2V_SDR)
>  #define MMC_CAP2_BROKEN_VOLTAGE	(1 << 7)	/* Use the broken
> voltage */
> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h index
> b822a2c..8f8d958 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -274,6 +274,7 @@ struct _mmc_csd {
>  #define EXT_CSD_FLUSH_CACHE		32      /* W */
>  #define EXT_CSD_CACHE_CTRL		33      /* R/W */
>  #define EXT_CSD_POWER_OFF_NOTIFICATION	34	/* R/W */
> +#define EXT_CSD_CONTEXT_CONF		37	/* R/W */
>  #define EXT_CSD_DATA_SECTOR_SIZE	61	/* R */
>  #define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
>  #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
> @@ -316,6 +317,8 @@ struct _mmc_csd {
>  #define EXT_CSD_POWER_OFF_LONG_TIME	247	/* RO */
>  #define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */
>  #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
> +#define EXT_CSD_LARGE_UNIT_SIZE_M1	495	/* RO */
> +#define EXT_CSD_CONTEXT_CAPABILITIES	496	/* RO */
>  #define EXT_CSD_TAG_UNIT_SIZE		498	/* RO */
>  #define EXT_CSD_DATA_TAG_SUPPORT	499	/* RO */
>  #define EXT_CSD_HPI_FEATURES		503	/* RO */
> --
> 1.7.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


From: Saugata Das <saugata.das@stericsson.com>
Subject: [PATCH 3/3] mmc: Context support
Date: Mon, 11 Jun 2012 16:16:02 +0530
Message-ID: <1339411562-17100-3-git-send-email-saugata.das@stericsson.com>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <patches@linaro.org>, <venkat@linaro.org>,
	Saugata Das <saugata.das@linaro.org>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Saugata Das <saugata.das@linaro.org>

This patch implements the context ID support at MMC layer. From file system
(ext4), the context is passed in the request structure. At MMC layer the
context is retrieved from the request structure and then used in the CMD23
argument. Since number of MMC contexts is limited, multiple file system
contexts are mapped to single MMC contexts. When the REQ_SYNC or REQ_FLUSH
flag is set, the context is flushed or sync'ed, in which the context is
closed so that the data blocks are safely written out to non-volatile memory
and then the context is opened again.

Signed-off-by: Saugata Das <saugata.das@linaro.org>
---
 drivers/mmc/card/block.c |   37 ++++++++++++++++++++++++++-
 drivers/mmc/core/core.c  |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/mmc.c   |   25 +++++++++++++++++++
 include/linux/mmc/card.h |    6 ++++
 include/linux/mmc/core.h |    4 +++
 include/linux/mmc/host.h |    1 +
 include/linux/mmc/mmc.h  |    2 +
 7 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index dabec55..4760d5a 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -958,6 +958,15 @@ static int mmc_blk_issue_flush(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = md->queue.card;
 	int ret = 0;
 
+	/*
+	 * The flush command is a synchronization point from file system.
+	 * The contexts are flushed here to ensure that the data written
+	 * in the open contexts are saved reliably in non-volatile media
+	 */
+	ret = mmc_flush_contexts(card);
+	if (ret)
+		ret = -EIO;
+
 	ret = mmc_flush_cache(card);
 	if (ret)
 		ret = -EIO;
@@ -1207,11 +1216,16 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	 */
 	if ((md->flags & MMC_BLK_CMD23) && mmc_op_multi(brq->cmd.opcode) &&
 	    (do_rel_wr || !(card->quirks & MMC_QUIRK_BLK_NO_CMD23) ||
-	     do_data_tag)) {
+	     do_data_tag || (card->ext_csd.max_context_id > 0))) {
+		int context_id = (req->context &&
+			card->ext_csd.max_context_id) ?
+			(req->context % card->ext_csd.max_context_id + 1) :
+			0;
 		brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
 		brq->sbc.arg = brq->data.blocks |
 			(do_rel_wr ? (1 << 31) : 0) |
-			(do_data_tag ? (1 << 29) : 0);
+			(do_data_tag ? (1 << 29) : 0) |
+			(!do_data_tag ? (context_id << 25) : 0);
 		brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
 		brq->mrq.sbc = &brq->sbc;
 	}
@@ -1440,6 +1454,25 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 			mmc_blk_issue_rw_rq(mq, NULL);
 		ret = mmc_blk_issue_flush(mq, req);
 	} else {
+		if (req && (req->cmd_flags & REQ_SYNC) &&
+			req->context && card->ext_csd.max_context_id) {
+			int context_cfg_id =
+				req->context % card->ext_csd.max_context_id;
+			/*
+			 * The SYNC command is a synchronization point from
+			 * file system. The relevent context is sync'ed here
+			 * to ensure that the data written in the open context
+			 * are saved reliably in non-volatile media
+			 */
+			if (card->host->areq)
+				mmc_blk_issue_rw_rq(mq, NULL);
+			mmc_sync_context(card, context_cfg_id);
+			/*
+			 * This write will go without context to ensure
+			 * that it is reliably written
+			 */
+			req->context = 0;
+		}
 		ret = mmc_blk_issue_rw_rq(mq, req);
 	}
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index ba821fe..54857f9 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2262,6 +2262,67 @@ int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
 }
 EXPORT_SYMBOL(mmc_cache_ctrl);
 
+static inline int mmc_set_context_conf(struct mmc_card *card,
+				int context_cfg_id, int context_act_dir)
+{
+	return mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+		EXT_CSD_CONTEXT_CONF + context_cfg_id,
+		context_act_dir, card->ext_csd.generic_cmd6_time);
+}
+
+/*
+ * Synchronize a context by first closing the context and then
+ * opening it
+ */
+int mmc_sync_context(struct mmc_card *card, int context_cfg_id)
+{
+	int err = 0;
+
+	err = mmc_set_context_conf(card, context_cfg_id, MMC_CONTEXT_CLOSE);
+	if (err)
+		return err;
+
+	err = mmc_set_context_conf(card, context_cfg_id, MMC_CONTEXT_ACT_RW);
+	return err;
+}
+EXPORT_SYMBOL(mmc_sync_context);
+
+int mmc_flush_contexts(struct mmc_card *card)
+{
+	int i, err = 0;
+
+	for (i = 0; i < card->ext_csd.max_context_id; i++) {
+		int err1 = mmc_sync_context(card, i);
+		err = (err1 && !err) ? err1 : err;
+	}
+	return err;
+}
+EXPORT_SYMBOL(mmc_flush_contexts);
+
+/*
+ * Initialize all the MMC contexts in read-write and non-LU mode
+ */
+int mmc_init_context(struct mmc_card *card)
+{
+	int i, err = 0;
+
+	for (i = 0; i < card->ext_csd.max_context_id; i++) {
+		err = mmc_set_context_conf(card, i, MMC_CONTEXT_ACT_RW);
+		if (err) {
+			pr_warning("%s: Activating of context %d failed [%x]\n",
+				   mmc_hostname(card->host), i, err);
+			break;
+		}
+	}
+
+	if (!err)
+		return 0;
+
+	card->ext_csd.max_context_id = i;
+	return err;
+}
+EXPORT_SYMBOL(mmc_init_context);
+
 #ifdef CONFIG_PM
 
 /**
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 54df5ad..77476a3 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -533,6 +533,16 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		} else {
 			card->ext_csd.data_tag_unit_size = 0;
 		}
+
+		card->ext_csd.max_context_id =
+			ext_csd[EXT_CSD_CONTEXT_CAPABILITIES] & 0x0f;
+
+		if (card->ext_csd.max_context_id < VALID_MAX_MMC_CONTEXT_ID) {
+			pr_warning("%s: card has invalid number of contexts [%d]\n",
+				mmc_hostname(card->host),
+				card->ext_csd.max_context_id);
+			card->ext_csd.max_context_id = 0;
+		}
 	}
 
 out:
@@ -1267,6 +1277,21 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		}
 	}
 
+	if (host->caps2 & MMC_CAP2_CONTEXT) {
+		if (card->ext_csd.max_context_id > 0) {
+			err = mmc_init_context(card);
+			if (err && err != -EBADMSG)
+				goto free_card;
+			if (err) {
+				pr_warning("%s: failed to activate context (%x)\n",
+						mmc_hostname(card->host), err);
+				card->ext_csd.max_context_id = 0;
+				err = 0;
+			}
+		}
+	} else
+		card->ext_csd.max_context_id = 0;
+
 	if (!oldcard)
 		host->card = card;
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 629b823..3d60849 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -74,6 +74,7 @@ struct mmc_ext_csd {
 	unsigned int		hpi_cmd;		/* cmd used as HPI */
 	unsigned int            data_sector_size;       /* 512 bytes or 4KB */
 	unsigned int            data_tag_unit_size;     /* DATA TAG UNIT size */
+	unsigned int		max_context_id;
 	unsigned int		boot_ro_lock;		/* ro lock support */
 	bool			boot_ro_lockable;
 	u8			raw_partition_support;	/* 160 */
@@ -184,6 +185,11 @@ struct sdio_func_tuple;
 #define MMC_NUM_PHY_PARTITION	6
 #define MAX_MMC_PART_NAME_LEN	20
 
+#define MAX_MMC_CONTEXT_ID		15
+#define VALID_MAX_MMC_CONTEXT_ID	5
+#define MMC_CONTEXT_CLOSE		0
+#define MMC_CONTEXT_ACT_RW		3
+
 /*
  * MMC Physical partitions
  */
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 1b431c7..a4e6bc9 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -179,6 +179,10 @@ extern int mmc_try_claim_host(struct mmc_host *host);
 
 extern int mmc_flush_cache(struct mmc_card *);
 
+extern int mmc_sync_context(struct mmc_card *card, int context_id);
+extern int mmc_flush_contexts(struct mmc_card *card);
+extern int mmc_init_context(struct mmc_card *card);
+
 extern int mmc_detect_card_removed(struct mmc_host *host);
 
 /**
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0707d22..688348f 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -233,6 +233,7 @@ struct mmc_host {
 #define MMC_CAP2_NO_SLEEP_CMD	(1 << 4)	/* Don't allow sleep command */
 #define MMC_CAP2_HS200_1_8V_SDR	(1 << 5)        /* can support */
 #define MMC_CAP2_HS200_1_2V_SDR	(1 << 6)        /* can support */
+#define MMC_CAP2_CONTEXT	(1<<7)	/* Context ID supported */
 #define MMC_CAP2_HS200		(MMC_CAP2_HS200_1_8V_SDR | \
 				 MMC_CAP2_HS200_1_2V_SDR)
 #define MMC_CAP2_BROKEN_VOLTAGE	(1 << 7)	/* Use the broken voltage */
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index b822a2c..96d73aa 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -274,6 +274,7 @@ struct _mmc_csd {
 #define EXT_CSD_FLUSH_CACHE		32      /* W */
 #define EXT_CSD_CACHE_CTRL		33      /* R/W */
 #define EXT_CSD_POWER_OFF_NOTIFICATION	34	/* R/W */
+#define EXT_CSD_CONTEXT_CONF		37	/* R/W */
 #define EXT_CSD_DATA_SECTOR_SIZE	61	/* R */
 #define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
 #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
@@ -316,6 +317,7 @@ struct _mmc_csd {
 #define EXT_CSD_POWER_OFF_LONG_TIME	247	/* RO */
 #define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */
 #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
+#define EXT_CSD_CONTEXT_CAPABILITIES	496	/* RO */
 #define EXT_CSD_TAG_UNIT_SIZE		498	/* RO */
 #define EXT_CSD_DATA_TAG_SUPPORT	499	/* RO */
 #define EXT_CSD_HPI_FEATURES		503	/* RO */
-- 
1.7.4.3


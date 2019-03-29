Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F5DC10F05
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 16:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F5CE21773
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 16:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfC2Q62 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 12:58:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:1393 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729480AbfC2Q61 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Mar 2019 12:58:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Mar 2019 09:58:27 -0700
X-IronPort-AV: E=Sophos;i="5.60,285,1549958400"; 
   d="scan'208";a="129815367"
Received: from unknown (HELO [10.232.112.178]) ([10.232.112.178])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES128-SHA; 29 Mar 2019 09:58:26 -0700
Subject: Re: [PATCH v3 4/7] nvme: register stream info with block layer
To:     Kanchan Joshi <joshi.k@samsung.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, joshiiitr@gmail.com, prakash.v@samsung.com,
        anshul@samsung.com
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075753epcas1p16ce37362f83ccb8520a782b845dcb905@epcas1p1.samsung.com>
 <1553846032-4451-5-git-send-email-joshi.k@samsung.com>
From:   "Heitke, Kenneth" <kenneth.heitke@intel.com>
Message-ID: <87e172d4-dcc2-d0db-9bd1-b76afc7a9d01@intel.com>
Date:   Fri, 29 Mar 2019 10:58:25 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1553846032-4451-5-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On 3/29/2019 1:53 AM, Kanchan Joshi wrote:
> nvme registes number of streams with block layer, which will use that

s/registes/registers/ ??

> for write-hint to streamid conversion. Registration is done for each
> namespace. Since NVMe spec allow all available streams (within subsystem)
> to be used by all namespaces, no attempt has been made to add reservation
> at namespace level.
>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>   drivers/nvme/host/core.c | 19 ++++++-------------
>   1 file changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 150e497..e34386b 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -513,14 +513,7 @@ static int nvme_configure_directives(struct nvme_ctrl *ctrl)
>   		return ret;
>   
>   	ctrl->nssa = le16_to_cpu(s.nssa);
> -	if (ctrl->nssa < BLK_MAX_WRITE_HINTS - 1) {
> -		dev_info(ctrl->device, "too few streams (%u) available\n",
> -					ctrl->nssa);
> -		nvme_disable_streams(ctrl);
> -		return 0;
> -	}
> -
> -	ctrl->nr_streams = min_t(unsigned, ctrl->nssa, BLK_MAX_WRITE_HINTS - 1);
> +	ctrl->nr_streams = ctrl->nssa;
>   	dev_info(ctrl->device, "Using %u streams\n", ctrl->nr_streams);
>   	return 0;
>   }
> @@ -533,12 +526,9 @@ static void nvme_assign_write_stream(struct nvme_ctrl *ctrl,
>   				     struct request *req, u16 *control,
>   				     u32 *dsmgmt)
>   {
> -	enum rw_hint streamid = req->write_hint;
> +	enum rw_hint streamid = req->streamid;
>   
> -	if (streamid == WRITE_LIFE_NOT_SET || streamid == WRITE_LIFE_NONE)
> -		streamid = 0;
> -	else {
> -		streamid--;
> +	if (streamid != 0) {
>   		if (WARN_ON_ONCE(streamid > ctrl->nr_streams))
>   			return;
>   
> @@ -3138,6 +3128,7 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
>   {
>   	struct streams_directive_params s;
>   	int ret;
> +	u16 nr_streams;
>   
>   	if (!ctrl->nr_streams)
>   		return 0;
> @@ -3149,6 +3140,8 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
>   	ns->sws = le32_to_cpu(s.sws);
>   	ns->sgs = le16_to_cpu(s.sgs);
>   
> +	nr_streams = min_t(unsigned, ctrl->nr_streams, BLK_MAX_WRITE_HINTS - 1);
> +	blk_queue_stream_limits(ns->queue, nr_streams);
>   	if (ns->sws) {
>   		unsigned int bs = 1 << ns->lba_shift;
>   

Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F00C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 13:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FF3520674
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 13:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbfDRNw2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:52:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:46552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731317AbfDRNw1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 09:52:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E26FB6AF;
        Thu, 18 Apr 2019 13:52:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 933201E15AE; Thu, 18 Apr 2019 15:52:23 +0200 (CEST)
Date:   Thu, 18 Apr 2019 15:52:23 +0200
From:   Jan Kara <jack@suse.cz>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, prakash.v@samsung.com
Subject: Re: [PATCH v4 5/7] nvme: register stream info with block layer
Message-ID: <20190418135223.GK28541@quack2.suse.cz>
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
 <CGME20190417175400epcas2p2b166bfaef69f5a02e856743be76199f3@epcas2p2.samsung.com>
 <1555523406-2380-6-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555523406-2380-6-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 17-04-19 23:20:04, Kanchan Joshi wrote:
> Make nvme driver register number of streams with block layer. Block
> layer will use that for write-hint to stream-id conversion. Registration
> is done for each namespace. Since NVMe spec allow all available
> streams (within subsystem) to be used by all namespaces, no attempt
> has been made to add reservation at namespace level.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  drivers/nvme/host/core.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 2c43e12..81b86fa 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -464,10 +464,6 @@ static int nvme_toggle_streams(struct nvme_ctrl *ctrl, bool enable)
>  	return nvme_submit_sync_cmd(ctrl->admin_q, &c, NULL, 0);
>  }
>  
> -static int nvme_disable_streams(struct nvme_ctrl *ctrl)
> -{
> -	return nvme_toggle_streams(ctrl, false);
> -}
>  
>  static int nvme_enable_streams(struct nvme_ctrl *ctrl)
>  {
> @@ -510,14 +506,7 @@ static int nvme_configure_directives(struct nvme_ctrl *ctrl)
>  		return ret;
>  
>  	ctrl->nssa = le16_to_cpu(s.nssa);
> -	if (ctrl->nssa < BLK_MAX_WRITE_HINTS - 1) {
> -		dev_info(ctrl->device, "too few streams (%u) available\n",
> -					ctrl->nssa);
> -		nvme_disable_streams(ctrl);
> -		return 0;
> -	}
> -
> -	ctrl->nr_streams = min_t(unsigned, ctrl->nssa, BLK_MAX_WRITE_HINTS - 1);
> +	ctrl->nr_streams = ctrl->nssa;
>  	dev_info(ctrl->device, "Using %u streams\n", ctrl->nr_streams);
>  	return 0;
>  }

This changes the current behavior, doesn't it? Previously devices with less
than 5 hints got streams completely disabled, now they will have streams
enabled but ids beyond supported max will be mapped to 0. I'm not against
this but I guess it should be spelled out explicitely in the changelog.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

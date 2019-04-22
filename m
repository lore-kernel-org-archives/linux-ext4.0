Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1772C282CE
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 13:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0BD220685
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 13:43:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VXvP9Nr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfDVNnf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 09:43:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60730 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfDVNne (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2019 09:43:34 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190422134331epoutp0153c316c5e1a01747eea56e78eca4031a~Xz74srlJa1981819818epoutp01e
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2019 13:43:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190422134331epoutp0153c316c5e1a01747eea56e78eca4031a~Xz74srlJa1981819818epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555940612;
        bh=Eollxodl1iSBFBD6n5kK6/yIyrhANd8zRovulBS+xeg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=VXvP9Nr3r6u/9Jj5pHMIuHFrILlHXZpdNySyClkK3vlxPuka2YoG5ICd+SgMuL9TB
         cC7ojO5pB/GvXHrmwC27uCmATOPs0pHkBDs9K2yergrrsbKmzWkhVo2Q+QHbvUZpgH
         kXAiHkvsV5r5348sZn8y8HaJ6FY3viLlPqy8H+dM=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20190422134331epcas5p3ddc61f0da70dc38a7950712fe59fe93f~Xz74PV4II1733117331epcas5p3R;
        Mon, 22 Apr 2019 13:43:31 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.77.04067.305CDBC5; Mon, 22 Apr 2019 22:43:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20190422134330epcas5p2105a2dd5545c7e3164dd9bcbcddcad20~Xz73IK03_2826228262epcas5p2E;
        Mon, 22 Apr 2019 13:43:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190422134330epsmtrp2ac6827b9126ad9367fdbb4034745ca48~Xz73FD0lP2592225922epsmtrp2t;
        Mon, 22 Apr 2019 13:43:30 +0000 (GMT)
X-AuditID: b6c32a4b-78bff70000000fe3-ac-5cbdc5033808
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        40.63.03692.205CDBC5; Mon, 22 Apr 2019 22:43:30 +0900 (KST)
Received: from JOSHIK01 (unknown [107.111.93.135]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20190422134329epsmtip1949dba93da3cfe88086a2b5a435a2032~Xz718vHHP1320213202epsmtip1K;
        Mon, 22 Apr 2019 13:43:28 +0000 (GMT)
From:   "kanchan" <joshi.k@samsung.com>
To:     "'Jan Kara'" <jack@suse.cz>
Cc:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <prakash.v@samsung.com>
In-Reply-To: <20190418135223.GK28541@quack2.suse.cz>
Subject: RE: [PATCH v4 5/7] nvme: register stream info with block layer
Date:   Mon, 22 Apr 2019 19:13:20 +0530
Message-ID: <009d01d4f911$5ec3af70$1c4b0e50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQK8/LoE/AuxJQqBdxKlIaVgudw56QHF1WnNAplKfBECo7wDuqRAENqw
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsWy7bCmpi7z0b0xBqufiFvMnt7MZLH3lrbF
        zHl32Cz27D3JYnF51xw2i/nLnrJbXJmyiNmB3WPzknqPvi2rGD3OLDjC7vF5k1wASxSXTUpq
        TmZZapG+XQJXxrY3l5kL3ohWrN7ewNjA+E2wi5GTQ0LARGLimQ62LkYuDiGB3YwSP1d3Qjmf
        GCW2bzjBDuF8Y5S49WA/O0zL958nWSASexklPt/9ygzhPGeUOHZ1HStIFZuAqsS9H71sILaI
        gLzEjGXPGUGKmAX2M0o031jPCJLgBBrV83Il2FhhAXeJOTe3MYPYLEDNnXOXgtXwClhKbDtw
        gg3CFpQ4OfMJC4jNDDR0+9s5zBAnKUjs/nSUFWKZm8SLZY+ZIGrEJV4ePQL2g4TAYzaJvzd3
        MUE0uEg8/LYXqllY4tXxLVC/SUl8freXDcIulvh15ygzRHMHo8T1hpksEAl7iYt7/gIN4gDa
        oCmxfpc+xDI+id7fT8DCEgK8Eh1tQhDVihL3Jj1lhbDFJR7OWAJle0i0tV1mmsCoOAvJa7OQ
        vDYLyQuzEJYtYGRZxSiZWlCcm55abFpgnJdarlecmFtcmpeul5yfu4kRnH60vHcwbjrnc4hR
        gINRiYf3w6o9MUKsiWXFlbmHGCU4mJVEeH+lAYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzzpWd
        Gy0kkJ5YkpqdmlqQWgSTZeLglGpgDCmacPj+C9MbhssdHbZ5Xlmz9WSfh/HFCocztt+2603b
        /Ik3OqNG7OnSs7Ii3c1NJeeMzi5Z88xD2DVRdItG7pP3QplOs02f6e3/4WF0c+bV/yUtf3lW
        MiTwC3gtn/Ox7UVR6QVlu0Lj9FS3BXP1ZvWnqVk+Tbt47pCiy4G5Lw5bXW8/Hp5YoMRSnJFo
        qMVcVJwIAFpnvj07AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJTpfp6N4Yg117OS1mT29msth7S9ti
        5rw7bBZ79p5ksbi8aw6bxfxlT9ktrkxZxOzA7rF5Sb1H35ZVjB5nFhxh9/i8SS6AJYrLJiU1
        J7MstUjfLoErY9uby8wFb0QrVm9vYGxg/CbYxcjJISFgIvH950mWLkYuDiGB3YwSf5rPM0Ek
        xCWar/1gh7CFJVb+e84OUfSUUaKh/SILSIJNQFXi3o9eNhBbREBeYsay54wgRcwCRxklXh/q
        hur4zCjx9cAeRpAqTqB9PS9Xgo0VFnCXmHNzGzOIzQI0qXPuUrAaXgFLiW0HTrBB2IISJ2c+
        AdrGATRVT6JtI1gJM9Cy7W/nMENcpyCx+9NRVogj3CReLHvMBFEjLvHy6BH2CYzCs5BMmoUw
        aRaSSbOQdCxgZFnFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcQVqaOxgvL4k/xCjA
        wajEw/th1Z4YIdbEsuLK3EOMEhzMSiK8v9KAQrwpiZVVqUX58UWlOanFhxilOViUxHmf5h2L
        FBJITyxJzU5NLUgtgskycXBKNTDmBzxv++nayrjA/2zGBK6jCUk3ZGbouzG3ia84/JZR7eLV
        EzNlvxnt4To8qfXoG2mWH1PFrtjMzZGpV+M/3pSYzKpykc1xVt9LSevVjEu3zpMVnZTEMtuH
        j1FP4vqb9EnHfIMep77Pv2r2/q/huon2T+Uj0o18pjT1rj6jcOCTf4vHlxXq8k+VWIozEg21
        mIuKEwEdiMslnAIAAA==
X-CMS-MailID: 20190422134330epcas5p2105a2dd5545c7e3164dd9bcbcddcad20
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190417175400epcas2p2b166bfaef69f5a02e856743be76199f3
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175400epcas2p2b166bfaef69f5a02e856743be76199f3@epcas2p2.samsung.com>
        <1555523406-2380-6-git-send-email-joshi.k@samsung.com>
        <20190418135223.GK28541@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> This changes the current behavior, doesn't it? Previously devices with
less than 5 hints got streams completely disabled, now they will have
streams enabled but ids beyond supported max will be mapped to 0. I'm not
against this but I guess it should be spelled out explicitely in the
changelog.

Yes, that is a change in current behavior. Will add that in next version,
thanks.

-----Original Message-----
From: Jan Kara [mailto:jack@suse.cz] 
Sent: Thursday, April 18, 2019 7:22 PM
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: linux-kernel@vger.kernel.org; linux-block@vger.kernel.org;
linux-nvme@lists.infradead.org; linux-fsdevel@vger.kernel.org;
linux-ext4@vger.kernel.org; prakash.v@samsung.com
Subject: Re: [PATCH v4 5/7] nvme: register stream info with block layer

On Wed 17-04-19 23:20:04, Kanchan Joshi wrote:
> Make nvme driver register number of streams with block layer. Block 
> layer will use that for write-hint to stream-id conversion. 
> Registration is done for each namespace. Since NVMe spec allow all 
> available streams (within subsystem) to be used by all namespaces, no 
> attempt has been made to add reservation at namespace level.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  drivers/nvme/host/core.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c index 
> 2c43e12..81b86fa 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -464,10 +464,6 @@ static int nvme_toggle_streams(struct nvme_ctrl
*ctrl, bool enable)
>  	return nvme_submit_sync_cmd(ctrl->admin_q, &c, NULL, 0);  }
>  
> -static int nvme_disable_streams(struct nvme_ctrl *ctrl) -{
> -	return nvme_toggle_streams(ctrl, false);
> -}
>  
>  static int nvme_enable_streams(struct nvme_ctrl *ctrl)  { @@ -510,14 
> +506,7 @@ static int nvme_configure_directives(struct nvme_ctrl *ctrl)
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
> -	ctrl->nr_streams = min_t(unsigned, ctrl->nssa, BLK_MAX_WRITE_HINTS -
1);
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


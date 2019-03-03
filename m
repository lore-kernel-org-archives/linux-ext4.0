Return-Path: <SRS0=87aU=RG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A85EC43381
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 23:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8AB620842
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 23:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfCCXDx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 Mar 2019 18:03:53 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23382 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfCCXDx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2019 18:03:53 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl6.internode.on.net with ESMTP; 04 Mar 2019 09:33:35 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h0a8s-0005Z4-4D; Mon, 04 Mar 2019 10:03:34 +1100
Date:   Mon, 4 Mar 2019 10:03:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: Re: [PATCH 8/8] xfs: support project in xfs_getattr()
Message-ID: <20190303230334.GT23020@dastard>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
 <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 01, 2019 at 11:05:41PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> From: Wang Shilong <wshilong@ddn.com>
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/xfs/xfs_iops.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index c10466fe6ed4..a2f8c0f048cf 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -501,6 +501,7 @@ xfs_vn_getattr(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	stat->projid = xfs_projid_to_kprojid(xfs_get_projid(ip));

Should only be set if the caller is in the init_user_ns.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

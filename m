Return-Path: <SRS0=87aU=RG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D18C4360F
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 23:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A73DD20818
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 23:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbfCCXIY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 Mar 2019 18:08:24 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:41219 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbfCCXIY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2019 18:08:24 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl6.internode.on.net with ESMTP; 04 Mar 2019 09:38:22 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h0aDU-0005Zb-E9; Mon, 04 Mar 2019 10:08:20 +1100
Date:   Mon, 4 Mar 2019 10:08:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>,
        linux-man@vger.kernel.org
Subject: Re: [PATCH 1/2] fchownat.2: add project support updates
Message-ID: <20190303230820.GU23020@dastard>
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 01, 2019 at 11:06:22PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> From: Wang Shilong <wshilong@ddn.com>
> 
> Cc: linux-man@vger.kernel.org
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  man2/chown.2 | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/man2/chown.2 b/man2/chown.2
> index 50db789ac..fad74df20 100644
> --- a/man2/chown.2
> +++ b/man2/chown.2
> @@ -217,6 +217,11 @@ instead operate on the link itself, like
>  .BR fchownat ()
>  dereferences symbolic links, like
>  .BR chown ().)
> +.TP
> +.B AT_FCHOWN_PROJID
> +Use
> +.I group
> +to change file's project ID instead of its group ID.

Needs to document init_user_ns constraint.

>  .PP
>  See
>  .BR openat (2)

Also missing new ENOSPC error that attempting to change a project ID
can result in. Also should document the EPERM error condition when
changing project ID in wrong userns, and EINVAL if an invalid
project ID is supplied.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

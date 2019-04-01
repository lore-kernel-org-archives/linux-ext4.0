Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78530C43381
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 05:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C8920856
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 05:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfDAFMo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:12:44 -0400
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:47594 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfDAFMo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2019 01:12:44 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl6.internode.on.net with ESMTP; 01 Apr 2019 15:42:41 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hApFP-0004NU-HU; Mon, 01 Apr 2019 16:12:39 +1100
Date:   Mon, 1 Apr 2019 16:12:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, axboe@fb.com, prakash.v@samsung.com,
        anshul@samsung.com, joshiiitr@gmail.com
Subject: Re: [PATCH v3 6/7] fs: introduce write-hint start point for
 in-kernel hints
Message-ID: <20190401051239.GP26298@dastard>
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075758epcas1p335511dcb10bb5592ea72409a1d01e752@epcas1p3.samsung.com>
 <1553846032-4451-7-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553846032-4451-7-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 29, 2019 at 01:23:51PM +0530, Kanchan Joshi wrote:
> kernel-mode components can define own write-hints using
> "WRITE_LIFE_KERN_MIN" as base.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/linux/fs.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 29d8e2c..6a2673e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -291,6 +291,8 @@ enum rw_hint {
>  	WRITE_LIFE_MEDIUM	= RWH_WRITE_LIFE_MEDIUM,
>  	WRITE_LIFE_LONG		= RWH_WRITE_LIFE_LONG,
>  	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
> +/* Kernel should use write-hint starting from this */
> +	WRITE_LIFE_KERN_MIN,

Which means that when a new userspace hint is defined, all the
kernel hints change numbers and, AIUI, that changes how the kernel
hints are mapped to the underlying device.

The kernel hints need to be mapped to the highest supported number a
work down, while userspace starts at the lowest and works up. The
"kernel to device stream id" needs to translate the kernel hints
down to the upper range of the device hints.

I think the mapping range the code uses should be:

    HINT		Type			device
     0			USER 0			  0
     1			USER 1			  1
     ......
     n			USER MAX		  n

     {n,65535-m}	UNUSED			{n,dev_max-m}

     65535 - m		KERN_MIN,		dev_max - m
     ......
     65532		KERN 3			dev_max - 3
     65533		KERN 2			dev_max - 2
     65534		KERN 1			dev_max - 1
     65535		KERN 0			dev_max

i.e. if you look at the mapping as a signed short, >= 0 are user
hints, < 0 are kernel hints. This provides an obvious, simple way
to map the kernel hints to the upper range of the device hint
range. It also provides a simple way to compress both user and
kernel hints into a limited device hint range - kernel always uses
the top device hint, user is limited to the rest of the range....

This means the ranges don't overlap or change at either the
code or the device level as we add more user and kernel hint
channels in the future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

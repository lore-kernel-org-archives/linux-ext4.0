Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A46BC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 11:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6A2218D8
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 11:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfCULgr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:36:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfCULgq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 07:36:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E4A7C04F4AC;
        Thu, 21 Mar 2019 11:36:46 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CA721001E88;
        Thu, 21 Mar 2019 11:36:44 +0000 (UTC)
Date:   Thu, 21 Mar 2019 12:36:38 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 9/9] e2scrub,e2scrub_all: print a (more understandable)
 error if not run as root
Message-ID: <20190321113638.qazrsuaob4rsnh5m@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-9-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-9-tytso@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 21 Mar 2019 11:36:46 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:18PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  scrub/e2scrub.in     | 5 +++++
>  scrub/e2scrub_all.in | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
> index 301574968..666d6485a 100644
> --- a/scrub/e2scrub.in
> +++ b/scrub/e2scrub.in
> @@ -25,6 +25,11 @@
>  
>  PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
>  
> +if (( $EUID != 0 )); then

EUID is bashism and might not be available in a different shell. But I
am sure we're using a lot of those and we have "#!/bin/bash".

It's just somehting to consider, because I am not sure if we say
anywhere that those scripts will require bash. Personally I do not care
too much, but I am using bash exclusively :)

-Lukas

> +    echo "e2scrub must be run as root"
> +    exit 1
> +fi
> +
>  snap_size_mb=256
>  fstrim=0
>  reap=0
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index cad232987..a02ffe226 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -20,6 +20,11 @@
>  
>  PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
>  
> +if (( $EUID != 0 )); then
> +    echo "e2scrub_all must be run as root"
> +    exit 1
> +fi
> +
>  scrub_all=0
>  snap_size_mb=256
>  reap=0
> -- 
> 2.19.1
> 

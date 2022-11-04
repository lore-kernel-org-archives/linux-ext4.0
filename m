Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C112C433FE
	for <linux-ext4@archiver.kernel.org>; Fri,  4 Nov 2022 15:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiKDPsp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 4 Nov 2022 11:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiKDPsc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2022 11:48:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6803724F2D
        for <linux-ext4@vger.kernel.org>; Fri,  4 Nov 2022 08:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF5236225B
        for <linux-ext4@vger.kernel.org>; Fri,  4 Nov 2022 15:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364F6C433D6;
        Fri,  4 Nov 2022 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667576908;
        bh=4ERJj+U80+sWZYQEfMSkWdwcoKBDdPIhWr2PSHGekEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rK6eOfJj4gChozKs4xOrWIqUeFRhsv8PwltRbktZm+MMtT4CJlRbTpkA5RjNOek/X
         qG48liAyOokk5s2zcAori2LDiS80+j0LSqdZ4aUGjQMWRQelowDTAsr/owTQ7/yPMy
         9uNTSovUtmk5XyjUCwXyNi3HI31c3lLLivqCNA4gVr5J4t7f1tr2wUMeKB4Y6+eP3Y
         fW/1Dfr4e3XKPXCoJRDhdLBVGEZZ0s04IrgstlbpXxlUDHQwl7UZxOir727Optj23r
         YkIQ3IEO7qKfNQH8+//9xa5DLIkoccynCzFYHKZzdzpX+nJmXX8YMpvAZsCv9hlcu9
         RuyVFlRVoNKXA==
Date:   Fri, 4 Nov 2022 08:48:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ulrich =?iso-8859-1?Q?=D6lmann?= <u.oelmann@pengutronix.de>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [e2fsprogs PATCH] debugfs.8: fix typo
Message-ID: <Y2U0S0hvPyLF05nP@magnolia>
References: <20221104095835.1057703-1-u.oelmann@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221104095835.1057703-1-u.oelmann@pengutronix.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Nov 04, 2022 at 10:58:35AM +0100, Ulrich Ölmann wrote:
> Signed-off-by: Ulrich Ölmann <u.oelmann@pengutronix.de>

Looks good good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debugfs/debugfs.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
> index a3227a80ab24..5b5329c38d6e 100644
> --- a/debugfs/debugfs.8.in
> +++ b/debugfs/debugfs.8.in
> @@ -280,7 +280,7 @@ The hash seed specified with
>  must be in UUID format.
>  .TP
>  .BI dump_extents " [-n] [-l] filespec"
> -Dump the the extent tree of the inode
> +Dump the extent tree of the inode
>  .IR filespec .
>  The
>  .I -n
> -- 
> 2.30.2
> 

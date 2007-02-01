From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [patch 2/2] e2fsprogs: user selectable dup block handling in fsck
Date: Wed, 31 Jan 2007 23:16:23 -0700
Message-ID: <20070201061623.GU5404@schatzie.adilger.int>
References: <Pine.LNX.4.61.0701310737550.25489@webb> <Pine.LNX.4.61.0701310822320.25489@webb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jim Garlick <garlick@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:48765 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbXBAGQZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 01:16:25 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701310822320.25489@webb>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 31, 2007  08:24 -0800, Jim Garlick wrote:
> @@ -67,7 +68,8 @@ static const char *prompt[] = {
>  	N_("Unlink"),		/* 17 */
>  	N_("Clear HTree index"),/* 18 */
>  	N_("Recreate"),		/* 19 */
> -	"",			/* 20 */
> +	N_("Unlink file for lost+found reconnect in pass 3"), /* 20 */
>
> +	/* Unlink file for lost+found reconnect in pass 3? */
> +	{ PR_1D_DISCONNECT_QUESTION,
> +	  "", PROMPT_DISCONNECT, 0 },

Why not use PROMPT_CONNECT ("Connect to lost+found") and then
make the question "File with shared blocks found"?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

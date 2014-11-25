From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: cleanup GFP flags inside resize path V2
Date: Tue, 25 Nov 2014 13:08:36 -0500
Message-ID: <20141125180836.GD11648@thunk.org>
References: <1415958040-4393-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51084 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaKYSIn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 13:08:43 -0500
Content-Disposition: inline
In-Reply-To: <1415958040-4393-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 01:40:39PM +0400, Dmitry Monakhov wrote:
> We must use GFP_NOFS instead GFP_KERNEL inside ext4_mb_add_groupinfo because resize-path
> call  it inside journal transaction. Call trace:
> ioctl
>  ->ext4_group_add
>    ->journal_start
>    ->ext4_setup_new_descs
>      ->ext4_mb_add_groupinfo -> GFP_KERNEL
>    ->ext4_flex_group_add
>      ->ext4_update_super
>        ->ext4_calculate_overhead  -> GFP_KERNEL
>    ->journal_stop
> 
> Changes from V1:
>  - Fix up gfp flags for ext4_calculate_overhead
> 
> ext4_update_super
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks, with a slightly cleaned up commit description.

	 	      		 	    	   - Ted

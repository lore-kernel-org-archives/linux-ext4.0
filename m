From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix potential quota deadlock
Date: Thu, 10 Dec 2009 17:25:34 +0100
Message-ID: <20091210162534.GH26516@atrey.karlin.mff.cuni.cz>
References: <1260451905-3746-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50714 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761012AbZLJQZ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 11:25:28 -0500
Content-Disposition: inline
In-Reply-To: <1260451905-3746-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> We have to delay vfs_dq_claim_space() until allocation context destruction.
> Currently we have following call-trace:
> ext4_mb_new_blocks()
>   /* task is already holding ac->alloc_semp */
>  ->ext4_mb_mark_diskspace_used
>     ->vfs_dq_claim_space()  /*  acquire dqptr_sem here. Possible deadlock */
>  ->ext4_mb_release_context() /* drop ac->alloc_semp here */
> 
> Let's move quota claiming to ext4_da_update_reserve_space()
> This movement already discussed and approved during discussion
> write() vs chown() race condition.
  The patch looks good to me.

Acked-by: Jan Kara <jack@suse.cz>

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

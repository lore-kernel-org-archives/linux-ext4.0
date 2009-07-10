From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: ext4_mb_initialize_context() forgets to initialize
 some	fields
Date: Fri, 10 Jul 2009 15:59:06 -0500
Message-ID: <4A57AB9A.4050208@redhat.com>
References: <20090710204754.18406.15771.stgit@mj.roinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Pavel Roskin <proski@gnu.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56288 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZGJU7M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 16:59:12 -0400
In-Reply-To: <20090710204754.18406.15771.stgit@mj.roinet.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pavel Roskin wrote:
> kmemcheck indicates that ext4_mb_store_histroy() accesses uninitialized
> values of ac->ac_tail and ac->ac_buddy.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  fs/ext4/mballoc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 519a0a6..a5a9a35 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4223,6 +4223,8 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
>  	ac->ac_groups_scanned = 0;
>  	ac->ac_ex_scanned = 0;
>  	ac->ac_found = 0;
> +	ac->ac_tail = 0;
> +	ac->ac_buddy = 0;
>  	ac->ac_sb = sb;
>  	ac->ac_inode = ar->inode;
>  	ac->ac_o_ex.fe_logical = ar->logical;

Looks good to me; I think it's harmless in the end because we just wind
up w/ garbage in the history if anyone looks, but much better to not
have garbage! :)

At this point I think we are initializing almost all of the 22
allocation context members and 16 of those are 0/NULL; perhaps it'd be
simpler and/or more efficient to just start with a memset(0), but either
way.

(side note, looks like ac_repeats is completely unused...)

Thanks,
-Eric

From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: allow 0-length xattr values in e2fsck
Date: Fri, 12 Apr 2013 12:02:37 -0500
Message-ID: <51683E2D.90406@redhat.com>
References: <5161BE0A.5070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Shaw <dshaw@jabberwocky.com>,
	Harald Reindl <h.reindl@thelounge.net>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3DLRCq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Apr 2013 13:02:46 -0400
In-Reply-To: <5161BE0A.5070003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/7/13 1:42 PM, Eric Sandeen wrote:
> e2fsck thinks that this:
> 
> # touch mnt/testfile1
> # setfattr -n "user.test" mnt/testfile1
> 
> results in a filesystem with corruption:
> 
> Pass 1: Checking inodes, blocks, and sizes
> Extended attribute in inode 12 has a value size (0) which is invalid
> Clear? yes
> 
> but as far as I can tell, there is absolutely nothing wrong with
> a 0-length value on an extended attribute.  Just remove the check.
> 
> Reported-by: David Shaw <dshaw@jabberwocky.com>
> Reported-by: Harald Reindl <h.reindl@thelounge.net>
> Addresses-Red-Hat-Bugzilla: #557959
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Ted, just a ping on this.  I know there's been a lot going on,so
wasn't sure if you missed it, or if it's just saved for later.

Thanks,
-Eric

> ---
> 
> Strange that this has been in e2fsck since 2005; apologies to 
> David in particular for not addressing the bug he filed much sooner,
> I had assumed that this was some strange corruption, not a simple
> logic error / change.
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index a20b57b..94df36d 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -307,7 +307,7 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
>  		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
>  
>  		/* check value size */
> -		if (entry->e_value_size == 0 || entry->e_value_size > remain) {
> +		if (entry->e_value_size > remain) {
>  			pctx->num = entry->e_value_size;
>  			problem = PR_1_ATTR_VALUE_SIZE;
>  			goto fix;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


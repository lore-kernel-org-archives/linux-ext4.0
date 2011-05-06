From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: remove redundant 'extern' keyword for function-definition
Date: Fri, 6 May 2011 06:50:12 -0400
Message-ID: <811F6CB9-D7EB-41BA-B403-6530A5BF7234@mit.edu>
References: <1304669967-5677-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:53458 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab1EFKuR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 May 2011 06:50:17 -0400
In-Reply-To: <1304669967-5677-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I don't really see the point to removing redundant keywords
like this.   To my mind, it's like fixing whitespaces.   If we are 
making changes to that part of the code, it's good to fix it,
and I'd rather not introduce such things in new code, but
as far as fixing code like this, i don't think an extra "extern"
is that harmful that it's worth fixing up.

What do other people think?

-- Ted


On May 6, 2011, at 4:19 AM, Robin Dong wrote:

> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> fs/ext4/ialloc.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 21bb2f6..ace7aef 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1235,7 +1235,7 @@ unsigned long ext4_count_dirs(struct super_block * sb)
>  * inode allocation from the current group, so we take alloc_sem lock, to
>  * block ext4_claim_inode until we are finished.
>  */
> -extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
> +int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
> 				 int barrier)
> {
> 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


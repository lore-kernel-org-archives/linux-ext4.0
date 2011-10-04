From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] libext2fs: fix bad cast which causes problems for
 file systems > 512EB
Date: Tue, 04 Oct 2011 06:47:12 -0500
Message-ID: <4E8AF240.7010905@sandeen.net>
References: <20111004040033.GM6684@thunk.org> <1317702420-31085-1-git-send-email-tytso@mit.edu> <1317702420-31085-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38228 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1JDLrN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 07:47:13 -0400
In-Reply-To: <1317702420-31085-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/3/11 11:27 PM, Theodore Ts'o wrote:
> If the number of block groups exceeds 2**32, a bad cast would lead to
> a bogus "Not enough space to build proposed filesystem while setting
> up superblock" failure.

It's the proper cast now, but I don't think it fixes the problem, since they
are both __u32...

But in any case, for the actual change at least:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/initialize.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 2875f97..b050a0a 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -248,7 +248,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
>  	}
>  
>  retry:
> -	fs->group_desc_count = (blk_t) ext2fs_div64_ceil(
> +	fs->group_desc_count = (dgrp_t) ext2fs_div64_ceil(
>  		ext2fs_blocks_count(super) - super->s_first_data_block,
>  		EXT2_BLOCKS_PER_GROUP(super));
>  	if (fs->group_desc_count == 0) {


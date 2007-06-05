From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ext3/ext4] orphan list check on destroy_inode
Date: Mon, 4 Jun 2007 18:54:20 -0700
Message-ID: <20070604185420.b4206698.akpm@linux-foundation.org>
References: <4663A0BF.9010008@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org, linux-ext4@vger.kernel.org,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbXFEBzn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2007 21:55:43 -0400
In-Reply-To: <4663A0BF.9010008@sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 04 Jun 2007 09:18:55 +0400 Vasily Averin <vvs@sw.ru> wrote:

> Customers claims to ext3-related errors, investigation showed that ext3 orphan list has been corrupted and have the reference to non-ext3 inode. The following debug helps to understand the reasons of this issue.
> 
> Signed-off-by:	Vasily Averin <vvs@sw.ru>
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 6e30629..46e2fa6 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -459,6 +459,21 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
>  
>  static void ext3_destroy_inode(struct inode *inode)
>  {
> +	if (!list_empty(&(EXT3_I(inode)->i_orphan))) {
> +		int i, imax;
> +		unsigned int *p;
> +
> +		p = (unsigned int *)EXT3_I(inode);
> +		imax = sizeof(struct ext3_inode_info) / sizeof(unsigned int);
> +		printk("Inode %p: orphan list check failed!\n", EXT3_I(inode));
> +		for (i = 0; i < imax; i++) {
> +			if (i && ((i % 8) == 0))
> +				printk("\n");
> +			printk("%08x ", *p++);
> +		}
> +		printk("\n");
> +		dump_stack();

umm, OK, but please use the new lib/hexdump.c for this.

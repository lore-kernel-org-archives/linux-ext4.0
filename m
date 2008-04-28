From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Mon, 28 Apr 2008 06:37:19 -0400
Message-ID: <20080428103719.GA16030@infradead.org>
References: <20080428193123t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbYD1KhU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 06:37:20 -0400
Content-Disposition: inline
In-Reply-To: <20080428193123t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 28, 2008 at 07:31:23PM +0900, Takashi Sato wrote:
> +	/* Initialize semaphore for freeze. */
> +	sema_init(&bdev->bd_freeze_sem, 1);

The freezing process is already protected by bd_mount_sem, so I don't
think there's need for another one.

> --- linux-2.6.25.org/fs/buffer.c	2008-04-17 11:49:44.000000000 +0900
> +++ linux-2.6.25-freeze/fs/buffer.c	2008-04-24 20:43:28.000000000 +0900
> @@ -201,6 +201,19 @@ struct super_block *freeze_bdev(struct b
>  {
>  	struct super_block *sb;
>  
> +	down(&bdev->bd_freeze_sem);
> +	sb = get_super_without_lock(bdev);
> +
> +	/* If super_block has been already frozen, return. */
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		put_super(sb);
> +		up(&bdev->bd_freeze_sem);
> +		return sb;
> +	}
> +
> +	if (sb)
> +		put_super(sb);
> +
>  	down(&bdev->bd_mount_sem);
>  	sb = get_super(bdev);

I think the protection against double freezes would be better done by
using a trylock on bd_mount_sem.  In fact after that it could be changed
from a semaphore to a simple test_and_set_bit.
>  			error = -ENOTTY;
>  		break;
> +
> +	case FIFREEZE: {

This would be better to split intot a small helper ala ioctl_fibmap()

> +	case FITHAW: {

Same here.


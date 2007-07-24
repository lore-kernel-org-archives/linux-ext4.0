From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 7/13]  Many inodes in filesystem.
Date: Tue, 24 Jul 2007 10:35:33 -0400
Message-ID: <20070724143533.GC11826@thunk.org>
References: <1185275099.3789.72.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37584 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbXGXOff (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 10:35:35 -0400
Content-Disposition: inline
In-Reply-To: <1185275099.3789.72.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 04:34:59PM +0530, Girish Shilamkar wrote:
> Handle filesystems with many hard links that have more than ~700M inodes.
> The float variable lacks precision at this scale.

This was fixed in e2fsprogs mainline a slightly different way.  Just
above it:

				range = ((float) (ino - lowval)) /
					(highval - lowval);
				if (range > 0.9)
					range = 0.9;
				if (range < 0.1)
					range = 0.1;

The problem with just correcting the midpoint calculation as you
proposed in your patch is that you could end up doing a linear search
through the whole array in some really abberrant cases.  With this fix
applied in e2fsprogs, the patch below isn't required.

Regards,

					- Ted

> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Girish Shilamkar <girish@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> 
> Index: e2fsprogs-1.40.1/lib/ext2fs/icount.c
> ===================================================================
> --- e2fsprogs-1.40.1.orig/lib/ext2fs/icount.c
> +++ e2fsprogs-1.40.1/lib/ext2fs/icount.c
> @@ -376,6 +376,10 @@ static struct ext2_icount_el *get_icount
>  					range = 0.1;
>  			}
>  			mid = low + ((int) (range * (high-low)));
> +			if (mid > high)
> +				mid = high;
> +			if (mid < low)
> +				mid = low;
>  		}
>  #endif
>  		if (ino == icount->list[mid].ino) {
> 
> 

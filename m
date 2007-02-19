From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: [PATCH Take2 1/1] Nanosecond timestamps
Date: Mon, 19 Feb 2007 10:56:02 +0100
Message-ID: <20070219095602.GC2295@lombardij>
References: <1170427790.6464.6.camel@garfield> <20070206151242.GB3140@lombardij> <1171372604.16444.21.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>, sct@redhat.com,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43973 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXBSJz2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Feb 2007 04:55:28 -0500
In-Reply-To: <1171372604.16444.21.camel@garfield>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 13, 2007 at 06:46:44PM +0530, Kalpak Shah wrote:
> Index: linux-2.6.20/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.20.orig/fs/ext4/inode.c
> +++ linux-2.6.20/fs/ext4/inode.c
> @@ -2676,10 +2676,11 @@ void ext4_read_inode(struct inode * inod
>  	}
>  	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
>  	inode->i_size = le32_to_cpu(raw_inode->i_size);
> -	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
> -	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
> -	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
> -	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
> +
> +	EXT4_INODE_GET_XTIME(i_ctime, i_ctime_extra, ei, inode, raw_inode);
> +	EXT4_INODE_GET_XTIME(i_mtime, i_mtime_extra, ei, inode, raw_inode);
> +	EXT4_INODE_GET_XTIME(i_atime, i_atime_extra, ei, inode, raw_inode);
> +	EXT4_INODE_GET_XTIME(i_crtime, i_crtime_extra, ei, ei, raw_inode);

ei->i_extra_isize is not yet initialized at this point (it is set a couple of
lines lower).
I guess the consequence of this is that nanosecond timestamps are always
discarded since ei->i_extra_isize is equal to 0.

Cheers,
Johann

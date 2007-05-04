From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC/PATCH] ext3: remove inode constructor
Date: Fri, 4 May 2007 09:08:25 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705040907180.21436@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38095 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031020AbXEDQI1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 12:08:27 -0400
In-Reply-To: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 4 May 2007, Pekka J Enberg wrote:

> Index: 2.6/fs/ext3/super.c
> ===================================================================
> --- 2.6.orig/fs/ext3/super.c	2007-05-04 12:57:09.000000000 +0300
> +++ 2.6/fs/ext3/super.c	2007-05-04 13:01:27.000000000 +0300
> @@ -444,17 +444,26 @@ static struct kmem_cache *ext3_inode_cac
>  static struct inode *ext3_alloc_inode(struct super_block *sb)
>  {
>  	struct ext3_inode_info *ei;
> +	struct inode *inode;
>  
>  	ei = kmem_cache_alloc(ext3_inode_cachep, GFP_NOFS);
>  	if (!ei)
>  		return NULL;
> +        INIT_LIST_HEAD(&ei->i_orphan);
> +#ifdef CONFIG_EXT3_FS_XATTR
> +        init_rwsem(&ei->xattr_sem);
> +#endif
> +        mutex_init(&ei->truncate_mutex);

^^^ whitespace issues

Also could this be generalized to also apply to the generic inode 
allocation in fs/inode.c?

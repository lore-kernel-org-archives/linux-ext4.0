From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add basic BIGALLOC support for cluster-based allocation
Date: Sun, 27 Feb 2011 16:59:47 -0500
Message-ID: <20110227215947.GI2924@thunk.org>
References: <1298688625-19820-1-git-send-email-tytso@mit.edu>
 <AANLkTi=b8eKuiOPxUiJYaDCzu1nJ40SxNqszxONC3CZ8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45420 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab1B0Xdf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Feb 2011 18:33:35 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=b8eKuiOPxUiJYaDCzu1nJ40SxNqszxONC3CZ8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 09:20:55AM +0200, Amir Goldstein wrote:
> Just to be clear, my alternative suggestion to on-disk format change was:
> 
>         __u32   s_log_block_size;       /* Block size */
> -       __s32   s_log_frag_size;        /* Fragment size */
> +       __s32   s_log_cluster_size;     /* Allocation cluster size */
> -       __u32   s_blocks_per_group;     /* # Blocks per group */
> +       __u32   s_clusters_per_group;   /* # Clusters per group */
> -       __u32   s_frags_per_group;      /* # Fragments per group */
> +       __u32   s_blocks_per_group;   /* # Blocks per group */
>         __u32   s_inodes_per_group;     /* # Inodes per group */
> 
> This way, old kernels see a sane value in what used to be
> s_blocks_per_group (32K) and new kernels (even without the BIGALLOC
> feature) make sure to write correct values in both new
> s_blocks_per_group and s_clusters_per_group (old s_blocks_per_group)

Unfortunately, that's likely to confuse old kernels even more, since
s_blocks_per_group is used to calculate the number of block groups,
i.e. s_blocks_count / s_blocks_per_group.  In BIGALLOC mode, the
number of block groups go down, and so if we change s_blocks_per_group
to s_clusters_per_group, it's likely to cause much mischief, for
example in ext4_check_descriptors().

					- Ted

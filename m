From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix header check in ext4_ext_search_right() for deep
	extent trees.
Date: Mon, 9 Mar 2009 10:29:53 +0530
Message-ID: <20090309045953.GA26853@skywalker>
References: <49B18CAB.5020605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	David Dindorp <ddi@dubex.dk>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53780 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZCIFAD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 01:00:03 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id n294xtWj015288
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 10:29:55 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n29503Q14239558
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 10:30:03 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n294xtm4004121
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 15:59:55 +1100
Content-Disposition: inline
In-Reply-To: <49B18CAB.5020605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 06, 2009 at 02:50:51PM -0600, Eric Sandeen wrote:
> This should resolve kernel.org bugzilla 12821
> 
> I've not actually crafted a workload to exercise this code; 
> this is from inspection...
> 
> The ext4_ext_search_right() function is confusing; it uses a
> "depth" variable which is 0 at the root and maximum at the leaves, 
> but the on-disk metadata uses a "depth" (actually eh_depth) which
> is opposite: maximum at the root, and 0 at the leaves.
> 
> The ext4_ext_check_header() function is given a depth and checks
> the header agaisnt that depth; it expects the on-disk semantics,
> but we are giving it the opposite in the while loop in this 
> function.  We should be giving it the on-disk notion of "depth"
> which we can get from (p_depth - depth) - and if you look, the last
> (more commonly hit) call to ext4_ext_check_header() does just this.

Correct. Few lines below we are passing the right depth when verifying
the leaf blocks. So I guess it was a coding error.


> 
> Sending in the wrong depth results in (incorrect) messages
> about corruption:
> 
> EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
> in inode #2621457: unexpected eh_depth - magic f30a, entries 340,
> max 340(0), depth 1(2)
> 
> Reported-by: David Dindorp <ddi@dubex.dk>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


> --
> 
> Index: linux-2.6/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/extents.c
> +++ linux-2.6/fs/ext4/extents.c
> @@ -1122,7 +1122,8 @@ ext4_ext_search_right(struct inode *inod
>  	struct ext4_extent_idx *ix;
>  	struct ext4_extent *ex;
>  	ext4_fsblk_t block;
> -	int depth, ee_len;
> +	int depth;	/* Note, NOT eh_depth; depth from top of tree */
> +	int ee_len;
> 
>  	BUG_ON(path == NULL);
>  	depth = path->p_depth;
> @@ -1179,7 +1180,8 @@ got_index:
>  		if (bh == NULL)
>  			return -EIO;
>  		eh = ext_block_hdr(bh);
> -		if (ext4_ext_check_header(inode, eh, depth)) {
> +		/* subtract from p_depth to get proper eh_depth */
> +		if (ext4_ext_check_header(inode, eh, path->p_depth - depth)) {
>  			put_bh(bh);
>  			return -EIO;
>  		}
> 

-aneesh

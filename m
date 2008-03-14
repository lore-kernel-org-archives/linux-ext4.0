From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE boxes
Date: Fri, 14 Mar 2008 14:09:06 +0100
Message-ID: <n7x63vph2q5.fsf@sor.suse.de>
References: <47C882CD.3090204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYCNNJI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2008 09:09:08 -0400
In-Reply-To: <47C882CD.3090204@redhat.com> (Eric Sandeen's message of "Fri\, 29
	Feb 2008 16\:10\:21 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> After the fix for resize2fs's inode mover losing in-inode
> extended attributes, the regression test I wrote caught 
> that the attrs were still getting lost on powerpc.
>
> Looks like the problem is that ext2fs_swap_inode_full()
> isn't paying attention to whether or not the EA magic is
> in hostorder, so it's not recognized (and not swapped)
> on BE machines.  Patch below seems to fix it.
>
> Yay for regression tests.  ;)
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Index: e2fsprogs-1.40.7/lib/ext2fs/swapfs.c
> ===================================================================
> --- e2fsprogs-1.40.7.orig/lib/ext2fs/swapfs.c
> +++ e2fsprogs-1.40.7/lib/ext2fs/swapfs.c
> @@ -133,7 +133,7 @@ void ext2fs_swap_inode_full(ext2_filsys 
>  			    struct ext2_inode_large *f, int hostorder,
>  			    int bufsize)
>  {
> -	unsigned i, has_data_blocks, extra_isize;
> +	unsigned i, has_data_blocks, extra_isize, attr_magic;
>  	int islnk = 0;
>  	__u32 *eaf, *eat;
>  
> @@ -231,13 +231,17 @@ void ext2fs_swap_inode_full(ext2_filsys 
>  
>  	eaf = (__u32 *) (((char *) f) + sizeof(struct ext2_inode) +
>  					extra_isize);
> -
> -	if (ext2fs_swab32(*eaf) != EXT2_EXT_ATTR_MAGIC)
> -		return; /* it seems no magic here */
> -
>  	eat = (__u32 *) (((char *) t) + sizeof(struct ext2_inode) +
>  					extra_isize);
> +
> +	if (hostorder)
> +		attr_magic = *eaf;
>  	*eat = ext2fs_swab32(*eaf);
> +	if (!hostorder)
> +		attr_magic = *eat;
> +
> +	if (attr_magic != EXT2_EXT_ATTR_MAGIC)
> +		return; /* it seems no magic here */
>  
>  	/* convert EA(s) */
>  	ext2fs_swap_ext_attr((char *) (eat + 1), (char *) (eaf + 1),
>

This patch seems to be missing in the current e2fsprogs 1.40.8 release
(though announced in the release notes that this issue should be fixed
on BE machines).
Check r_inline_xattr still fails on ppc and s390 architectures without 
this patch. It builds fine with this patch applied.
Could you please check (also the git tag for the 1.40.8 release seems to
be missing).

Thanks,
Matthias

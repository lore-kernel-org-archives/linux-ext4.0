From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [ext4:dev 16/18] fs/ext4/extents.c:3299:21: warning: 'abut_ex'
 may be used uninitialized in this function
Date: Thu, 4 Apr 2013 10:48:51 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304041043570.30499@localhost>
References: <515d016d.ny/3beKMHFg3XP72%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, kbuild-all@01.org,
	linux-ext4@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab3DDItA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Apr 2013 04:49:00 -0400
In-Reply-To: <515d016d.ny/3beKMHFg3XP72%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 4 Apr 2013, kbuild test robot wrote:

> Date: Thu, 04 Apr 2013 12:28:29 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>, kbuild-all@01.org
> Subject: [ext4:dev 16/18] fs/ext4/extents.c:3299:21: warning: 'abut_ex' may be
>      used uninitialized in this function
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   f78ee70db40040e6f38a5134527d4760254d6683
> commit: bc2d9db48c95ec6c9c5ecc97ddc61343d751f219 [16/18] ext4: Transfer initialized block to right neighbor if possible
> config: i386-randconfig-x005-0404 (attached as .config)
> 
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.

This one is false warning, because we only have allocated set if
abut_ex is initialized as well. But I wonder if it's worth to
silence the warning just by initializing abut_ex to NULL ?

Thanks!
-Lukas


> 
> All warnings:
> 
>    fs/ext4/extents.c: In function 'ext4_ext_map_blocks':
> >> fs/ext4/extents.c:3299:21: warning: 'abut_ex' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    fs/ext4/extents.c:3156:27: note: 'abut_ex' was declared here
> 
> vim +/abut_ex +3299 fs/ext4/extents.c
> 
>   3283				ext4_ext_store_pblock(abut_ex, next_pblk - map_len);
>   3284				ex->ee_len = cpu_to_le16(ee_len - map_len);
>   3285				ext4_ext_mark_uninitialized(ex); /* Restore the flag */
>   3286	
>   3287				/* Extend abut_ex by 'map_len' blocks */
>   3288				abut_ex->ee_len = cpu_to_le16(next_len + map_len);
>   3289	
>   3290				/* Result: number of initialized blocks past m_lblk */
>   3291				allocated = map_len;
>   3292			}
>   3293		}
>   3294		if (allocated) {
>   3295			/* Mark the block containing both extents as dirty */
>   3296			ext4_ext_dirty(handle, inode, path + depth);
>   3297	
>   3298			/* Update path to point to the right extent */
> > 3299			path[depth].p_ext = abut_ex;
>   3300			goto out;
>   3301		} else
>   3302			allocated = ee_len - (map->m_lblk - ee_block);
>   3303	
>   3304		WARN_ON(map->m_lblk < ee_block);
>   3305		/*
>   3306		 * It is safe to convert extent to initialized via explicit
>   3307		 * zeroout only if extent is fully insde i_size or new_size.
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 

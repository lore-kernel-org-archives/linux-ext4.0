From: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap and
 mark_diskspace_used
Date: Mon, 24 Nov 2008 21:41:20 +0300
Message-ID: <492AF550.7000701@sun.com>
References: <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com>
 <20081124113323.GC8462@skywalker> <492AD821.9030506@sun.com>
 <20081124164300.GD8462@skywalker> <492AEC69.40202@sun.com>
 <20081124181252.GE8462@skywalker> <492AEFD1.4060701@sun.com>
 <20081124182132.GF8462@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:38619 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYKXSld (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 13:41:33 -0500
Received: from fe-emea-09.sun.com (gmp-eb-lb-1-fe3.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAOIfVmh013049
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 18:41:31 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAU00L01P24X400@fe-emea-09.sun.com>
 (original mail from Alex.Zhuravlev@Sun.COM) for linux-ext4@vger.kernel.org;
 Mon, 24 Nov 2008 18:41:31 +0000 (GMT)
In-reply-to: <20081124182132.GF8462@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

looks even more strange, IMHO. do I understand correct that two processes
doing allocation in the same group can do two initializations? what if one
process just allocated block(s) and not cleared UNINIT bit yet?

thanks, Alex



Aneesh Kumar K.V wrote:
> On Mon, Nov 24, 2008 at 09:17:53PM +0300, Alex Zhuravlev wrote:
>> Aneesh Kumar K.V wrote:
>>> With commit c806e68f we do a init_bitmap every time we do a
>>> read_block_bitmap.
>> can you explain why do we need to init it every time?
>>
> 
> The commit message  explains it well. It is because the buffer_head
> can be marked uptodate by a read from userspace. So we would skip doing
> a init_bitmap on the uninit group during resize.
> 
> commit c806e68f5647109350ec546fee5b526962970fd2
> Author: Frederic Bohe <frederic.bohe@bull.net>
> Date:   Fri Oct 10 08:09:18 2008 -0400
> 
>     ext4: fix initialization of UNINIT bitmap blocks
>     
>     This fixes a bug which caused on-line resizing of filesystems with a
>     1k blocksize to fail.  The root cause of this bug was the fact that if
>     an uninitalized bitmap block gets read in by userspace (which
>     e2fsprogs does try to avoid, but can happen when the blocksize is less
>     than the pagesize and an adjacent blocks is read into memory)
>     ext4_read_block_bitmap() was erroneously depending on the buffer
>     uptodate flag to decide whether it needed to initialize the bitmap
>     block in memory --- i.e., to set the standard set of blocks in use by
>     a block group (superblock, bitmaps, inode table, etc.).  Essentially,
>     ext4_read_block_bitmap() assumed it was the only routine that might
>     try to read a block containing a block bitmap, which is simply not
>     true.
>     
>     To fix this, ext4_read_block_bitmap() and ext4_read_inode_bitmap()
>     must always initialize uninitialized bitmap blocks.  Once a block or
>     inode is allocated out of that bitmap, it will be marked as
>     initialized in the block group descriptor, so in general this won't
>     result any extra unnecessary work.
>     
>     Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 59566c0..bd2ece2 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -319,9 +319,11 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
>  			    block_group, bitmap_blk);
>  		return NULL;
>  	}
> -	if (bh_uptodate_or_lock(bh))
> +	if (buffer_uptodate(bh) &&
> +	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
>  		return bh;
>  
> +	lock_buffer(bh);
>  	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
>  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
>  		ext4_init_block_bitmap(sb, bh, block_group, desc);
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 1343bf1..fe34d74 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -115,9 +115,11 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
>  			    block_group, bitmap_blk);
>  		return NULL;
>  	}
> -	if (bh_uptodate_or_lock(bh))
> +	if (buffer_uptodate(bh) &&
> +	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
>  		return bh;
>  
> +	lock_buffer(bh);
>  	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
>  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
>  		ext4_init_inode_bitmap(sb, bh, block_group, desc);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 335faee..b580714 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -782,9 +782,11 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
>  		if (bh[i] == NULL)
>  			goto out;
>  
> -		if (bh_uptodate_or_lock(bh[i]))
> +		if (buffer_uptodate(bh[i]) &&
> +		    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
>  			continue;
>  
> +		lock_buffer(bh[i]);
>  		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
>  		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
>  			ext4_init_block_bitmap(sb, bh[i],


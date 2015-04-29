From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on
 small fs
Date: Wed, 29 Apr 2015 14:50:52 -0500
Message-ID: <5541361C.4070406@redhat.com>
References: <1427280382-31120-1-git-send-email-lczerner@redhat.com> <553ABAF0.2020702@redhat.com> <D2BC34F2-AB5D-4923-A2D6-28CEC2807C9A@dilger.ca> <20150427161451.GA22448@quack.suse.cz> <553E6277.3040800@redhat.com> <20150428122102.GA9955@quack.suse.cz> <alpine.LFD.2.00.1504281423330.2386@localhost.localdomain> <553FAB44.9050009@redhat.com> <20150429101025.GB32439@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbbD2Tu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2015 15:50:59 -0400
In-Reply-To: <20150429101025.GB32439@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/29/15 5:10 AM, Jan Kara wrote:
> On Tue 28-04-15 10:46:12, Eric Sandeen wrote:

...

>> Maybe we can do something similar here?  I've kind of lost track
>> of how resize is working now, TBH.
>   Well, the fact is we have to limit some fs parameters so that code can be
> reasonably simple. IMO already supporting 20 MB filesystem with a journal
> is a stretch and choice of number of reserved blocks looks arbitrary but
> I guess we shouldn't regress if possible.
> 
> So 20 MB filesystem will get 1 MB journal. That means
> j_max_transaction_size 256 and thus we allow at most 128 credits in a single
> handle. The filesystem has 79 reserved GDT blocks and flex group size 16 so
> when resizing to 200 MB when adding full flex group, the resize code in
> ext4_flex_group_add() wants a handle with 4*16 + 79 credits which is too
> much (143).

*nod*

> That being said the calculation in ext4_flex_group_add() looks too
> pessimistic (in the flex_gd->count * 4 part). Sure we need to modify resize
> inode and its dindirect block but that's common for all the groups,
> similarly for superblock so we can change that to (3 + flex_gd->count) and
> even that is too pessimistic since we have EXT4_DESC_PER_BLOCK(sb)
> descriptors in one block. So we could shrink it to (3 + 1 + (flex_gd->count +
> EXT4_DESC_PER_BLOCK(sb) - 1) / EXT4_DESC_PER_BLOCK(sb)). That will shrink
> the total credit estimate down to 84 for that filesystem.
> 
> The attached patch fixes the issue for me. Thoughts?
> 
> 								Honza

I think I'm glad you understand it better than me. :)  I was surprised at
the large reservation but hadn't worked out why it was a problem.


> From 37ecb96f1ab1e57bc5c1663c1662d658df2f84fd Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 29 Apr 2015 11:46:31 +0200
> Subject: [PATCH] ext4: Fix growing of tiny filesystems
> 
> The estimate of necessary transaction credits in ext4_flex_group_add()
> is too pessimistic. It reserves credit for sb, resize inode, and resize
> inode dindirect block for each group added in a flex group although they
> are always the same block and thus it is enough to account them only
> once. Also the number of modified GDT block is overestimated since we
> fit EXT4_DESC_PER_BLOCK(sb) descriptors in one block.
> 
> Make the estimation more precise. That reduces number of requested
> credits enough that we can grow 20 MB filesystem (which has 1 MB
> journal, 79 reserved GDT blocks, and flex group size 16 by default).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/resize.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 8a8ec6293b19..15b4b3605859 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1432,12 +1432,15 @@ static int ext4_flex_group_add(struct super_block *sb,
>  		goto exit;
>  	/*
>  	 * We will always be modifying at least the superblock and  GDT
> -	 * block.  If we are adding a group past the last current GDT block,
> +	 * blocks.  If we are adding a group past the last current GDT block,
>  	 * we will also modify the inode and the dindirect block.  If we
>  	 * are adding a group with superblock/GDT backups  we will also
>  	 * modify each of the reserved GDT dindirect blocks.
>  	 */
> -	credit = flex_gd->count * 4 + reserved_gdb;
> +	credit = 3;	/* sb, resize inode, resize inode dindirect */

yay for excellent comments :)

> +	credit += 1 + (flex_gd->count + EXT4_DESC_PER_BLOCK(sb) - 1) /
> +			EXT4_DESC_PER_BLOCK(sb);	/* GDT blocks */

maybe credit += 1 + DIV_ROUND_UP(flex_gd->count, EXT4_DESC_PER_BLOCK(sb)) ?

> +	credit += reserved_gdb;	/* Reserved GDT dindirect blocks */
>  	handle = ext4_journal_start_sb(sb, EXT4_HT_RESIZE, credit);
>  	if (IS_ERR(handle)) {
>  		err = PTR_ERR(handle);

Thanks!
-Eric


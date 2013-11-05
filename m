From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG][ext2] XIP does not work on ext2
Date: Tue, 5 Nov 2013 01:37:33 +0100
Message-ID: <20131105003733.GA24531@quack.suse.cz>
References: <CAOvWMLZ-ezykR6TkFAoZ1UW20QF6XMOKeZH8R-FdFJkXjAP9nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andiry Xu <andiry.xu@gmail.com>
To: Andiry Xu <andiry@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOvWMLZ-ezykR6TkFAoZ1UW20QF6XMOKeZH8R-FdFJkXjAP9nA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Mon 04-11-13 14:31:34, Andiry Xu wrote:
> When I'm trying XIP on ext2, I find that xip does not work on ext2
> with latest kernel.
> 
> Reproduce steps:
> Compile kernel with following configs:
> CONFIG_BLK_DEV_XIP=y
> CONFIG_EXT2_FS_XIP=y
> 
> And run following commands:
> # mke2fs -b 4096 /dev/ram0
> # mount -t ext2 -o xip /dev/ram0 /mnt/ramdisk/
> # dd if=/dev/zero of=/mnt/ramdisk/test1 bs=1M count=16
> 
> And it shows:
> dd: writing `/mnt/ramdisk/test1': No space left on device
> 
> df also shows /mnt/ramdisk is 100% full. Its default size is 64MB so a
> 16MB write should only occupy 1/4 capacity.
> 
> Criminal commit:
> After git bisect, it points to the following commit:
> 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b
> Ext2: mark inode dirty after the function dquot_free_block_nodirty is called
  Thanks for report and the bisection!

> Particularly, the following code:
> @@ -1412,9 +1415,11 @@ allocated:
> *errp = 0;
> brelse(bitmap_bh);
> -    dquot_free_block_nodirty(inode, *count-num);
> -    mark_inode_dirty(inode);
> -    *count = num;
> +    if (num < *count) {
> +        dquot_free_block_nodirty(inode, *count-num);
> +        mark_inode_dirty(inode);
> +        *count = num;
> +    }
>       return ret_block;
> 
> Not mark_inode_dirty() is called only when num is less than *count.
> However, I've seen
> with the dd command, there is case where num >= *count.
> 
> Fix:
> I've verified that the following patch fixes the issue:
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 9f9992b..5446a52 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -1406,11 +1406,10 @@ allocated:
> 
>         *errp = 0;
>         brelse(bitmap_bh);
> -       if (num < *count) {
> +       if (num <= *count)
>                 dquot_free_block_nodirty(inode, *count-num);
> -               mark_inode_dirty(inode);
> -               *count = num;
> -       }
> +       mark_inode_dirty(inode);
> +       *count = num;
>         return ret_block;
> 
>  io_error:
> 
> However, I'm not familiar with ext2 source code and cannot tell if
> this is the correct fix. At least it fixes my issue.
  With this, you have essentially reverted a hunk from commit 
8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b. But I don't see a reason why it
should be reverted. num should never ever be greater than *count and when
num == count, we the code inside if doesn't do anything useful.

I've looked into the code and I think I see the problem. It is a long
standing bug in __ext2_get_block() in fs/ext2/xip.c. It calls
ext2_get_block() asking for 0 blocks to map (while we really want 1 block).
ext2_get_block() just passes that request and ext2_get_blocks() actually
allocates 1 block. And that's were the commit you have identified makes a
difference because previously we returned that 1 block was allocated while
now we return that 0 blocks were allocated and thus allocation is repeated
until all free blocks are exhaused.

Attached patch should fix the problem.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--lrZ03NoBR/3+SXJZ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext2-Fix-fs-corruption-in-ext2_get_xip_mem.patch"

>From ce14b6595c9f23db4a3fbeccd921f0687c9c73d4 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 5 Nov 2013 01:15:38 +0100
Subject: [PATCH] ext2: Fix fs corruption in ext2_get_xip_mem()

Commit 8e3dffc651cb "Ext2: mark inode dirty after the function
dquot_free_block_nodirty is called" unveiled a bug in __ext2_get_block()
called from ext2_get_xip_mem(). That function called ext2_get_block()
mistakenly asking it to map 0 blocks while 1 was intended. Before the
above mentioned commit things worked out fine by luck but after that commit
we started returning that we allocated 0 blocks while we in fact
allocated 1 block and thus allocation was looping until all blocks in
the filesystem were exhausted.

Fix the problem by properly asking for one block and also add assertion
in ext2_get_blocks() to catch similar problems.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 2 ++
 fs/ext2/xip.c   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index c260de6d7b6d..8a337640a46a 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -632,6 +632,8 @@ static int ext2_get_blocks(struct inode *inode,
 	int count = 0;
 	ext2_fsblk_t first_block = 0;
 
+	BUG_ON(maxblocks == 0);
+
 	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
 	if (depth == 0)
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
index 1c3312858fcf..e98171a11cfe 100644
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -35,6 +35,7 @@ __ext2_get_block(struct inode *inode, pgoff_t pgoff, int create,
 	int rc;
 
 	memset(&tmp, 0, sizeof(struct buffer_head));
+	tmp.b_size = 1 << inode->i_blkbits;
 	rc = ext2_get_block(inode, pgoff, &tmp, create);
 	*result = tmp.b_blocknr;
 
-- 
1.8.1.4


--lrZ03NoBR/3+SXJZ--

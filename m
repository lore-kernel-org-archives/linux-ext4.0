From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch for 2.6.25 queue
Date: Sat, 26 Jan 2008 12:03:31 -0500
Message-ID: <20080126170331.GB13231@mit.edu>
References: <20080126113849.GA18602@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Y Tso <theotso@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49858 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101AbYAZRDi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 12:03:38 -0500
Content-Disposition: inline
In-Reply-To: <20080126113849.GA18602@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 26, 2008 at 05:08:49PM +0530, Aneesh Kumar K.V wrote:
> This diff contain mballoc fixes and update for ext3-4 migrate patch.

I will fold these patches into the patch queue in the proper places
(and adjust other patches as necessary).

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a60672c..9de0cdf 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4452,7 +4452,6 @@ do_more:
>  		overflow = bit + count - EXT4_BLOCKS_PER_GROUP(sb);
>  		count -= overflow;
>  	}
> -	put_bh(bitmap_bh);
>  	bitmap_bh = read_block_bitmap(sb, block_group);
>  	if (!bitmap_bh)
>  		goto error_return;

This patch hunk causes a failure due to a botched brelse->put_bh
conversion, but removing it isn't the right fix.  It was there to
avoid a buffer leak on a goto.  So the right fix is to remove the
put_bh() above, but to add one here, circa line 4542 of mballoc.c:

	if (overflow && !err) {
		block += count;
		count = overflow;
+		put_bh(bitmap_bh);
		goto do_more;
	}

And once we do that, we can drop the initialization of bitmap_bh to
NULL, circa line 4408:

			int metadata, unsigned long *freed)
{
-	struct buffer_head *bitmap_bh = NULL;
+	struct buffer_head *bitmap_bh;
	struct super_block *sb = inode->i_sb;
	struct ext4_allocation_context ac;


						- Ted

From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Far too long mount time
Date: Fri, 17 Aug 2012 09:58:33 -0600
Message-ID: <6A01F211-3B92-4EFC-ABF5-2390044DF311@dilger.ca>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com> <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com> <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca> <1345126608.22142.59.camel@cwalton-XPS-8300> <20120816144219.GB29410@thunk.org> <20120816185337.GB31346@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	Andreas Dilger <adilger@dilger.ca>,
	Javier Marcet <jmarcet@gmail.com>,
	Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	"jpiszcz@lucidpixels.com" <jpiszcz@lucidpixels.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail119c7-2520.megamailservers.com ([69.49.98.26]:42742 "EHLO
	mail119c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751983Ab2HQP6o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 11:58:44 -0400
In-Reply-To: <20120816185337.GB31346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-16, at 12:53, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 16, 2012 at 10:42:19AM -0400, Theodore Ts'o wrote:
>> On Thu, Aug 16, 2012 at 10:16:48AM -0400, Calvin Walton wrote:
>>> On Thu, 2012-08-16 at 03:09 -0600, Andreas Dilger wrote:
>>> Is there any fix for this issue queued up for an upcoming stable
>>> release? It still reverts cleanly on 3.5.2.
>> 
>> There isn't a fix queued up yet, but there will be one soon....
> 
> This patch should solve the problem (as an alternative to reverting
> 8aeb00ff85a).

Why not save the newly calculated value for s_oberhead_blocks to disk after the first time it is calculated?  The only time it would need to be changed again is after a resize operation, which could be done by calling count_overhead() at the end again. 

Cheers, Andreas

> From dc43c7a8a6c266c31aa4f0408000c4d1b9f3c787 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Thu, 16 Aug 2012 11:59:04 -0400
> Subject: [PATCH] ext4: fix long mount times on very big file systems
> 
> Commit 8aeb00ff85a: "ext4: fix overhead calculation used by
> ext4_statfs()" introduced a O(n**2) calculation which makes very large
> file systems take forever to mount.  Fix this with an optimization for
> non-bigalloc file systems.  (For bigalloc file systems the overhead
> needs to be set in the the superblock.)
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
> fs/ext4/super.c | 4 ++++
> 1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 603023b..055c65b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3129,6 +3129,10 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
>    ext4_group_t        i, ngroups = ext4_get_groups_count(sb);
>    int            s, j, count = 0;
> 
> +    if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC))
> +        return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, i) +
> +            sbi->s_itb_per_group + 2);
> +
>    first_block = le32_to_cpu(sbi->s_es->s_first_data_block) +
>        (grp * EXT4_BLOCKS_PER_GROUP(sb));
>    last_block = first_block + EXT4_BLOCKS_PER_GROUP(sb) - 1;
> -- 
> 1.7.12.rc0.22.gcdd159b
> 

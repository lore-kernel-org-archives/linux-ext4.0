From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC 3/3] ext4: use the O_HOT and O_COLD open flags to
 influence inode allocation
Date: Fri, 20 Apr 2012 09:27:57 +1000
Message-ID: <20120419232757.GC9541@dastard>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
 <1334863211-19504-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:47283 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866Ab2DSX2R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 19:28:17 -0400
Content-Disposition: inline
In-Reply-To: <1334863211-19504-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 19, 2012 at 03:20:11PM -0400, Theodore Ts'o wrote:
> Wire up the use of the O_HOT and O_COLD open flags so that when an
> inode is being created, it can influence which part of the disk gets
> used on rotational storage devices.
.....
> @@ -508,13 +508,20 @@ fallback_retry:
>  }
>  
>  static int find_group_other(struct super_block *sb, struct inode *parent,
> -			    ext4_group_t *group, umode_t mode)
> +			    ext4_group_t *group, umode_t mode, int flags)
>  {
>  	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
>  	ext4_group_t i, last, ngroups = ext4_get_groups_count(sb);
>  	struct ext4_group_desc *desc;
>  	int flex_size = ext4_flex_bg_size(EXT4_SB(sb));
>  
> +	if ((flags & EXT4_NEWI_HOT) && (ngroups > 3) &&
> +	    (parent_group > ngroups / 3))
> +		parent_group = 0;
> +	if ((flags & EXT4_NEWI_COLD) && (ngroups > 3) &&
> +	    (parent_group < (2 * (ngroups / 3))))
> +		parent_group = 2 * (ngroups / 3);
> +

So you're assuming that locating the inodes somewhere "hot" is going
to improve performance. So say an application has a "hot" file (say
an index file) but still has a lot of other files it creates and
reads, and they are all in the same directory.

If the index file is created "hot", then it is going to be placed a
long way away from all the other files that applciation is using,
and every time you access the hot file you now seek away to a
different location on disk. The net result: the application goes
slower because average seek times have increased.

Essentially, an application is going to have to claim all files it
is working on at any point in time are either hot, normal or cold,
otherwise it is going to seek between hot, normal and cold regions
all the time. That's going to increase average seek times compared
to having all the files in the same general location, hot, cold or
otherwise.

Note: I'm not saying that O_HOT/O_COLD is a bad idea, just that it's
going to be had to implement in a way that behaves consistently in a
way that users would expect - i.e. improves performance.  IMO,
unless you have tiered storage and knowledge of the underlying block
device characteristics, then HOT/COLD are going to be very difficult
to implement sanely....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

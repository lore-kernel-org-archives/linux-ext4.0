From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 2/6] ext4: track extent status tree shrinker delay
 statictics
Date: Wed, 27 Aug 2014 15:26:07 +0200
Message-ID: <20140827132607.GA22211@quack.suse.cz>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933592AbaH0N0R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2014 09:26:17 -0400
Content-Disposition: inline
In-Reply-To: <1407382553-24256-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-08-14 11:35:49, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit adds some statictics in extent status tree shrinker.  The
> purpose to add these is that we want to collect more details when we
> encounter a stall caused by extent status tree shrinker.  Here we count
> the following statictics:
>   stats:
>     the number of all objects on all extent status trees
>     the number of reclaimable objects on lru list
>     cache hits/misses
>     the last sorted interval
>     the number of inodes on lru list
>   average:
>     scan time for shrinking some objects
>     the number of shrunk objects
>   maximum:
>     the inode that has max nr. of objects on lru list
>     the maximum scan time for shrinking some objects
> 
> The output looks like below:
>   $ cat /proc/fs/ext4/sda1/es_shrinker_info
>   stats:
>     28228 objects
>     6341 reclaimable objects
>     5281/631 cache hits/misses
>     586 ms last sorted interval
>     250 inodes on lru list
>   average:
>     153 us scan time
>     128 shrunk objects
>   maximum:
>     255 inode (255 objects, 198 reclaimable)
>     125723 us max scan time
  When reading through this again, I realized that we probably don't want
this file in /proc/fs/ext4 but rather in /sys/kernel/debug/ext4 because
it's really a debugging interface and we don't want any tools to start
using it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

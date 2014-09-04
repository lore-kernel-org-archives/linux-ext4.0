From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v3 2/6] ext4: track extent status tree shrinker delay
 statictics
Date: Thu, 4 Sep 2014 20:10:48 +0800
Message-ID: <20140904121048.GA13193@gmail.com>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-3-git-send-email-wenqing.lz@taobao.com>
 <20140827132607.GA22211@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36974 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaIDMBc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Sep 2014 08:01:32 -0400
Received: by mail-pa0-f41.google.com with SMTP id lj1so19820315pab.28
        for <linux-ext4@vger.kernel.org>; Thu, 04 Sep 2014 05:01:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140827132607.GA22211@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2014 at 03:26:07PM +0200, Jan Kara wrote:
> On Thu 07-08-14 11:35:49, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > This commit adds some statictics in extent status tree shrinker.  The
> > purpose to add these is that we want to collect more details when we
> > encounter a stall caused by extent status tree shrinker.  Here we count
> > the following statictics:
> >   stats:
> >     the number of all objects on all extent status trees
> >     the number of reclaimable objects on lru list
> >     cache hits/misses
> >     the last sorted interval
> >     the number of inodes on lru list
> >   average:
> >     scan time for shrinking some objects
> >     the number of shrunk objects
> >   maximum:
> >     the inode that has max nr. of objects on lru list
> >     the maximum scan time for shrinking some objects
> > 
> > The output looks like below:
> >   $ cat /proc/fs/ext4/sda1/es_shrinker_info
> >   stats:
> >     28228 objects
> >     6341 reclaimable objects
> >     5281/631 cache hits/misses
> >     586 ms last sorted interval
> >     250 inodes on lru list
> >   average:
> >     153 us scan time
> >     128 shrunk objects
> >   maximum:
> >     255 inode (255 objects, 198 reclaimable)
> >     125723 us max scan time
>   When reading through this again, I realized that we probably don't want
> this file in /proc/fs/ext4 but rather in /sys/kernel/debug/ext4 because
> it's really a debugging interface and we don't want any tools to start
> using it.

Fair enough.  I will fix it in next version.

Thanks,
                                                - Zheng

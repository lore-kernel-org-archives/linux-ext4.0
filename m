From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: strange ext{3,4}_settattr logic
Date: Mon, 17 Mar 2008 09:24:15 +0100
Message-ID: <20080317082414.GA17940@kernel.dk>
References: <20080315160731.GA4186@dmon-lap.sw.ru> <20080315230544.GV3542@webber.adilger.int> <20080315235427.GA26939@webber.adilger.int> <20080316002300.GB26939@webber.adilger.int> <20080316113912.GA3118@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:8038 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYCQIYS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 04:24:18 -0400
Content-Disposition: inline
In-Reply-To: <20080316113912.GA3118@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16 2008, Dmitri Monakhov wrote:
> I've added Jens because he may be also interesting in this topic.
> On 08:23 Sun 16 Mar     , Andreas Dilger wrote:
> > On Mar 16, 2008  07:54 +0800, Andreas Dilger wrote:
> > > A call to  inode_setattr() can fail by trying a shrinking vmtruncate()
> > > on a swapfile, which returns ETXTBUSY.  This was added after the
> > > ext3_setattr() code was written.
> > > 
> > > We need to handle the IS_SWAPFILE() case properly.
> > > Granted, it probably isn't a very common problem, but the IS_SWAPFILE()
> > > check was added explicitly because of clueless users, so it must be hit
> > > occasionally in real life.
> > > 
> > > It would seem that if you have a swapfile, try to truncate it to 0 (which
> > > will fail with -ETXTBUSY) and then unmount the filesystem the size will
> > > be truncated to 0.  It is also possible to directly write to a swapfile
> > > and corrupt memory, or read from a swapfile and access potentially sensitive
> > > information.
> In fact i've triggered this issue while working on fast_loop device
> implementation which was proposed by Jens (http://lkml.org/lkml/2008/1/9/50).
> In fast_loop device use swapfile approach (submitting bio-s directly to
> underlying block device). I think this idea will be included in mainstream
> loop device sooner or later. But approach has several issues:
> One of the most important is effective control mechanism over truncates for
> lower file,  this issue was missed in Jens patch set.
> This mechanism probably have to have following options.
> #1: Shrink truncates must be denied.
> #2: Expand truncates may be allowed. This is good because most of non plain 
> disk image formats (qcow, vmdk, and etc) are growing while adding new data
> blocks.
> #3: Allow exclusive owner for file, for example only one user(loop_thread in
> this case) may truncate file. Provide something similar to bd_claim feature.
> without this feature on-line shrinking of disk image looks like this:
> 
>  mutex_lock(&inode->i_mutex);
>  inode->i_flags &= ~S_SWAPFILE;
>  mutex_unlock(&inode->i_mutex);
> 
>  /* Perform shrinking truncate. This is absolutely racy operation because
>   * some one else also may perform truncate at this time*/
>  do_truncate(inode, size); 
> 
>  mutex_lock(&inode->i_mutex);
>  inode->i_flags |= S_SWAPFILE;
>  mutex_unlock(&inode->i_mutex);
> 
> 
> S_SWAPFILE inode option currently equals to #1, and #2. What's why i want
> use this flag for fast_loop devices.

Neat, I didn't consider that. Mainly because I had (knowingly) ignored
the exclusive owner bit so far. I have included your suggestion in the
loop-fastfs and loop-extent_map branches, thanks.

-- 
Jens Axboe


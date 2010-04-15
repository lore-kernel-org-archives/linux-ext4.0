From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/4 v3] ext3/4: enhance fsync performance when using CFQ
Date: Thu, 15 Apr 2010 16:03:49 +0200
Message-ID: <20100415140348.GB27497@kernel.dk>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com> <20100415103345.GY27497@kernel.dk> <x498w8oj276.fsf@segfault.boston.devel.redhat.com> <20100415130854.GA27497@kernel.dk> <x494ojcj1tc.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	vgoyal@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38709 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab0DOODu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 10:03:50 -0400
Content-Disposition: inline
In-Reply-To: <x494ojcj1tc.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 15 2010, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> >> > This is starting to look better. Can you share what tests you did? I
> >> > tried reproducing with fs_mark last time and could not.
> >> 
> >> Did you use the fs_mark command line I (think I) had posted?  What
> >> storage were you using?
> >
> > No, I didn't see any references to example command lines. I tested on a
> > few single disks, rotating and SSD. I expected the single spinning disk
> > to show the problem to some extent at least, but there was no difference
> > observed with 64kb blocks.
> 
> Boy, I'm really slipping.  Try this one:
> 
> ./fs_mark -S 1 -D 100 -N 1000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096

Thanks Jeff, I'll give it a spin :-)

-- 
Jens Axboe


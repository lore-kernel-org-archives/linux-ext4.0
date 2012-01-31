From: Jan Kara <jack@suse.cz>
Subject: Re: 3.2 and 3.1 filesystem scalability measurements
Date: Tue, 31 Jan 2012 11:53:53 +0100
Message-ID: <20120131105353.GA1278@quack.suse.cz>
References: <4F261807.2060108@hp.com>
 <4F26B395.6020607@gmail.com>
 <EC79BE65-4CC7-473F-A5EF-193425F62178@dilger.ca>
 <20120131001415.GC9090@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"aziro.linux.adm" <aziro.linux.adm@gmail.com>,
	Eric Whitney <eric.whitney@hp.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab2AaKx5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jan 2012 05:53:57 -0500
Content-Disposition: inline
In-Reply-To: <20120131001415.GC9090@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 31-01-12 11:14:15, Dave Chinner wrote:
> I also found this oddity on both XFS and ext4:
> 
>     flush-253:32-3400  [001] 1936151.384563: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-898403 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
>     flush-253:32-3400  [005] 1936151.455845: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-911663 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
>     flush-253:32-3400  [006] 1936151.596298: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-931332 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
>     flush-253:32-3400  [006] 1936151.719074: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-951001 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> 
> That's indicating the work->nr_pages is starting extremely negative,
> which should not be the case. The highest I saw was around -2m.
> Something is not working right there, as writeback is supposed to
> terminate if work->nr_pages < 0....
  Ugh, what kernel is this? The tracepoint is just a couple of lines after
                if (work->nr_pages <= 0)
                        break;
  so I really don't see how that could happen.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

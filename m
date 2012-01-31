From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.2 and 3.1 filesystem scalability measurements
Date: Wed, 1 Feb 2012 07:27:57 +1100
Message-ID: <20120131202757.GK9090@dastard>
References: <4F261807.2060108@hp.com>
 <4F26B395.6020607@gmail.com>
 <EC79BE65-4CC7-473F-A5EF-193425F62178@dilger.ca>
 <20120131001415.GC9090@dastard>
 <20120131105353.GA1278@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"aziro.linux.adm" <aziro.linux.adm@gmail.com>,
	Eric Whitney <eric.whitney@hp.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120131105353.GA1278@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 31, 2012 at 11:53:53AM +0100, Jan Kara wrote:
> On Tue 31-01-12 11:14:15, Dave Chinner wrote:
> > I also found this oddity on both XFS and ext4:
> > 
> >     flush-253:32-3400  [001] 1936151.384563: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-898403 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> >     flush-253:32-3400  [005] 1936151.455845: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-911663 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> >     flush-253:32-3400  [006] 1936151.596298: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-931332 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> >     flush-253:32-3400  [006] 1936151.719074: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-951001 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> > 
> > That's indicating the work->nr_pages is starting extremely negative,
> > which should not be the case. The highest I saw was around -2m.
> > Something is not working right there, as writeback is supposed to
> > terminate if work->nr_pages < 0....
>   Ugh, what kernel is this? The tracepoint is just a couple of lines after
>                 if (work->nr_pages <= 0)
>                         break;
>   so I really don't see how that could happen.

Neither can I - it is the latest Linus kernel (3.3-rc1+).

I even upgraded trace-cmd to the latest in case that was the
problem, but it didn't make any difference. I haven't worked it out
yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

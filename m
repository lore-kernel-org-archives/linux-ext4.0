From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: working on extent locks for i_mutex
Date: Fri, 20 Jan 2012 10:26:49 +0800
Message-ID: <20120120022649.GA12463@gmail.com>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
 <20120113043411.GH2806@dastard>
 <4F10992C.3070303@linux.vnet.ibm.com>
 <20120115235747.GA6922@dastard>
 <4F146275.8090304@linux.vnet.ibm.com>
 <20120118120223.GA4322@gmail.com>
 <1327007770.5899.66.camel@peace.lax.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Tao Ma <tm@tao.ma>, xfs@oss.sgi.com
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36568 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2ATCW7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2012 21:22:59 -0500
Received: by iagf6 with SMTP id f6so175942iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jan 2012 18:22:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1327007770.5899.66.camel@peace.lax.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 19, 2012 at 01:16:10PM -0800, Frank Mayhar wrote:
> On Wed, 2012-01-18 at 20:02 +0800, Zheng Liu wrote:
> > For this project, do you have a schedule? Would you like to share to me? This
> > lock contention heavily impacts the performance of direct IO in our production
> > environment. So we hope to improve it ASAP.
> > 
> > I have done some direct IO benchmarks to compare ext4 with xfs using fio
> > in Intel SSD. The result shows that, in direct IO, xfs outperforms ext4 and
> > ext4 with dioread_nolock.
> > 
> > To understand the effect of lock contention, I define a new function called 
> > ext4_file_aio_write() that calls __generic_file_aio_write() without acquiring 
> > i_mutex lock. Meanwhile, I remove DIO_LOCKING flag when __blockdev_direct_IO() 
> > is called and do the similar benchmarks. The result shows that the performance 
> > in ext4 is almost the same to the xfs. Thus, it proves that the i_mutex heavily
> > impacts the performance. Hopefully the result is useful for you. :-)
> 
> For the record, I have a patchset that, while not affecting i_mutex (or
> locking in general), does allow AIO append writes to actually be done
> asynchronously.  (Currently they're forced to be done synchronously.)
> It makes a big difference in performance for that particular case, even
> for spinning media.  Performance roughly doubled when testing with fio
> against a regular two-terabyte drive; the performance improvement
> against SSD would have to be much greater.
> 
> One day soon I'll accumulate enough spare time to port the patchset
> forward to the latest kernel and submit it here.
Interesting. I think it might help us to improve this issue. So could
you please post your test case and result in detail? Thank you. :-)

Regards,
Zheng

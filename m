From: Frank Mayhar <fmayhar@google.com>
Subject: Re: working on extent locks for i_mutex
Date: Thu, 19 Jan 2012 13:16:10 -0800
Message-ID: <1327007770.5899.66.camel@peace.lax.corp.google.com>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
	 <20120113043411.GH2806@dastard> <4F10992C.3070303@linux.vnet.ibm.com>
	 <20120115235747.GA6922@dastard> <4F146275.8090304@linux.vnet.ibm.com>
	 <20120118120223.GA4322@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Tao Ma <tm@tao.ma>, xfs@oss.sgi.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46074 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2ASVQO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2012 16:16:14 -0500
Received: by ggnb1 with SMTP id b1so289319ggn.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jan 2012 13:16:13 -0800 (PST)
In-Reply-To: <20120118120223.GA4322@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2012-01-18 at 20:02 +0800, Zheng Liu wrote:
> For this project, do you have a schedule? Would you like to share to me? This
> lock contention heavily impacts the performance of direct IO in our production
> environment. So we hope to improve it ASAP.
> 
> I have done some direct IO benchmarks to compare ext4 with xfs using fio
> in Intel SSD. The result shows that, in direct IO, xfs outperforms ext4 and
> ext4 with dioread_nolock.
> 
> To understand the effect of lock contention, I define a new function called 
> ext4_file_aio_write() that calls __generic_file_aio_write() without acquiring 
> i_mutex lock. Meanwhile, I remove DIO_LOCKING flag when __blockdev_direct_IO() 
> is called and do the similar benchmarks. The result shows that the performance 
> in ext4 is almost the same to the xfs. Thus, it proves that the i_mutex heavily
> impacts the performance. Hopefully the result is useful for you. :-)

For the record, I have a patchset that, while not affecting i_mutex (or
locking in general), does allow AIO append writes to actually be done
asynchronously.  (Currently they're forced to be done synchronously.)
It makes a big difference in performance for that particular case, even
for spinning media.  Performance roughly doubled when testing with fio
against a regular two-terabyte drive; the performance improvement
against SSD would have to be much greater.

One day soon I'll accumulate enough spare time to port the patchset
forward to the latest kernel and submit it here.
-- 
Frank Mayhar
fmayhar@google.com


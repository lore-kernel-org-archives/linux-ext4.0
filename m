From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 21:33:45 -0400
Message-ID: <20110603013345.GD27129@redhat.com>
References: <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
 <20110603002714.GA27129@redhat.com>
 <20110603004300.GE16306@thunk.org>
 <20110603005403.GB27129@redhat.com>
 <20110603010233.GA17726@infradead.org>
 <20110603012858.GC27129@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab1FCBd7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 21:33:59 -0400
Content-Disposition: inline
In-Reply-To: <20110603012858.GC27129@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 09:28:58PM -0400, Vivek Goyal wrote:
> On Thu, Jun 02, 2011 at 09:02:33PM -0400, Christoph Hellwig wrote:
> > On Thu, Jun 02, 2011 at 08:54:03PM -0400, Vivek Goyal wrote:
> > > Just wondering why ext4 and XFS behavior are different and which is a
> > > more appropriate behavior. ext4 does not seem to be waiting for all
> > > pending AIO/DIO to finish while XFS does.
> > 
> > They're both wrong.  Ext4 completely misses support in fsync or sync
> > to catch pending unwrittent extent conversions, and thus fails to obey
> > the data integrity guarante.  XFS is beeing rather stupid about the
> > amount of synchronization it requires.  The untested patch below
> > should help with avoiding the synchronization if you're purely doing
> > overwrites:
> 
> Yes this patch helps. I have already laid out the file and doing
> overwrites.
> 
> I throttled aio-stress in one cgroup to 1 byte/sec and edited another
> file from other cgroup and did a "sync" and it completed.

Even other test where I am running aio-stress in one window and edited
a file in another window and typed "sync" worked. "sync" does not hang
waiting for aio-stress to finish.

Thanks
Vivek

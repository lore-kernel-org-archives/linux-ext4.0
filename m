From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: Re: ICP, 3ware,  Areca?
Date: Tue, 7 Nov 2006 13:45:13 -0800
Message-ID: <20061107134513.fbd5f219.akpm@osdl.org>
References: <20061107114724.9c2cc644.akpm@osdl.org>
	<1162933193.8123.36.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19162 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1753447AbWKGVpT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Nov 2006 16:45:19 -0500
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <1162933193.8123.36.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 07 Nov 2006 14:59:52 -0600
Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Tue, 2006-11-07 at 11:47 -0800, Andrew Morton wrote:
> > Why is ext3 slow??
> 
> Allocation?  I don't see anything indicating that Bill is overwriting an
> existing file, so there is block allocation and journaling overhead.  If
> that's the case, it would be interesting to see how fast ext3 is when
> overwriting a file.  Extents and delayed allocation should improve on
> this a lot.  

Maybe.  or perhaps some funniness with RAID aligment.

Bill, if you have time it'd be interesting to repeat the comparative
benchmarking with:

ext3, data=ordered:

	dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct
	time dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct conv=notrunc

ext4dev:

	dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct
	time dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct conv=notrunc

ext4dev, -oextents

	rm foo
	dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct
	time dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct conv=notrunc

> > Begin forwarded message:
> > 
> > Date: Tue, 7 Nov 2006 09:47:17 -0500
> > From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
> > To: Arne Schmitz <arne.schmitz@gmx.net>
> > Cc: linux-ide-arrays@lists.math.uh.edu
> > Subject: Re: ICP, 3ware,  Areca?
> > 
> > 
> > On Tue, Nov 07, 2006 at 03:25:04PM +0100, Arne Schmitz wrote:
> > > Has anyone information about how current ICP and Areca hardware performs under 
> > > Linux? We are currently running kernel 2.6.17 and have two offers, one with 
> > > an Areca ARC-1220 8-port, and one with an ICP 9087MA 8-port. Does either of 
> > > them make trouble running a (64 bit) Linux?
> > > 
> > > At the moment we only have two 3ware controllers running on 32 bit Linux.
> > 
> > On Fri, 18 Aug 2006, I wrote to the list:
> > 
> >    I've been doing sequential raw disk I/O testing with both Jens Axboe's
> >    "fio" using libaio and iodepths up to 32, as well as a basic
> >    "dd if=/dev/zero oflag=direct".
> > 
> >    Reads look fine; a zone read test shows 360 MiB/s at the start of the disk,
> >    190 MiB/s at the end.  I see similarly high numbers doing direct reads via
> >    ext3.
> 
> This would indicate that indirect block lookups themselves aren't a
> problem.
> 
> >    Summary:
> > 
> >    Raw partition: 228 MiB/s
> >    XFS:           228 MiB/s
> >    Ext3:      139-151 MiB/s

It's hard to believe that the block allocator could do this to us.  I'd be
suspecting that something is causing additional seeking.

Bill, when publishing figures like this it is useful (and somewhat
important) to also record the CPU consumption.  So please publish the full
output of /usr/bin/time and not just the elapsed time, thanks.

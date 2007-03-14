From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fw: Re: 2.6.21-rc3-mm1
Date: Tue, 13 Mar 2007 17:07:48 -0800
Message-ID: <20070313170748.3e0bb466.akpm@linux-foundation.org>
References: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>
	<45F6BDC9.8080205@redhat.com>
	<1173799745.9662.4.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	astralstorm@gmail.com, kalpak@clusterfs.com
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbXCNAIk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2007 20:08:40 -0400
In-Reply-To: <1173799745.9662.4.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Tue, 13 Mar 2007 10:29:05 -0500 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> On Tue, 2007-03-13 at 10:05 -0500, Eric Sandeen wrote:
> > Andrew Morton wrote:
> > 
> > > And broken stuff too :-)
> > > The nanoseconds patch is broken on x86_64 - makes mtimes from the future:
> > > e.g. year 2431. I suspect an endianness issue.
> > > x86 works fine according to my sources.
> > >
> > > The files themselves have correct mtimes, as booting previous kernel
> > > or one w/o the nanoseconds patch works fine.
> > There were later patches posted to the list after this version, I think, which
> > are not yet in Ted's tree... I'll find some time today to test the "take3" version
> > on x86_64, unless someone beats me to it.
> 
> I didn't quite beat you to it, but I did make a diff to bring
> 2.6.21-rc3-mm1 in tune with the "take3" patch.  It makes the code easier
> to understand, but I'm not sure if it contains anything to fix the bug.
> Code inspection hasn't gotten me any closer to figuring out what's
> wrong.
> 
> Shaggy

It's possible that I screwed up merging Ted's tree into mainline - it spat
some rejects, and needs updating to 2.6.21-rc3.

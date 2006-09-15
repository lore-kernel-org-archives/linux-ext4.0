From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: ext3 sequential read performance (~20%) degrade
Date: Fri, 15 Sep 2006 09:01:44 -0700
Message-ID: <1158336104.31501.2.camel@dyn9047017100.beaverton.ibm.com>
References: <1158276972.24991.10.camel@dyn9047017100.beaverton.ibm.com>
	 <20060914170308.9595141c.akpm@osdl.org> <20060915055005.GA12172@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, sct@redhat.com,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:45261 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932121AbWIOP6P
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 11:58:15 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8FFwEu9027747
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 11:58:14 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8FFwETI268190
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 09:58:14 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8FFwDuq001605
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 09:58:13 -0600
To: suparna@in.ibm.com
In-Reply-To: <20060915055005.GA12172@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-09-15 at 11:20 +0530, Suparna Bhattacharya wrote:
> On Thu, Sep 14, 2006 at 05:03:08PM -0700, Andrew Morton wrote:
> > On Thu, 14 Sep 2006 16:36:12 -0700
> > Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > 
> > > Hi Andrew,
> > > 
> > > I have been working on tracking down ~20% performance degrade for
> > > sequential read performance for ext3. 
> > 
> > oop.  I'd kinda prefer that we discover things like this before the patch
> > gets into mainline.
> > 
> > > Finally narrowed it down to get_blocks() support. If I force
> > > ext3_get_blocks_handle() to always return 1 block - I get better
> > > IO rate. I did all the usual stuff, tracked down requests, traced
> > > blocksizes, looked at readahead code, looked at mpage_readpages()
> > > etc.. I still can't figure out how to explain the degrade..
> > > 
> > > Any suggestions on how to track it down.
> > 
> > Learn to driver Jens's blktrace stuff, find out why the IO scheduling went
> > bad.
> > 
> > Number one suspicion: the buffer_boundary() stuff isn't working.
> 
> I think you are right about that  - perhaps something along
> the lines of the following patch (untested) would help ?

Yep. It works :)

Thanks,
Badari




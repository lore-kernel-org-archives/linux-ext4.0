From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: 2.6.23-rc9: Oops in cache_alloc_refill()  mm/slab.c
Date: Fri, 05 Oct 2007 13:30:52 -0700
Message-ID: <1191616252.3861.5.camel@localhost.localdomain>
References: <4705113A.7030908@bull.net>
	 <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>
	 <47063EF3.4050302@bull.net>
	 <1191596057.6106.106.camel@dyn9047017100.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59507 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760238AbXJEUbL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2007 16:31:11 -0400
In-Reply-To: <1191596057.6106.106.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-10-05 at 07:54 -0700, Badari Pulavarty wrote:
> On Fri, 2007-10-05 at 15:41 +0200, Valerie Clement wrote:
> > Badari Pulavarty wrote:
> > > On Thu, 2007-10-04 at 18:13 +0200, Valerie Clement wrote:
> > >> While running ffsb tests on my ext4 filesystem, I got an Oops in 
> > >> cache_alloc_refill().
> > >> I turned on SLAB debugging and here is the message I got:
> > >>
> > >> slab: Internal list corruption detected in cache 'buffer_head'(30), 
> > >> slabp ffff81007e100100(1515870810). Hexdump:
> > > 
> > > slabp->inuse = 1515870810 looks bogus. Is this easily reproducible ?
> > 
> > Hi Badari,
> > Thanks for your answer.
> > I didn't reproduce it without the latest ext4 patches. So I suspect a 
> > bug in one of them.
> > But how debugging this?
> > Which other debug traces can I turn on?
> 
> Let me understand. You applied latest ext4 patchsets ? If so, Mingming
> has some slab-cleanup changes in the patchset. You can try backing them
> out and see. 
> 

It's unlikely to be the jbd_slab_cleanup.patch, which actually get rid
of slab allocation for buffers passing down to disk IO, and replace with
get_free_page directly.

Could you send me the profile used for ffsb test?

Thanks,
Mingming

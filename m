From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Wed, 14 Jan 2009 11:48:39 -0800
Message-ID: <20090114194838.GB18436@linux-os.sc.intel.com>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com> <20090114044059.GA6222@mit.edu> <20090114191632.GA13114@linux-os.sc.intel.com> <1231961377.14825.51.camel@laptop> <20090114193844.GA18436@linux-os.sc.intel.com> <1231962169.14825.54.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbZANTst (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 14:48:49 -0500
Content-Disposition: inline
In-Reply-To: <1231962169.14825.54.camel@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 14, 2009 at 11:42:49AM -0800, Peter Zijlstra wrote:
> On Wed, 2009-01-14 at 11:38 -0800, Pallipadi, Venkatesh wrote:
> 
> > > > Below is the result of full bisect
> 
> > > >     futex: rely on get_user_pages() for shared futexes
> 
> > > However does a futex change make ext3 crap its pants?
> > > 
> > > Is there anything more to it than start the machine, and reboot?
> > 
> > Just system startup and reboot is enough to reproduce the problem. And 100%
> > reproducible. So, does seem to be any timing involved either.
> 
> That's very odd indeed, non of my test systems nor Ingo's ever triggered
> this, and that patch has been in -tip for a rather long time.
> 
> CommitDate: Tue Sep 30 12:35:20 2008 +0200
> 
> That's 3.5 months of test time.. most curious. What kind of userland do
> you have that triggers this?
> 

This is a Core 2 (X5460) DP server system with SuSE SLES 10 installation.
I have 3 ext3 partitions mounted; root, home and my own masterboot that I use to
switch between different OS installations.


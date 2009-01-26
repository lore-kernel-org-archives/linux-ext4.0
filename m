From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Mon, 26 Jan 2009 17:46:11 +0100
Message-ID: <1232988371.4863.162.camel@laptop>
References: <20090110003645.GA16107@linux-os.sc.intel.com>
	 <20090113164842.c6aa7095.akpm@linux-foundation.org>
	 <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com>
	 <20090114044059.GA6222@mit.edu>
	 <20090114191632.GA13114@linux-os.sc.intel.com>
	 <1231961377.14825.51.camel@laptop>  <20090114212038.GJ6222@mit.edu>
	 <1232568618.16682.20.camel@jamoon.sc.intel.com>
	 <1232782595.4859.3.camel@laptop>  <497DE73B.4050602@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Darren Hart <dvhltc@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZAZQqf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 11:46:35 -0500
In-Reply-To: <497DE73B.4050602@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-01-26 at 08:39 -0800, Darren Hart wrote:

> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index f89d373..f4132ab 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -929,7 +929,7 @@ out_unlock:
> > 
> >  	/* drop_futex_key_refs() must be called outside the spinlocks. */
> >  	while (--drop_count >= 0)
> > -		drop_futex_key_refs(&key1);
> > +		drop_futex_key_refs(&key2);
> 
> Unfortunately, I realized later that this code was indeed correct and I 
> asked Ingo to pull my patch implementing the above change.  Quoting my 
> previous mail on the subject:
> 
> "I believe what is happening here is that the requeue loop requeues each 
> waiter from one futex (key1) to another (key2).  It rightly takes a 
> reference to the futex at key2 and then decrements the references to 
> key1 by drop_count (since the waiters now reference key2, not key1). 
> The newly taken key2 references will be dropped in futex_wait() when 
> each waiter is woken up and takes the futex."

Argh, that wants a comment..


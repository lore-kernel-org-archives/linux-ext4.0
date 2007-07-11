From: Greg KH <greg@kroah.com>
Subject: Re: [PATHC] Fix for ext2 reservation (Re: -mm merge plans for
	2.6.23)
Date: Tue, 10 Jul 2007 17:21:50 -0700
Message-ID: <20070711002150.GA28535@kroah.com>
References: <20070710113704.8b20f3c3.akpm@linux-foundation.org> <4693E07E.4010300@mbligh.org> <1184105757.8390.6.camel@dyn9047017100.beaverton.ibm.com> <20070710165507.f8e61bb2.akpm@linux-foundation.org> <1184112257.8390.8.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Martin Bligh <mbligh@mbligh.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Hugh Dickins <hugh@veritas.com>,
	Jeremy Orlow <jorlow@google.com>,
	Nick Piggin <piggin@cyberone.com.au>,
	Mingming Cao <cmm@us.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>, stable@kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:55243 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXGKAWf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 20:22:35 -0400
Content-Disposition: inline
In-Reply-To: <1184112257.8390.8.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 10, 2007 at 05:04:17PM -0700, Badari Pulavarty wrote:
> On Tue, 2007-07-10 at 16:55 -0700, Andrew Morton wrote:
> > On Tue, 10 Jul 2007 15:15:57 -0700
> > Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > 
> > > Well, I looked at the problem now and here is the fix :)
> > 
> > whee, thanks.
> > 
> > > Greg, Please consider this for stable release also.
> > 
> > No, it is only relevant to -mm's ext2-reservations.patch.
> 
> Yes. Sorry. I was looking at -mm tree and assumed that
> ext2-reservation code made into mainline also :(
> 
> Greg, please ignore the patch for stable.

Ok, dropped from my -stable queue mbox.

thanks,

greg k-h

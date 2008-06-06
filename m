From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Fri, 6 Jun 2008 09:15:47 -0400
Message-ID: <20080606131547.GB9033@mit.edu>
References: <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu> <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com> <20080513045028.GC22226@linux-mips.org> <20080528070637.GA10393@deprecation.cyrius.com> <20080605111148.GA4483@deprecation.cyrius.com> <1212664977.4840.6.camel@sd048.hel.movial.fi> <20080605183854.GN25477@mit.edu> <38408.84.249.59.97.1212701650.squirrel@webmail.movial.fi> <20080605215152.GB15504@networkno.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>,
	Martin Michlmayr <tbm@cyrius.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
	linux-mips@linux-mips.org, linux-ext4@vger.kernel.org
To: Thiemo Seufer <ths@networkno.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59409 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754315AbYFFNQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 09:16:18 -0400
Content-Disposition: inline
In-Reply-To: <20080605215152.GB15504@networkno.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 10:51:52PM +0100, Thiemo Seufer wrote:
> > Ted, Ralf seems to be unwilling to accept the ZERO_PAGE() export. If you
> > send the MIPS-specific patch, I can do the testing for you as I have a
> > MIPS Malta board at my disposal.

Ralf sent me a private note saying he would take care of this, but
that he had been very busy with real-world life items.

> AFAIU the problematic case are systems with R4000/R4400 SC/MC CPUs
> since they use 8 zero pages of different color. Have a look at
> arch/mips/mm/init.c:setup_zero_pages.

Right.  So we're not actually going to ever write to the page, but we
are going to add the page to a bio and submit for writing.  I assume
that's not going to cause VECI/VCED exceptions, right?  If the act of
DMA'ing, or worse yet, for older devices/drivers which have to use PIO
to write out a block device is going to cause "thousand and thousands
of exceptions", it sounds like MIPS CPU designers need to be slapped
silly....

					- Ted

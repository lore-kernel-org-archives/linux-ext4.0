From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Thu, 05 Jun 2008 14:22:57 +0300
Message-ID: <1212664977.4840.6.camel@sd048.hel.movial.fi>
References: <20080512130604.GA15008@deprecation.cyrius.com>
	 <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com>
	 <20080512143426.GB7029@mit.edu>
	 <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com>
	 <20080513045028.GC22226@linux-mips.org>
	 <20080528070637.GA10393@deprecation.cyrius.com>
	 <20080605111148.GA4483@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ralf Baechle <ralf@linux-mips.org>,
	Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.movial.fi ([62.236.91.34]:48274 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbYFELW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jun 2008 07:22:59 -0400
In-Reply-To: <20080605111148.GA4483@deprecation.cyrius.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-05 at 13:11 +0200, Martin Michlmayr wrote:
> * Martin Michlmayr <tbm@cyrius.com> [2008-05-28 09:06]:
> > * Ralf Baechle <ralf@linux-mips.org> [2008-05-13 05:50]:
> > > I prefer to do it myself so I can apply it at the same time to the MIPS
> > > -stable branches.
> > > 
> > > I'm a little irriated that this thread seems to be only about
> > > empty_zero_page but apparently not zero_page_mask?  empty_zero_page is
> > > actualy an array of pages on MIPS and ZERO_PAGE() will pick the right one
> > > for a particular user space mapping based on the virtual address but
> > > ZERO_PAGE() also references zero_page_mask.  So I sense more brokenness
> > > here.
> > 
> > Just as a reminder, this issue is still there (at least with rc4).
> 
> Still present in rc5.

It looks like the discussion related to this issue has faded out. Ralf
seemed to have some objections to using ZERO_PAGE() outside of the
context of getting a user-mapped page, but I think that ext4 driver is
still doing that.

Ralf, will it be possible to use the patch I sent earlier as a temporary
solution? Just to make sure the kernel builds?

Thanks,
Dmitri
> 


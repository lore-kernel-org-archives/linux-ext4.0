From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Thu, 5 Jun 2008 13:11:48 +0200
Message-ID: <20080605111148.GA4483@deprecation.cyrius.com>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu> <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com> <20080513045028.GC22226@linux-mips.org> <20080528070637.GA10393@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:4457 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbYFELMF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jun 2008 07:12:05 -0400
Content-Disposition: inline
In-Reply-To: <20080528070637.GA10393@deprecation.cyrius.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Martin Michlmayr <tbm@cyrius.com> [2008-05-28 09:06]:
> * Ralf Baechle <ralf@linux-mips.org> [2008-05-13 05:50]:
> > I prefer to do it myself so I can apply it at the same time to the MIPS
> > -stable branches.
> > 
> > I'm a little irriated that this thread seems to be only about
> > empty_zero_page but apparently not zero_page_mask?  empty_zero_page is
> > actualy an array of pages on MIPS and ZERO_PAGE() will pick the right one
> > for a particular user space mapping based on the virtual address but
> > ZERO_PAGE() also references zero_page_mask.  So I sense more brokenness
> > here.
> 
> Just as a reminder, this issue is still there (at least with rc4).

Still present in rc5.

-- 
Martin Michlmayr
http://www.cyrius.com/

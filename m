From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Tue, 13 May 2008 06:12:52 +0100
Message-ID: <20080513051252.GA20575@linux-mips.org>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu> <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com> <20080513045028.GC22226@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Martin Michlmayr <tbm@cyrius.com>,
	linux-mips@linux-mips.org, linux-ext4@vger.kernel.org
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vigor.karmaclothing.net ([217.169.26.28]:51606 "EHLO
	dl5rb.ham-radio-op.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753487AbYEMFNV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2008 01:13:21 -0400
Content-Disposition: inline
In-Reply-To: <20080513045028.GC22226@linux-mips.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 13, 2008 at 05:50:29AM +0100, Ralf Baechle wrote:

> > Normally I push my patches via the mips tree, and now I'm Cc:ing Ralf for that.
> > 
> > Hopefully Ralf will react quickly. :)
> 
> I prefer to do it myself so I can apply it at the same time to the MIPS
> -stable branches.
> 
> I'm a little irriated that this thread seems to be only about
> empty_zero_page but apparently not zero_page_mask?  empty_zero_page is
> actualy an array of pages on MIPS and ZERO_PAGE() will pick the right one
> for a particular user space mapping based on the virtual address but
> ZERO_PAGE() also references zero_page_mask.  So I sense more brokenness
> here.

The ZERO_PAGE(0) call in ext4_ext_zeroout is the culprit.  Using a zero
argument allows the compiler to eleminate the reference to zero_page_mask.

Am I reading this right that ZERO_PAGE() is being used without any
mappings to userspace being involved?

  Ralf

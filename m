From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Tue, 13 May 2008 05:50:29 +0100
Message-ID: <20080513045028.GC22226@linux-mips.org>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu> <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Martin Michlmayr <tbm@cyrius.com>,
	linux-mips@linux-mips.org, linux-ext4@vger.kernel.org
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 12, 2008 at 06:46:21PM +0400, Dmitri Vorobiev wrote:

> >  What is the Linux-mips' team preference for feeding this patch to
> >  Linus?  This technically isn't a regression, since it was broken in
> >  2.6.25, but it would be nice to get this to Linus sooner rather than
> >  later.  Should I push it with a batch of ext4 fixes, or do you want to
> >  push it via the mips tree?  (Davem asked me to push the sparc export
> >  via ext4, while the ppc arch, it went via the ppc tree.  So whichever
> >  is your preference; I'm easy.  :-)
> >
> >                                             - Ted
> 
> Hi Ted,
> 
> Normally I push my patches via the mips tree, and now I'm Cc:ing Ralf for that.
> 
> Hopefully Ralf will react quickly. :)

I prefer to do it myself so I can apply it at the same time to the MIPS
-stable branches.

I'm a little irriated that this thread seems to be only about
empty_zero_page but apparently not zero_page_mask?  empty_zero_page is
actualy an array of pages on MIPS and ZERO_PAGE() will pick the right one
for a particular user space mapping based on the virtual address but
ZERO_PAGE() also references zero_page_mask.  So I sense more brokenness
here.

  Ralf

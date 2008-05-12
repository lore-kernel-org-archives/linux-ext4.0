From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Mon, 12 May 2008 10:34:26 -0400
Message-ID: <20080512143426.GB7029@mit.edu>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39919 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751032AbYELOeo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 10:34:44 -0400
Content-Disposition: inline
In-Reply-To: <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 05:54:24PM +0400, Dmitri Vorobiev wrote:
> 
> Yep. The export is missing. Attached patch was build-tested for a
> Malta config with ext4 enabled as a module.

Thanks, Dmitri!  

What is the Linux-mips' team preference for feeding this patch to
Linus?  This technically isn't a regression, since it was broken in
2.6.25, but it would be nice to get this to Linus sooner rather than
later.  Should I push it with a batch of ext4 fixes, or do you want to
push it via the mips tree?  (Davem asked me to push the sparc export
via ext4, while the ppc arch, it went via the ppc tree.  So whichever
is your preference; I'm easy.  :-)

   	     	     		     	    - Ted


> From cb55ed7d958cf4abb58dd1d6e46e09447b5694b0 Mon Sep 17 00:00:00 2001
> From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
> Date: Mon, 12 May 2008 17:49:19 +0400
> Subject: [PATCH 1/1] [MIPS] Export empty_zero_page as a GPL symbol
> 
> The empty_zero_page symbol is needed for the ext4 driver and
> should therefore be exported. This fixes the following error
> reported by Martin Michlmayr:
> 
> >>>>>>>
> 
> MODPOST 1516 modules
> ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!
> 
> >>>>>>
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
> ---
>  arch/mips/mm/init.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
> index ecd562d..618a418 100644
> --- a/arch/mips/mm/init.c
> +++ b/arch/mips/mm/init.c
> @@ -70,7 +70,10 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
>   * any price.  Since page is never written to after the initialization we
>   * don't have to care about aliases on other CPUs.
>   */
> -unsigned long empty_zero_page, zero_page_mask;
> +unsigned long empty_zero_page;
> +EXPORT_SYMBOL_GPL(empty_zero_page);
> +
> +unsigned long zero_page_mask;
>  
>  /*
>   * Not static inline because used by IP27 special magic initialization code
> -- 
> 1.5.3
> 


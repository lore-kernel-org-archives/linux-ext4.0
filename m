From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/11] ext4: Fix end of group handling in
 ext4_mb_init_cache
Date: Tue, 1 Oct 2013 08:45:41 -0400
Message-ID: <20131001124541.GB2097@thunk.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-9-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1380572952-30729-9-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 30, 2013 at 01:29:09PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The first loop in ext4_mb_init_cache can bail out when the end of
> all groups is reached. Unfortunately the later loops did not
> have that check and could access uninitialized buffer pointers
> in bh[]. Add the end of group check everywhere.
> 
> Cc: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Makefile          | 6 +++---
>  fs/ext4/mballoc.c | 6 +++++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 8d0668f..be3ef83 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -663,9 +663,9 @@ KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
>  KBUILD_ARFLAGS := $(call ar-option,D)
>  
>  # check for 'asm goto'
> -ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
> -	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
> -endif
> +#ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
> +#	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
> +#endif
>  
>  # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
>  KBUILD_CPPFLAGS += $(KCPPFLAGS)

What's this change all about, and why is it included in this
patch?

						- Ted

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] include/jbd: add missing ifdef CONFIG_BLOCK
Date: Tue, 30 Jul 2013 09:17:26 -0400
Message-ID: <51F7BCE6.6080005@windriver.com>
References: <alpine.DEB.2.02.1307300830370.2625@M2420>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Xiong Zhou <jencce.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:55498 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3G3NRL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jul 2013 09:17:11 -0400
In-Reply-To: <alpine.DEB.2.02.1307300830370.2625@M2420>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13-07-29 08:31 PM, Xiong Zhou wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
> 
> In jbd{2}.h, BH_PrivateStart is used in the define of enum jbd_state_bits,
> which is defined in buffer_head.h under ifdef CONFIG_BLOCK. In these
> two headers, BUFFER_FNS and TAS_BUFFER_FNS and jbd_common.h refer to
> enum jbd_state_bits, so they should under ifdef CONFIG_BLOCK.

What exactly is it you are trying to solve here?  I 1st thought
perhaps some pointless randconfig build fail, but even if you try
to hand craft a .config with "# CONFIG_BLOCK is not set" you still
can't get to ext2/3/4 options because fs/Kconfig has this:

 ---------------
if BLOCK

source "fs/ext2/Kconfig"
source "fs/ext3/Kconfig"
source "fs/ext4/Kconfig"
 ----------

The help text for CONFIG_BLOCK is explicit in saying this too.

I don't see value in adding more #ifdef noise that doesn't do anything.

Thanks,
Paul.
--

> 
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> ---
>  include/linux/jbd.h  |    2 ++
>  include/linux/jbd2.h |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 8685d1b..e9dcf47 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -244,6 +244,7 @@ typedef struct journal_superblock_s
>  #include <linux/fs.h>
>  #include <linux/sched.h>
>  
> +#ifdef CONFIG_BLOCK
>  enum jbd_state_bits {
>  	BH_JBD			/* Has an attached ext3 journal_head */
>  	  = BH_PrivateStart,
> @@ -269,6 +270,7 @@ TAS_BUFFER_FNS(RevokeValid, revokevalid)
>  BUFFER_FNS(Freed, freed)
>  
>  #include <linux/jbd_common.h>
> +#endif
>  
>  #define J_ASSERT(assert)	BUG_ON(!(assert))
>  
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index d5b50a1..6214b80 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -298,6 +298,7 @@ typedef struct journal_superblock_s
>  #include <linux/fs.h>
>  #include <linux/sched.h>
>  
> +#ifdef CONFIG_BLOCK
>  enum jbd_state_bits {
>  	BH_JBD			/* Has an attached ext3 journal_head */
>  	  = BH_PrivateStart,
> @@ -326,6 +327,7 @@ BUFFER_FNS(Shadow, shadow)
>  BUFFER_FNS(Verified, verified)
>  
>  #include <linux/jbd_common.h>
> +#endif
>  
>  #define J_ASSERT(assert)	BUG_ON(!(assert))
>  
> 

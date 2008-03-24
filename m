From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arm: Export needed symbol for ZERO_PAGE usage in
 modules.
Date: Mon, 24 Mar 2008 12:05:41 -0700
Message-ID: <20080324120541.04615a2b.akpm@linux-foundation.org>
References: <1206381689-12600-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, rmk@arm.linux.org.uk, linux-ext4@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761182AbYCXTG1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 15:06:27 -0400
In-Reply-To: <1206381689-12600-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Mar 2008 23:31:29 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
> different symbols in different arch for the usage of ZERO_PAGE
> in modules.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  arch/arm/mm/mmu.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index d41a75e..2d6d682 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -35,6 +35,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>   * zero-initialized data and COW.
>   */
>  struct page *empty_zero_page;
> +EXPORT_SYMBOL(empty_zero_page);
>  
>  /*

I wonder if it would be better to do this export in generic code.

Architectures which don't implement empty_zero_page:

alpha:		seems to do something fancy
sparc64: 	need to rename mem_map_zero to empty_zero_page
v850:		#define ZERO_PAGE(vaddr) ((void *)0x87654321)  (wtf?)



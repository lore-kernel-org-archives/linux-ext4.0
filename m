From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Update series file
Date: Mon, 16 Jul 2007 09:25:14 -0700
Message-ID: <1184603114.4005.48.camel@localhost.localdomain>
References: <469B8CFF.8040303@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49944 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbXGPQZP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 12:25:15 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6GGPEFs030913
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 12:25:14 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6GGPEMY498964
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 12:25:14 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6GGPDxL010327
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2007 12:25:14 -0400
In-Reply-To: <469B8CFF.8040303@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-16 at 20:51 +0530, Aneesh Kumar K.V wrote:
> I think the series file got updated wrongly
> 

Thanks for catching this! Corrected.

Mingming
> -aneesh
> 
> diff --git a/series b/series
> index 183d72e..bf34353 100644
> --- a/series
> +++ b/series
> @@ -2,14 +2,10 @@
> 
>  # fallocate() syscall patches and ext4 fallocate() implementation
>  # Missing manpages
> -ext4-fallocate-1-syscall_i386_amd64_ppc
> -ext4-fallocate-2-syscall_s390
> -ext4-fallocate-3-syscall_ia64
> -ext4-fallocate-4-new_modes
> -ext4-fallocate-5-ext4_support
> -ext4-fallocate-6-uninit_write_support
> -ext4-fallocate-7-ext4_new_modes
> -ext4-fallocate-8-new-ondisk-format
> +ext4-fallocate-2-syscall_i386_amd64_ppc
> +ext4-fallocate-3-ext4_support
> +ext4-fallocate-4-uninit_write_support
> +ext4-fallocate-5-new-ondisk-format
> 
>  # Add mount option to turn off extents
>  ext4_noextent_mount_opt.patch

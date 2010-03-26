From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: remove unnecessary operation in
 ext4_mb_normalize_group_request()
Date: Fri, 26 Mar 2010 13:38:01 +0530
Message-ID: <87wrwzv732.fsf@linux.vnet.ibm.com>
References: <ac8f92701003250754o682aa32dw9bb51f36f0fa433b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55660 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0CZIIE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 04:08:04 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id o2Q882Ra027622
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 13:38:02 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2Q882bg3092542
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 13:38:02 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2Q881OG032222
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:08:02 +1100
In-Reply-To: <ac8f92701003250754o682aa32dw9bb51f36f0fa433b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 25 Mar 2010 22:54:21 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Wed Mar 25  22:55:04   2010
> 
> Checking bug seems not at right place, and the function itself should
> be inlined.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc-10.c	2010-03-25 22:44:00.000000000 +0800
> @@ -2786,9 +2786,7 @@ out_err:
>  static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
>  {
>  	struct super_block *sb = ac->ac_sb;
> -	struct ext4_locality_group *lg = ac->ac_lg;
> 
> -	BUG_ON(lg == NULL);
>  	if (EXT4_SB(sb)->s_stripe)
>  		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
>  	else

That BUG_ON is to ensure that the allocation context is actually having
a locality group which is needed for group allocation request.

-aneesh

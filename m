From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: Fix section conflict of ext4_ext_{find_goal,invalidate_cache}
Date: Tue, 15 May 2007 11:09:59 -0700
Message-ID: <1179252599.2836.127.camel@dyn9047017100.beaverton.ibm.com>
References: <20070515171527.GA20407@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, mcao@us.ibm.com
To: Martin Michlmayr <tbm@cyrius.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40937 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbXEOSJO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2007 14:09:14 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4FI9EvJ018374
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 14:09:14 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4FI9DWT146504
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 12:09:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4FI9D6o012399
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 12:09:13 -0600
In-Reply-To: <20070515171527.GA20407@deprecation.cyrius.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-05-15 at 19:15 +0200, Martin Michlmayr wrote:
> Building with GCC 4.2, I get the following error:
> 
>   CC [M]  fs/ext4/extents.o
> fs/ext4/extents.c:2166: error: __ksymtab_ext4_ext_find_goal causes a section type conflict
> fs/ext4/extents.c:2163: error: __ksymtab_ext4_ext_invalidate_cache causes a section type conflict
> 
> This is because ext4_ext_find_goal and ext4_ext_invalidate_cache are
> declared static but also exported.

Hmm.. Why are these exported ?

Looking at the code


EXPORT_SYMBOL(ext4_ext_invalidate_cache);
EXPORT_SYMBOL(ext4_ext_insert_extent);
EXPORT_SYMBOL(ext4_ext_walk_space);
EXPORT_SYMBOL(ext4_ext_find_goal);
EXPORT_SYMBOL(ext4_ext_calc_credits_for_insert);

Mingming ? Why are we exporting these ?

Thanks,
Badari

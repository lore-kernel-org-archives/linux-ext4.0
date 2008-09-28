From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Unusual code in mballoc.c.
Date: Sat, 27 Sep 2008 23:01:11 -0500
Message-ID: <48DF0187.5030005@redhat.com>
References: <200809281156.12688.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>,
	Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43567 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbYI1EBV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Sep 2008 00:01:21 -0400
In-Reply-To: <200809281156.12688.rusty@rustcorp.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rusty Russell wrote:
> Hi all,
> 
>    A grep lead me to fs/ext4/mballoc.c:
> 
> Line 2551:
> 	for (i = 0; i < nr_cpu_ids; i++) {
> 
> This is more normally "for_each_possible_cpu(i)".
> 
> Line 4097:
> 	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
> 	put_cpu();
> 
> This is presumably someone suppressing a warning.   It should be:
> 	ac->ac_lg = &sbi->s_locality_groups[raw_smp_processor_id()];
> 
> Thanks,
> Rusty.

Hi Rusty - I sent a patch for this a while back...

http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4-use-percpu-data-for-lg_prealloc_list;h=8ddebb7f6054f70e34b142d7ae6f314d6629aac7;hb=HEAD

Thanks,
-Eric

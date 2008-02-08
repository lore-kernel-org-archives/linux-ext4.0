From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from a kmem
	cache to save stack space
Date: Fri, 08 Feb 2008 10:25:20 -0800
Message-ID: <1202495120.15315.3.camel@localhost.localdomain>
References: <47A9E8CA.2070404@redhat.com>
	 <1202429513.3840.12.camel@localhost.localdomain>
	 <47ABAB29.2060300@redhat.com>
	 <1202434636.3840.25.camel@localhost.localdomain>
	 <47ABC00A.9080302@redhat.com>
	 <1202485537.6852.4.camel@norville.austin.ibm.com>
	 <1202488793.3936.4.camel@localhost.localdomain> <47AC8986.40409@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58702 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934819AbYBHSZZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 13:25:25 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m18IRGDw030962
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 13:27:16 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m18IPLes225426
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 13:25:21 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m18IPLoH004102
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 13:25:21 -0500
In-Reply-To: <47AC8986.40409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-02-08 at 10:55 -0600, Eric Sandeen wrote:
> Mingming Cao wrote:
> 
> > printk could be removed...so as long as it builds fine. I had looked at
> > the history yesterday and find this fix
> > http://lists.openwall.net/linux-ext4/2007/10/10/2
> > so I was under impression that the ifdefs was added to fix compile
> > issue. I did not look more closely. Maybe that's not a issue any more.
> 
> I guess I should look into it.  For now let's just drop the #ifdef
> removal, it's not related anyway.
> 
> Would you like me to send a fresh patch?
> 
ah...not necessary, I can edit the patch when merge it to the queue.
Yes we could deal with the ifdef in a separate patch, maybe something
like suggested by Shaggy.


Regards,
Mingming

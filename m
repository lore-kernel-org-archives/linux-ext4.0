From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from a kmem cache
 to save stack space
Date: Fri, 08 Feb 2008 10:55:34 -0600
Message-ID: <47AC8986.40409@redhat.com>
References: <47A9E8CA.2070404@redhat.com>	 <1202429513.3840.12.camel@localhost.localdomain>	 <47ABAB29.2060300@redhat.com>	 <1202434636.3840.25.camel@localhost.localdomain>	 <47ABC00A.9080302@redhat.com>	 <1202485537.6852.4.camel@norville.austin.ibm.com> <1202488793.3936.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762049AbYBHQ4t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 11:56:49 -0500
In-Reply-To: <1202488793.3936.4.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:

> printk could be removed...so as long as it builds fine. I had looked at
> the history yesterday and find this fix
> http://lists.openwall.net/linux-ext4/2007/10/10/2
> so I was under impression that the ifdefs was added to fix compile
> issue. I did not look more closely. Maybe that's not a issue any more.

I guess I should look into it.  For now let's just drop the #ifdef
removal, it's not related anyway.

Would you like me to send a fresh patch?

Thanks,
-Eric

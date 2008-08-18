From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] use percpu data for lg_prealloc_list
Date: Mon, 18 Aug 2008 11:07:57 -0500
Message-ID: <48A99E5D.2020309@redhat.com>
References: <48A331FA.6070602@redhat.com> <48A9999C.6070609@redhat.com> <20080818155650.GA6491@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58131 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbYHRQLF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Aug 2008 12:11:05 -0400
In-Reply-To: <20080818155650.GA6491@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Aug 18, 2008 at 10:47:40AM -0500, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> lg_prealloc_list seems to cry out for a per-cpu data structure; on a large
>>> smp system I think this should be better.  I've lightly tested this change
>>> on a 4-cpu system.  Comments welcome...
>> Any thoughts on this?  Does this seem to be the right way to go?
>>
> 
> Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks :)  I'll toss it in the patch queue.

-Eric

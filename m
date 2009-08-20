From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: RFC: guard against more "dangerous" userspace options
Date: Thu, 20 Aug 2009 09:48:08 -0500
Message-ID: <4A8D6228.1070006@redhat.com>
References: <4A81D7EC.2060706@redhat.com> <20090820062730.GA23232@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbZHTOsU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Aug 2009 10:48:20 -0400
In-Reply-To: <20090820062730.GA23232@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Tue, Aug 11, 2009 at 03:43:24PM -0500, Eric Sandeen wrote:
>> I'll keep it short and sweet:
>>
>> Can we add a consistent "--eatmydata" type of hurdle to jump over before
>> people are allowed to use either the so-far-less-tested tools and/or
>> options therein?
>>
>> I'm thinking of, so far:
> ......
>> tune2fs -I <bigger>
> 
> I have sent patches which should make this better. Any chance to get that reviwed and
> applied
> 
> -aneesh

Better, or _safe_?  :)

No offense and I certainly appreciate that work.  If you feel it's
robust enough now to safely unleash on users, I'll drop it from my list.  :)

-Eric

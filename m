From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: RFC: guard against more "dangerous" userspace options
Date: Fri, 21 Aug 2009 09:40:44 -0500
Message-ID: <4A8EB1EC.5080608@redhat.com>
References: <4A81D7EC.2060706@redhat.com> <20090820062730.GA23232@skywalker.linux.vnet.ibm.com> <4A8D6228.1070006@redhat.com> <20090821070252.GA17871@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbZHUOlB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2009 10:41:01 -0400
In-Reply-To: <20090821070252.GA17871@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Thu, Aug 20, 2009 at 09:48:08AM -0500, Eric Sandeen wrote:

...

>>>> I'm thinking of, so far:
>>> ......
>>>> tune2fs -I <bigger>
>>> I have sent patches which should make this better. Any chance to get that reviwed and
>>> applied
>>>
>>> -aneesh
>> Better, or _safe_?  :)
>>
>> No offense and I certainly appreciate that work.  If you feel it's
>> robust enough now to safely unleash on users, I'll drop it from my list.  :)
> 
> I am interested in the test results. Getting more users to test would always
> be nice. 

yep it's a tricky spot, asking users to test potentially dangerous code
in real life.

> But it still would help to get a through review.

Agree, sorry I haven't yet done that.

-Eric

> 
> -aneesh


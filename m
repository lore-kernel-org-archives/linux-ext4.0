From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RESEND] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Fri, 15 Feb 2008 09:51:34 -0600
Message-ID: <47B5B506.7020201@redhat.com>
References: <1203006909.8970.20.camel@ext1.frec.bull.fr> <47B46E71.805@redhat.com> <47B5AD44.8010305@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYBOPwI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2008 10:52:08 -0500
In-Reply-To: <47B5AD44.8010305@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Clement wrote:
> Eric Sandeen wrote:
>> Valerie Clement wrote:
>>> Fix kernel BUG at fs/ext4/mballoc.c:910!
>>>
>>> From: Valerie Clement <valerie.clement@bull.net>
>>>
>>> With the flex_bg feature enabled, a large file creation oopses the
>>> kernel.
>> Valerie, what's the specific testcase for this?
>>
>> Thanks,
>> -Eric
> I just did a simple dd,
>   dd if=/dev/zero of=/mnt/test/foo bs=1M count=8k
> on an ext4 filesystem with the uninit_groups, lazy_bg and flex_bg
> features enabled and the default mount options.

Ok, thanks Valerie.  It's just always nice to know exactly how to
reproduce a problem that a patch fixes, IMHO.

-Eric

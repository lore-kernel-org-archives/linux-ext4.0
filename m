From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V3] fix bb_prealloc_list corruption due to wrong group
 locking
Date: Wed, 18 Mar 2009 11:17:09 -0500
Message-ID: <49C11E85.3040300@redhat.com>
References: <49BAD6D9.3010505@redhat.com> <49BE82A9.4000407@redhat.com>	 <49BE8C30.5030901@redhat.com>	 <1237225369.3964.4.camel@bobble.smo.corp.google.com>	 <49BE90E0.3090309@redhat.com>	 <1237225989.3964.9.camel@bobble.smo.corp.google.com> <1237392694.31964.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbZCRQRZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 12:17:25 -0400
In-Reply-To: <1237392694.31964.2.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Mon, 2009-03-16 at 10:53 -0700, Frank Mayhar wrote: 
>> On Mon, 2009-03-16 at 12:48 -0500, Eric Sandeen wrote:
>>> Hi Frank - I don't *think* so just because deleted items are poisoned
>>> and I would expect that we'd trip over a bad pointer in the corrupted
>>> list item as the first indicator of trouble... but I could be wrong.
>>>
>>> I think you said you could reproduce it, right?  So certainly worth
>>> testing with this fix I suppose.
>> Yeah, we're working on doing that now.  We're not running with a lot of
>> debugging turned on so we may or may not actually fall over if we try to
>> traverse freed (or just wrong) list entries.  If it isn't the same race,
>> though, then there's still one lurking in this code and that would be a
>> hell of a coincidence.
> 
> FYI we're running now with this patch in both a test and a production
> environment and haven't (yet) seen the bitmap inconsistency we were
> encountering regularly.  So far we have over 18 hours of runtime.  So,
> despite the enormous coincidence, our problem appears to be due to the
> same cause.
> 
> Thanks for the fix, Eric!

Good deal; I'll just trust that it's fixed, and maybe at some point I'll
sort out how they're related ;)

Thanks,
-Eric

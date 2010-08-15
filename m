From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Intel SSD data loss: Any possible way this is user / software
 error?
Date: Sun, 15 Aug 2010 11:18:59 -0500
Message-ID: <4C681373.9090409@redhat.com>
References: <4C64615B.70308@mit.edu> <4C65331A.9050203@redhat.com> <AD482FB5-0A56-43F2-BB70-8F218657DCE0@MIT.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Evan Jones <evanj@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab0HOQTA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Aug 2010 12:19:00 -0400
In-Reply-To: <AD482FB5-0A56-43F2-BB70-8F218657DCE0@MIT.EDU>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Evan Jones wrote:
> On Aug 13, 2010, at 7:57 , Eric Sandeen wrote:
>> Just out of curiosity, what do you see when the write cache is on?
>> Seems counter-intuitive that it'd work better, but talking w/
>> Ric Wheeler, he was curious... maybe Intel didn't test with the
>> write cache off?
> 
> Data loss is much easier to trigger with the write cache on. It happens
> to me on the first try. With the write cache off, I've only been able to
> get it to occur with large writes (64 kB or larger), and only about once
> every 3 times.

Ok, so working as expected then, really.

...

>> Also, would you be willing to publish the test you're using?
> 
> The programs I have been using are here (but see below):
> 
> http://people.csail.mit.edu/evanj/hg/index.cgi/hstore/file/tip/logging/minlogcrash.c
> 
> http://people.csail.mit.edu/evanj/hg/index.cgi/hstore/file/tip/logging/logfilecrashserver.cc

Cool, thanks for publishing all that info, a few people have done 
power loss testing, always interesting to see what's been put together.

I'll take a closer look at some point...

-Eric

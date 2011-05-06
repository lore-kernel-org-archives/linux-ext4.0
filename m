From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: remove redundant 'extern' keyword for function-definition
Date: Fri, 06 May 2011 11:19:18 -0500
Message-ID: <4DC41F86.1070405@redhat.com>
References: <1304669967-5677-1-git-send-email-sanbai@taobao.com> <811F6CB9-D7EB-41BA-B403-6530A5BF7234@mit.edu> <alpine.LFD.2.00.1105061326200.5122@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@MIT.EDU>, Robin Dong <hao.bigrat@gmail.com>,
	linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189Ab1EFQT3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 May 2011 12:19:29 -0400
In-Reply-To: <alpine.LFD.2.00.1105061326200.5122@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/6/11 6:36 AM, Lukas Czerner wrote:
> On Fri, 6 May 2011, Theodore Tso wrote:
> 
>> I don't really see the point to removing redundant keywords
>> like this.   To my mind, it's like fixing whitespaces.   If we are 
>> making changes to that part of the code, it's good to fix it,
>> and I'd rather not introduce such things in new code, but
>> as far as fixing code like this, i don't think an extra "extern"
>> is that harmful that it's worth fixing up.
>>
>> What do other people think?
> 
> Agreed! And since I am going to make some changes in lazyinit code anyway,
> I can very well make that change (and of course give Robin the credit for
> it:).
> 
> On the other hand I do not see a *huge* problem with commits like that, but
> it is just additional unnecessary commit. Usually people complain that
> git blame need some more digging with commits like this changing
> otherwise perfectly sane code, but when one is going to make that change
> when making some changes "at that area" it would mess up git blame
> anyway.
> 
> Thanks!
> -Lukas

FWIW, I had noticed this too, and there is another one in fsync.c:

fsync.c:extern int ext4_flush_completed_IO(struct inode *inode)

so, next time someone touches that code... ;)

-Eric

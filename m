From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 05 Feb 2012 10:36:39 -0600
Message-ID: <4F2EB017.5090006@redhat.com>
References: <4F2D8F30.3090802@redhat.com> <201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Ron Yorston <rmy@tigress.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab2BEQgn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Feb 2012 11:36:43 -0500
In-Reply-To: <201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/5/12 3:33 AM, Ron Yorston wrote:
> Eric Sandeen wrote:
> 
>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>>
>> I'll see if util-linux wants it after it gets beat into shape.
>> (or did a tool like this already exist and I missed it?)
> 
> Way ahead of you.  I wrote my sparsify utility for ext2 in 2004:
> 
>    http://intgat.tigress.co.uk/rmy/uml/sparsify.html

Cool, I had not known about that one.  But that one is a bit less generic -
ext2-specific and requiring an unmounted fs, right?

> It's mostly of historical interest now, I suppose.  The sparsify utility
> doesn't work on ext4 and I long since gave up maintaining the kernel
> patch.  I still use the zerofree utility, though.
> 
> It would be nice to have a modern version of sparsify.  I'll try it out.

Thanks!

Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.
I should also untie the read/zero buffer size from the minimum hole size,
we should do optimal IO sizes regardless of the minimum hole size desired...

-Eric
 
> Ron


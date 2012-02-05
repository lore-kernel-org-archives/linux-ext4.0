From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 05 Feb 2012 11:21:26 -0600
Message-ID: <4F2EBA96.2070603@redhat.com>
References: <4F2D8F30.3090802@redhat.com> <201202050933.q159XQpB026380@helium.internal.tigress.co.uk> <4F2EB017.5090006@redhat.com> <201202051719.q15HJJme010040@helium.internal.tigress.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Ron Yorston <rmy@tigress.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab2BERVb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Feb 2012 12:21:31 -0500
In-Reply-To: <201202051719.q15HJJme010040@helium.internal.tigress.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/5/12 11:19 AM, Ron Yorston wrote:
> OK, I tried it out for my use case of flinging VM filesystem images around
> on ext4 and it seems to do the job.  I don't have any 64-bit systems
> here at home so I used my feeble 32-bit netbook.  Since sizeof(off_t) !=
> sizeof(long long) the debug output was all wrong:
> 
>    punching at 8989607068975104 len -4635819229210214401

whoops, I'll fix that thanks.

This is the problem when I start something as a hack and then expose it
to the light of day.  ;)

-Eric

> but the image file and the host filesystem both survived the ordeal.
> 
> Ron


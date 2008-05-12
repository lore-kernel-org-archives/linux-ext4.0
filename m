From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: barriers off by default?
Date: Mon, 12 May 2008 14:00:18 -0500
Message-ID: <482893C2.7000709@redhat.com>
References: <482868A5.1000102@redhat.com>	 <72c5d9a0805121030y709de9cehc01df8aeb5b1b8d3@mail.gmail.com>	 <482883FD.8060001@redhat.com>	 <72c5d9a0805121150j58482bc6qd57a87089ce4414e@mail.gmail.com> <72c5d9a0805121151m2d838f3cxe61368b928dc5db2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric A <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbYELTAe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 15:00:34 -0400
In-Reply-To: <72c5d9a0805121151m2d838f3cxe61368b928dc5db2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric A wrote:
>  Documentation/block/barrier.txt
> 
>  There's a section that starts:
> 
>  "* Error handling.  Currently, block layer will report error to upper
>  layer if any of requests in an ordered sequence fails.  Unfortunately,
>  this doesn't seem to be enough. "

And ends:

"As the probability of this happening is very low and the drive should
be faulty, implementing the fix is probably an overkill.  But, still,
it's there."

I'm not sure it's an argument for disabling barriers in general.   :)

-Eric


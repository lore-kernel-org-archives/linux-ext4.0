From: Ron Yorston <rmy@tigress.co.uk>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 05 Feb 2012 09:33:26 +0000
Message-ID: <201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
References: <4F2D8F30.3090802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: xfs@oss.sgi.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ip-87-86-166-5.easynet.co.uk ([87.86.166.5]:40148 "EHLO
	geotraceuk2.Geotrace.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751950Ab2BEJko (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Feb 2012 04:40:44 -0500
In-Reply-To: <4F2D8F30.3090802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

>Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>"re-sparsify" a file by punching out ranges of 0s might be in order.
>
>I'll see if util-linux wants it after it gets beat into shape.
>(or did a tool like this already exist and I missed it?)

Way ahead of you.  I wrote my sparsify utility for ext2 in 2004:

   http://intgat.tigress.co.uk/rmy/uml/sparsify.html

It's mostly of historical interest now, I suppose.  The sparsify utility
doesn't work on ext4 and I long since gave up maintaining the kernel
patch.  I still use the zerofree utility, though.

It would be nice to have a modern version of sparsify.  I'll try it out.

Ron

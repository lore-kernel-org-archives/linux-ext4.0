From: Ron Yorston <rmy@tigress.co.uk>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 05 Feb 2012 17:19:19 +0000
Message-ID: <201202051719.q15HJJme010040@helium.internal.tigress.co.uk>
References: <4F2D8F30.3090802@redhat.com>
 <201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
 <4F2EB017.5090006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: sandeen@redhat.com, rmy@tigress.co.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ip-87-86-166-5.easynet.co.uk ([87.86.166.5]:51672 "EHLO
	geotraceuk2.Geotrace.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754670Ab2BERUV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Feb 2012 12:20:21 -0500
In-Reply-To: <4F2EB017.5090006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, I tried it out for my use case of flinging VM filesystem images around
on ext4 and it seems to do the job.  I don't have any 64-bit systems
here at home so I used my feeble 32-bit netbook.  Since sizeof(off_t) !=
sizeof(long long) the debug output was all wrong:

   punching at 8989607068975104 len -4635819229210214401

but the image file and the host filesystem both survived the ordeal.

Ron

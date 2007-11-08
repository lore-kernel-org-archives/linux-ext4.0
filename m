From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: delalloc space accounting problem.
Date: Thu, 08 Nov 2007 20:53:58 +0300
Message-ID: <47334D36.9070401@gmail.com>
References: <47334B44.8080206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-2.sun.com ([192.18.6.24]:63958 "EHLO
	gmp-eb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781AbXKHRyS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2007 12:54:18 -0500
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id lA8HsGi9010972
	for <linux-ext4@vger.kernel.org>; Thu, 8 Nov 2007 17:54:16 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JR700F016OGS900@fe-emea-09.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Thu,
 08 Nov 2007 17:54:16 +0000 (GMT)
In-reply-to: <47334B44.8080206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

because new delalloc patch doesn't have reservation integrated.
I'm going to implement this after data=order support.

thanks, Alex

Eric Sandeen wrote:
> It appears that delalloc lets me copy 50M of data onto a 30M filesystem;
> at least I never get ENOSPC back, although I wind up with several files
> that have 1M length but 0 blocks.
> 
> I've filed a bug in the kernel bug tracker, I think we could use a
> central place to track issues:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9329
> 
> I'll try to find time to look into this unless someone knows offhand
> where the problem is...
> 
> Thanks,
> -Eric
> 
> (p.s. should I get ext[234] bug mail routed to this list, or would that
> be annoying?)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

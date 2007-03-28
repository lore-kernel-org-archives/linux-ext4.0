From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Ext4 benchmarks
Date: Wed, 28 Mar 2007 09:20:50 -0500
Message-ID: <460A79C2.6030406@us.ibm.com>
References: <45FFFBAA.6080404@bull.net> <4600A1BD.80700@us.ibm.com> <460A3010.6080201@bull.net>
Reply-To: jrs@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47377 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXC1OUy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2007 10:20:54 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2SEKqNG014655
	for <linux-ext4@vger.kernel.org>; Wed, 28 Mar 2007 10:20:52 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2SEKqB9187008
	for <linux-ext4@vger.kernel.org>; Wed, 28 Mar 2007 10:20:52 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2SEKqnV019010
	for <linux-ext4@vger.kernel.org>; Wed, 28 Mar 2007 10:20:52 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2SEKp5E018973
	for <linux-ext4@vger.kernel.org>; Wed, 28 Mar 2007 10:20:52 -0400
In-Reply-To: <460A3010.6080201@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jean-Pierre Dion wrote:
> Hi Jose,
>
> thank you for the feedback.
>
> We took your remarks into account and we are doing some perfs with
> iozone (close to desktop activity, mono-thread) and ffsb (allows to run 
> benchs
> in a multi-thread activity like a server does, different blocks sizes...).
>
> We compare ext3 and ext4 (with extents, w/ and w/o del alloc...)...
>
> We will publish the results on bullopensource.org
>   

Hi Jean-Pierre,

While it may be to late for the purposes of your OLS paper, one thing 
that doesn't seem to be getting much attention is the performance of a 
file system while doing many meta-data operations or throughput testing 
during heavy journal log activity.  I believe that IOzone is very 
limited in testing this and FFSB isn't much better at it either.  
Eventually, I plan to add support in FFSB to create workload profile 
were one can select a weight balance of these types of operations.

Is this something that you are already doing for this round of testing?

-JRS

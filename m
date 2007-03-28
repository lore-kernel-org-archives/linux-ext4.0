From: Ric Wheeler <ric@emc.com>
Subject: Re: Ext4 benchmarks
Date: Wed, 28 Mar 2007 07:27:14 -0400
Message-ID: <460A5112.4040709@emc.com>
References: <45FFFBAA.6080404@bull.net> <4600A1BD.80700@us.ibm.com> <460A3010.6080201@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jrs@us.ibm.com, linux-ext4@vger.kernel.org
To: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:54590 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934273AbXC1L13 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2007 07:27:29 -0400
In-Reply-To: <460A3010.6080201@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Jean-Pierre Dion wrote:
> Hi Jose,
>
> thank you for the feedback.
>
> We took your remarks into account and we are doing some perfs with
> iozone (close to desktop activity, mono-thread) and ffsb (allows to 
> run benchs
> in a multi-thread activity like a server does, different blocks 
> sizes...).
>
> We compare ext3 and ext4 (with extents, w/ and w/o del alloc...)...
>
> We will publish the results on bullopensource.org
>
>
> jean-pierre
>
I also have a benchmark that stresses a heavy synchronous write workload 
that I can run.

ric

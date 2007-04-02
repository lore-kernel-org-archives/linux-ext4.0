From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: Ext4 benchmarks
Date: Mon, 02 Apr 2007 16:56:26 +0200
Message-ID: <4611199A.3050506@bull.net>
References: <45FFFBAA.6080404@bull.net> <4600A1BD.80700@us.ibm.com> <460A3010.6080201@bull.net> <460A79C2.6030406@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47436 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965550AbXDBO4I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2007 10:56:08 -0400
In-Reply-To: <460A79C2.6030406@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jose,

I have to check with the team here.
Will tell you.

Thanks.

jean-pierre


Jose R. Santos wrote:
> Jean-Pierre Dion wrote:
>> Hi Jose,
>>
>> thank you for the feedback.
>>
>> We took your remarks into account and we are doing some perfs with
>> iozone (close to desktop activity, mono-thread) and ffsb (allows to 
>> run benchs
>> in a multi-thread activity like a server does, different blocks 
>> sizes...).
>>
>> We compare ext3 and ext4 (with extents, w/ and w/o del alloc...)...
>>
>> We will publish the results on bullopensource.org
>>   
>
> Hi Jean-Pierre,
>
> While it may be to late for the purposes of your OLS paper, one thing 
> that doesn't seem to be getting much attention is the performance of a 
> file system while doing many meta-data operations or throughput 
> testing during heavy journal log activity.  I believe that IOzone is 
> very limited in testing this and FFSB isn't much better at it either.  
> Eventually, I plan to add support in FFSB to create workload profile 
> were one can select a weight balance of these types of operations.
>
> Is this something that you are already doing for this round of testing?
>
> -JRS
>

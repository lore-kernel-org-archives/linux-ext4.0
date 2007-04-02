From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: Ext4 benchmarks
Date: Mon, 02 Apr 2007 16:55:37 +0200
Message-ID: <46111969.8090006@bull.net>
References: <45FFFBAA.6080404@bull.net> <4600A1BD.80700@us.ibm.com> <460A3010.6080201@bull.net> <460A5112.4040709@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jrs@us.ibm.com, linux-ext4@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47256 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965555AbXDBOzT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2007 10:55:19 -0400
In-Reply-To: <460A5112.4040709@emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ric,

that may be useful. Checking with the team here and tell you.

Thanks.

jean-pierre


Ric Wheeler wrote:
>
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
>>
>> jean-pierre
>>
> I also have a benchmark that stresses a heavy synchronous write 
> workload that I can run.
>
> ric
>
>

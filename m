From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: Ext4 benchmarks
Date: Wed, 28 Mar 2007 11:06:24 +0200
Message-ID: <460A3010.6080201@bull.net>
References: <45FFFBAA.6080404@bull.net> <4600A1BD.80700@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52993 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXC1JGI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2007 05:06:08 -0400
In-Reply-To: <4600A1BD.80700@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jose,

thank you for the feedback.

We took your remarks into account and we are doing some perfs with
iozone (close to desktop activity, mono-thread) and ffsb (allows to run 
benchs
in a multi-thread activity like a server does, different blocks sizes...).

We compare ext3 and ext4 (with extents, w/ and w/o del alloc...)...

We will publish the results on bullopensource.org


jean-pierre


Jose R. Santos wrote:
> Jean-Pierre Dion wrote:
>> Hi all,
>>
>> we already discussed during the conf calls what
>> benchmarks should be ran on ext4.
>>
>> As we have OLS paper on the table we were thinking
>> here at Bull what bench t run and on which kernel.
>>
>> If we want trying to compare ext3 and ext4, I guess we
>> should at least show that :
>> - ext4 has equivalent perfs than ext3,
>>   
>
> Define equivalent performance.
>
> Are the workloads only going to be focused on single repetitive 
> operations or simulation of actual desktop/server environments?  How 
> about performance on an aged filesystem?
>> - improvements done for ext3 are still in ext4 (mb alloc, del alloc...).
>>
>> So  we were wondering what's best to do :
>> - run on 2.6.19 (includes del alloc and mb alloc if I am not wrong),
>> - run on 2.6.20 (lacks mb alloc),
>>   
>
> What about system configurations?  While a desktop configuration would 
> be easy to come by, a server configuration needs a bit more thought.  
> Will ext4 perform better than ext3 in a wide range of storage 
> configuration that scale from a couple thousands IOPS to several 
> hundred thousand IOPS?
>
> Having baseline data on other filesystems like XFS or JFS would be 
> interesting as well to see how well ext4 stacks up to the competition. :)
>> - select relevant benchs (iozone...).
>>   
>
> I haven checked IOzone in quite a bit but last time I checked FFSB had 
> a couple of capabilities that are not available in IOzone like multi 
> threading on a shared data set and a very customizable IO operations 
> to attempt to simulate real IO patterns seen on workloads.  Might be 
> worth a look if your interested in compiling a very comprehensive set 
> of results
>> What do you think ?
>>
>> Thanks.
>>
>>
>> jean-pierre
>>   
>
> -JRS
>
